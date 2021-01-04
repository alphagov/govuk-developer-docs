RSpec.describe GitHubRepoFetcher do
  after :each do
    GitHubRepoFetcher.instance.cache = CACHE # Rails cache
  end

  let(:cache_containing_repo) do
    double("Cache containing repos", fetch: [OpenStruct.new({ name: "some-repo", default_branch: "master" })])
  end
  let(:cache_missing_repo) do
    double("Cache missing repos", fetch: [])
  end

  def empty_cache
    cache = double("Empty cache")
    allow(cache).to receive(:fetch).and_yield
    cache
  end

  let(:private_repo) { double("Private repo", private_repo?: true) }
  let(:public_repo) { double("Public repo", private_repo?: false) }

  describe "#repo" do
    it "fetches a repo from cache if it exists" do
      GitHubRepoFetcher.instance.cache = cache_containing_repo

      repo = GitHubRepoFetcher.instance.repo("some-repo")

      expect(repo).not_to be_nil
    end

    it "fetches a repo from GitHub if it doesn't exist in the cache" do
      GitHubRepoFetcher.instance.cache = empty_cache

      stub_request(:get, "https://api.github.com/users/alphagov/repos?per_page=100")
        .to_return(
          body: "[ { \"name\": \"some-repo\", \"default_branch\": \"master\" } ]",
          headers: { content_type: "application/json" },
        )

      repo = GitHubRepoFetcher.instance.repo("some-repo")

      expect(repo).not_to be_nil
    end

    it "raises error if no repo is found" do
      GitHubRepoFetcher.instance.cache = cache_missing_repo
      expect {
        GitHubRepoFetcher.instance.repo("something-not-here")
      }.to raise_error(StandardError)
    end
  end

  describe "#readme" do
    # before do
    #   allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(
    #     double("App", private_repo?: false, default_branch: "master"),
    #   )
    # end

    # let(:repo_name) { "some-repo" }

    # def readme_url
    #   "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/README.md"
    # end

    # it "caches the first response" do
    #   # require 'pry'
    #   # binding.pry
    #   GitHubRepoFetcher.instance.cache = empty_cache
    #   # puts GitHubRepoFetcher.instance.cache
    #   stubbed_request = stub_request(:get, readme_url)
    #     .to_return(status: 200, body: "Foo")

    #   GitHubRepoFetcher.instance.readme(repo_name)
    #   puts GitHubRepoFetcher.instance.readme(repo_name)
    #   GitHubRepoFetcher.instance.readme(repo_name)
    #   expect(stubbed_request).to have_been_requested.once
    #   remove_request_stub(stubbed_request)
    # end

    # it "retrieves the README content from the GitHub CDN" do
    #   GitHubRepoFetcher.instance.cache = empty_cache
    #   readme_contents = "# temporary-test"
    #   stubbed_request = stub_request(:get, readme_url)
    #     .to_return(status: 200, body: readme_contents)

    #   expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(readme_contents)
    #   remove_request_stub(stubbed_request)
    # end

    # it "retrieves the README content from the repo's default branch" do
    #   readme_contents = "# temporary-test from different branch"
    #   allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name) do
    #     OpenStruct.new(default_branch: "latest")
    #   end
    #   stubbed_request = stub_request(:get, readme_url.sub("master", "latest"))
    #     .to_return(status: 200, body: readme_contents)

    #   expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(readme_contents)
    #   remove_request_stub(stubbed_request)
    # end

    # it "returns nil if no README exists" do
    #   stubbed_request = stub_request(:get, readme_url)
    #     .to_return(status: 404)

    #   expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(nil)
    #   remove_request_stub(stubbed_request)
    # end

    # it "returns nil if the repo is private" do
    #   allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(private_repo)

    #   expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(nil)
    # end
  end

  # describe "#docs" do
  #   let(:repo_name) { SecureRandom.uuid }

  #   def docs_url(repo_name)
  #     "https://api.github.com/repos/alphagov/#{repo_name}/contents/docs"
  #   end

  #   it "returns an array of hashes including title derived from markdown contents" do
  #     markdown_url = "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/docs/analytics.md"
  #     source_url = "https://github.com/alphagov/#{repo_name}/blob/master/docs/analytics.md"
  #     markdown_fixture = "# Analytics \n Foo"
  #     path = "docs/analytics.md"
  #     default_branch = "main"
  #     latest_commit = { sha: SecureRandom.hex(40), timestamp: Time.now.utc.to_s }
  #     doc_response = [{ name: "analytics.md", path: path, download_url: markdown_url, html_url: source_url }]
  #     commit_response = [{ sha: latest_commit[:sha], commit: { author: { date: latest_commit[:timestamp] } } }]

  #     allow(GitHubRepoFetcher.instance).to receive(:repo)
  #       .with(repo_name) { OpenStruct.new(default_branch: default_branch) }
  #     stub_request(:get, docs_url(repo_name))
  #       .to_return(body: doc_response.to_json, headers: { content_type: "application/json" })
  #     stub_request(:get, "https://api.github.com/repos/alphagov/#{repo_name}/commits?path=#{path}&per_page=100&sha=#{default_branch}")
  #       .to_return(body: commit_response.to_json, headers: { content_type: "application/json" })
  #     stub_request(:get, markdown_url).to_return(body: markdown_fixture)

  #     expect(GitHubRepoFetcher.instance.docs(repo_name)).to eq([
  #       {
  #         title: "Analytics",
  #         path: "/apps/#{repo_name}/analytics.html",
  #         markdown: markdown_fixture,
  #         relative_path: path,
  #         source_url: source_url,
  #         latest_commit: latest_commit,
  #       },
  #     ])
  #   end

  #   it "skips over any non-markdown files" do
  #     api_response = [
  #       {
  #         "name": "digests.png",
  #         "download_url": "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/docs/digests.png",
  #       },
  #     ]
  #     stub_request(:get, docs_url(repo_name))
  #       .to_return(body: api_response.to_json, headers: { content_type: "application/json" })
  #     allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(public_repo)

  #     expect(GitHubRepoFetcher.instance.docs(repo_name)).to eq([])
  #   end

  #   it "returns nil if no docs folder exists" do
  #     stub_request(:get, docs_url(repo_name))
  #       .to_return(status: 404, body: "{}", headers: { content_type: "application/json" })
  #     allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(public_repo)

  #     expect(GitHubRepoFetcher.instance.docs(repo_name)).to be_nil
  #   end

  #   it "returns nil if the repo is private" do
  #     allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(private_repo)

  #     expect(GitHubRepoFetcher.instance.docs(repo_name)).to eq(nil)
  #   end
  # end
end
