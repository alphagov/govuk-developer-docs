RSpec.describe GitHubRepoFetcher do
  before :each do
    stub_request(:get, "https://api.github.com/users/alphagov/repos?per_page=100")
      .to_return(
        body: "[ { \"name\": \"some-repo\", \"default_branch\": \"master\" } ]",
        headers: { content_type: "application/json" },
      )
  end

  let(:private_repo) { double("Private repo", private_repo?: true) }
  let(:public_repo) { double("Public repo", private_repo?: false, default_branch: "master") }

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
      "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/README.md"
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
      stubbed_request = stub_request(:get, readme_url.sub("master", "latest"))
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
    let(:repo_name) { SecureRandom.uuid }

    def docs_url(repo_name)
      "https://api.github.com/repos/alphagov/#{repo_name}/contents/docs"
    end

    def github_repo_fetcher_returning(repo)
      instance = GitHubRepoFetcher.new
      allow(instance).to receive(:repo).with(repo_name).and_return(repo)
      instance
    end

    context "the repo contains a reachable docs/ folder" do
      def with_stubbed_client(temporary_client, instance)
        before_client = instance.instance_variable_get(:@client)
        instance.instance_variable_set(:@client, temporary_client)
        yield
        instance.instance_variable_set(:@client, before_client)
      end

      let(:commit) { { sha: SecureRandom.hex(40), timestamp: Time.now.utc.to_s } }
      let(:doc_contents) { "# title \n Some document" }
      let(:doc_title_derived_from_contents) { "title" }

      it "returns an array of hashes including title derived from markdown contents" do
        doc = double("doc", type: "file", download_url: "foo_url", path: "docs/foo.md", html_url: "foo_html_url")

        instance = github_repo_fetcher_returning(public_repo)
        allow(instance).to receive(:latest_commit).and_return(commit)
        allow(HTTP).to receive(:get).with(doc.download_url).and_return(doc_contents)
        with_stubbed_client(double("Octokit::Client", contents: [doc]), instance) do
          expect(instance.docs(repo_name)).to eq([
            {
              title: doc_title_derived_from_contents,
              markdown: doc_contents,
              path: "/apps/#{repo_name}/foo.html",
              relative_path: "docs/foo.md",
              source_url: "foo_html_url",
              latest_commit: commit,
            },
          ])
        end
      end

      it "retrieves documents recursively" do
        dir = double("dir", type: "dir", path: "docs/foo")
        nested_doc = double("nested_doc", type: "file", path: "docs/foo/bar.md", download_url: "bar_url", html_url: "bar_html_url")

        instance = github_repo_fetcher_returning(public_repo)
        allow(instance).to receive(:latest_commit).and_return(commit)
        allow(HTTP).to receive(:get).with(nested_doc.download_url).and_return(doc_contents)
        stubbed_client = double("Octokit::Client")
        allow(stubbed_client).to receive(:contents).with("alphagov/#{repo_name}", path: "docs")
          .and_return([dir])
        allow(stubbed_client).to receive(:contents).with("alphagov/#{repo_name}", path: "docs/foo")
          .and_return([nested_doc])

        with_stubbed_client(stubbed_client, instance) do
          expect(instance.docs(repo_name)).to eq([
            {
              title: doc_title_derived_from_contents,
              markdown: doc_contents,
              path: "/apps/#{repo_name}/foo/bar.html",
              relative_path: "docs/foo/bar.md",
              source_url: "bar_html_url",
              latest_commit: commit,
            },
          ])
        end
      end

      it "skips over any non-markdown files" do
        instance = github_repo_fetcher_returning(public_repo)
        stubbed_client = double("Octokit::Client")
        allow(stubbed_client).to receive(:contents).with("alphagov/#{repo_name}", path: "docs")
          .and_return([double("non markdown file", type: "file", path: "docs/digests.png")])

        with_stubbed_client(stubbed_client, instance) do
          expect(instance.docs(repo_name)).to eq([])
        end
      end
    end

    it "returns nil if no docs folder exists" do
      instance = github_repo_fetcher_returning(public_repo)
      stub_request(:get, docs_url(repo_name))
        .to_return(status: 404, body: "{}", headers: { content_type: "application/json" })

      expect(instance.docs(repo_name)).to be_nil
    end

    it "returns nil if the repo is private" do
      instance = github_repo_fetcher_returning(private_repo)

      expect(instance.docs(repo_name)).to eq(nil)
    end
  end
end
