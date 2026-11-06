require "ostruct"

RSpec.describe GitHubRepoFetcher do
  before :each do
    stub_const("GitHubRepoFetcher::REPO_DIR", "#{Bundler.root}/spec/fixtures/repo-docs/".freeze)
    stub_request(:get, "https://api.github.com/users/alphagov/repos?per_page=100")
      .to_return(
        body: "[ { \"name\": \"some-repo\", \"default_branch\": \"main\" } ]",
        headers: { content_type: "application/json" },
      )
  end

  let(:private_repo) { double("Private repo", private_repo?: true) }
  let(:public_repo) { double("Public repo", private_repo?: false, default_branch: "main") }

  def stub_cache
    cache = double("CACHE")
    allow(cache).to receive(:fetch).and_yield
    stub_const("CACHE", cache)
    cache
  end

  describe "#instance" do
    it "acts as a singleton" do
      expect(GitHubRepoFetcher.instance).to be_a_kind_of(GitHubRepoFetcher)
      expect(GitHubRepoFetcher.instance).to eq(GitHubRepoFetcher.instance)
    end
  end

  describe "#prefetch" do
    let(:repos) do
      [
        double("Repo", repo_name: "app-one", import_rake_tasks?: true),
        double("Repo", repo_name: "app-two", import_rake_tasks?: false),
      ]
    end

    before :each do
      stub_cache
      allow_any_instance_of(GitHubRepoFetcher).to receive(:readme)
      allow_any_instance_of(GitHubRepoFetcher).to receive(:docs)
      allow_any_instance_of(GitHubRepoFetcher).to receive(:rake_tasks)
    end

    it "fetches the README and docs of every repo" do
      fetched = Queue.new
      allow_any_instance_of(GitHubRepoFetcher).to receive(:readme) { |_, name| fetched << [:readme, name] }
      allow_any_instance_of(GitHubRepoFetcher).to receive(:docs) { |_, name| fetched << [:docs, name] }

      GitHubRepoFetcher.new.prefetch(repos, threads: 2)

      expect(Array.new(fetched.size) { fetched.pop }).to contain_exactly(
        [:readme, "app-one"], [:docs, "app-one"], [:readme, "app-two"], [:docs, "app-two"]
      )
    end

    it "only fetches rake tasks for repos that import them" do
      fetched = Queue.new
      allow_any_instance_of(GitHubRepoFetcher).to receive(:rake_tasks) { |_, name| fetched << name }

      GitHubRepoFetcher.new.prefetch(repos, threads: 2)

      expect(Array.new(fetched.size) { fetched.pop }).to eq(%w[app-one])
    end

    it "raises errors from the worker threads" do
      allow_any_instance_of(GitHubRepoFetcher).to receive(:docs).and_raise(Octokit::ServerError)

      expect {
        GitHubRepoFetcher.new.prefetch(repos, threads: 1)
      }.to raise_error(Octokit::ServerError)
    end
  end

  describe "#repo" do
    it "fetches a repo from cache if it exists" do
      allow(stub_cache).to receive(:fetch).with("all-repos", hash_including(:expires_in)) do
        some_repo = public_repo
        allow(some_repo).to receive(:name).and_return("some-repo")
        [some_repo]
      end

      repo = GitHubRepoFetcher.new.repo("some-repo")

      expect(repo).not_to be_nil
    end

    it "fetches a repo from GitHub if it doesn't exist in the cache" do
      stub_cache
      repo = GitHubRepoFetcher.new.repo("some-repo")

      expect(repo).not_to be_nil
    end

    it "raises error if no repo is found" do
      expect {
        GitHubRepoFetcher.new.repo("something-not-here")
      }.to raise_error(StandardError)
    end
  end

  describe "#readme" do
    let(:repo_name) { "some-repo" }

    before :each do
      stub_cache
    end

    def readme_url
      "https://raw.githubusercontent.com/alphagov/#{repo_name}/main/README.md"
    end

    it "caches the first response" do
      allow(GitHubRepoFetcher.new).to receive(:repo).and_return(public_repo)
      stubbed_request = stub_request(:get, readme_url)
        .to_return(status: 200, body: "Foo")

      outcome = "pending"
      allow(stub_cache).to receive(:fetch) do |&block|
        outcome = block.call
      end

      GitHubRepoFetcher.new.readme(repo_name)
      expect(outcome).to eq("Foo")
      expect(stubbed_request).to have_been_requested.once
    end

    it "retrieves the README content from the GitHub CDN" do
      readme_contents = "# temporary-test"
      stubbed_request = stub_request(:get, readme_url)
        .to_return(status: 200, body: readme_contents)

      expect(GitHubRepoFetcher.new.readme(repo_name)).to eq(readme_contents)
      remove_request_stub(stubbed_request)
    end

    it "retrieves the README content from the repo's default branch" do
      readme_contents = "# temporary-test from different branch"
      instance = GitHubRepoFetcher.new
      allow(instance).to receive(:repo).with(repo_name) do
        OpenStruct.new(default_branch: "latest")
      end
      stubbed_request = stub_request(:get, readme_url.sub("main", "latest"))
        .to_return(status: 200, body: readme_contents)

      expect(instance.readme(repo_name)).to eq(readme_contents)
      remove_request_stub(stubbed_request)
    end

    it "returns nil if no README exists" do
      stubbed_request = stub_request(:get, readme_url)
        .to_return(status: 404)

      expect(GitHubRepoFetcher.new.readme(repo_name)).to eq(nil)
      remove_request_stub(stubbed_request)
    end

    it "returns nil if the repo is private" do
      instance = GitHubRepoFetcher.new
      allow(instance).to receive(:repo).with(repo_name).and_return(private_repo)

      expect(instance.readme(repo_name)).to eq(nil)
    end
  end

  describe "#docs" do
    let(:repo_name) { "some-repo" }
    let(:commit) { { sha: SecureRandom.hex(40), timestamp: Time.now.utc.to_s } }

    def github_repo_fetcher_returning(repo)
      instance = GitHubRepoFetcher.new
      allow(instance).to receive(:repo).with(repo_name).and_return(repo)
      allow(instance).to receive(:latest_commit).and_return(commit)
      instance
    end

    context "the repo contains a reachable docs/ folder" do
      let(:expected_hash_structure) { hash_including(:title, :markdown, :path, :relative_path, :source_url, :latest_commit) }

      it "derives each document title from its markdown" do
        instance = github_repo_fetcher_returning(public_repo)
        allow(File).to receive(:read).and_return("# title \n Some document")
        expect(instance.docs(repo_name).first[:title]).to eq("title")
      end

      it "derives document title from its filename if not present in markdown" do
        instance = github_repo_fetcher_returning(public_repo)
        allow(File).to receive(:read).and_return("bar \n Some document")
        expect(instance.docs(repo_name).first[:title]).to eq("foo")
      end

      it "maintains the original directory structure" do
        instance = github_repo_fetcher_returning(public_repo)
        doc = instance.docs(repo_name).second
        expect(doc[:path]).to eq("/repos/#{repo_name}/foo/bar.html")
        expect(doc[:relative_path]).to eq("docs/foo/bar.md")
      end

      it "retrieves documents recursively" do
        instance = github_repo_fetcher_returning(public_repo)
        expect(instance.docs(repo_name)).to include(expected_hash_structure)
      end

      it "skips over any non-markdown files" do
        instance = github_repo_fetcher_returning(public_repo)
        allow(Dir).to receive(:[]).and_return(["#{Bundler.root}/spec/fixtures/repo-docs/some-repo/docs/digests.png"])
        expect(instance.docs(repo_name)).to eq([])
      end
    end

    it "returns nil if no docs folder exists" do
      instance = github_repo_fetcher_returning(public_repo)
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with("#{Bundler.root}/spec/fixtures/repo-docs/some-repo/docs").and_return(false)
      expect(instance.docs(repo_name)).to eq(nil)
    end

    it "returns nil if the repo is private" do
      instance = github_repo_fetcher_returning(private_repo)
      expect(instance.docs(repo_name)).to eq(nil)
    end
  end

  describe "#rake_tasks" do
    let(:repo_name) { "some-app" }
    let(:active_repo) { double("Active repo", private_repo?: false, archived?: false) }
    let(:archived_repo) { double("Archived repo", private_repo?: false, archived?: true) }
    let(:client) { double("Octokit::Client") }

    before { stub_cache }

    def fetcher_for(github_repo)
      fetcher = GitHubRepoFetcher.new
      allow(fetcher).to receive(:repo).with(repo_name).and_return(github_repo)
      fetcher.instance_variable_set(:@client, client)
      fetcher
    end

    def rake_file(path, contents:)
      file = double("GitHub file", path:, type: "file", download_url: "https://raw/#{path}", html_url: "https://github.com/alphagov/some-app/blob/main/#{path}")
      allow(HTTP).to receive(:get).with(file.download_url).and_return(contents)
      file
    end

    it "parses every .rake file in lib/tasks, including subfolders" do
      top_level_file = rake_file("lib/tasks/reslug.rake", contents: "desc 'Reslug'\ntask :reslug")
      subfolder = double("GitHub folder", path: "lib/tasks/data", type: "dir")
      readme = double("GitHub file", path: "lib/tasks/README.md", type: "file")
      nested_file = rake_file("lib/tasks/data/export.rake", contents: "namespace :data do\n  desc 'Export'\n  task :export, %i[date] => :environment\nend")
      allow(client).to receive(:contents).with("alphagov/some-app", path: "lib/tasks").and_return([top_level_file, subfolder, readme])
      allow(client).to receive(:contents).with("alphagov/some-app", path: "lib/tasks/data").and_return([nested_file])

      expect(fetcher_for(active_repo).rake_tasks(repo_name)).to eq([
        {
          name: "reslug",
          command: "reslug",
          description: "Reslug",
          source_path: "lib/tasks/reslug.rake",
          source_url: "https://github.com/alphagov/some-app/blob/main/lib/tasks/reslug.rake#L2",
        },
        {
          name: "data:export",
          command: "data:export[date]",
          description: "Export",
          source_path: "lib/tasks/data/export.rake",
          source_url: "https://github.com/alphagov/some-app/blob/main/lib/tasks/data/export.rake#L3",
        },
      ])
    end

    it "returns nil if the repo has no lib/tasks folder" do
      allow(client).to receive(:contents).and_raise(Octokit::NotFound)

      expect(fetcher_for(active_repo).rake_tasks(repo_name)).to be_nil
    end

    it "returns nil without asking GitHub for files if the repo is private or archived" do
      expect(client).not_to receive(:contents)

      expect(fetcher_for(private_repo).rake_tasks(repo_name)).to be_nil
      expect(fetcher_for(archived_repo).rake_tasks(repo_name)).to be_nil
    end
  end
end
