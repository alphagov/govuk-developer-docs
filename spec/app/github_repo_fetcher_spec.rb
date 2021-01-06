RSpec.describe GitHubRepoFetcher do
  before :each do
    stub_request(:get, "https://api.github.com/users/alphagov/repos?per_page=100")
      .to_return(
        body: "[ { \"name\": \"some-repo\", \"default_branch\": \"master\" } ]",
        headers: { content_type: "application/json" },
      )
  end

  let(:repo) do
    double("stubbed repo", name: "some-repo", private_repo?: false, default_branch: "master")
  end
  let(:private_repo) { double("Private repo", private_repo?: true) }
  let(:public_repo) { double("Public repo", private_repo?: false) }

  describe "#repo" do
    it "fetches a repo from cache if it exists" do
      allow(CACHE).to receive(:fetch).with("all-repos", hash_including(:expires_in)) do
        [OpenStruct.new({ name: "some-repo", default_branch: "master" })]
      end

      repo = GitHubRepoFetcher.instance.repo("some-repo")

      expect(repo).not_to be_nil
    end

    it "fetches a repo from GitHub if it doesn't exist in the cache" do
      allow(CACHE).to receive(:fetch).and_yield

      repo = GitHubRepoFetcher.instance.repo("some-repo")

      expect(repo).not_to be_nil
    end

    it "raises error if no repo is found" do
      expect {
        GitHubRepoFetcher.instance.repo("something-not-here")
      }.to raise_error(StandardError)
    end
  end

  describe "#readme" do
    let(:repo_name) { "some-repo" }

    before :each do
      allow(CACHE).to receive(:fetch).and_yield
    end

    def readme_url
      "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/README.md"
    end

    it "caches the first response" do
      allow(GitHubRepoFetcher.instance).to receive(:repo).and_return(repo)
      stubbed_request = stub_request(:get, readme_url)
        .to_return(status: 200, body: "Foo")

      outcome = "pending"
      allow(CACHE).to receive(:fetch) do |&block|
        outcome = block.call
      end

      GitHubRepoFetcher.instance.readme(repo_name)
      expect(outcome).to eq("Foo")
      expect(stubbed_request).to have_been_requested.once
    end

    it "retrieves the README content from the GitHub CDN" do
      readme_contents = "# temporary-test"
      stubbed_request = stub_request(:get, readme_url)
        .to_return(status: 200, body: readme_contents)

      expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(readme_contents)
      remove_request_stub(stubbed_request)
    end

    it "retrieves the README content from the repo's default branch" do
      readme_contents = "# temporary-test from different branch"
      allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name) do
        OpenStruct.new(default_branch: "latest")
      end
      stubbed_request = stub_request(:get, readme_url.sub("master", "latest"))
        .to_return(status: 200, body: readme_contents)

      expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(readme_contents)
      remove_request_stub(stubbed_request)
    end

    it "returns nil if no README exists" do
      stubbed_request = stub_request(:get, readme_url)
        .to_return(status: 404)

      expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(nil)
      remove_request_stub(stubbed_request)
    end

    it "returns nil if the repo is private" do
      allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(private_repo)

      expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(nil)
    end
  end

  describe "#docs" do
    let(:repo_name) { SecureRandom.uuid }

    def docs_url(repo_name)
      "https://api.github.com/repos/alphagov/#{repo_name}/contents/docs"
    end

    it "returns an array of hashes including title derived from markdown contents" do
      markdown_url = "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/docs/analytics.md"
      source_url = "https://github.com/alphagov/#{repo_name}/blob/master/docs/analytics.md"
      markdown_fixture = "# Analytics \n Foo"
      path = "docs/analytics.md"
      default_branch = "main"
      latest_commit = { sha: SecureRandom.hex(40), timestamp: Time.now.utc.to_s }
      doc_response = [{ name: "analytics.md", path: path, download_url: markdown_url, html_url: source_url }]
      commit_response = [{ sha: latest_commit[:sha], commit: { author: { date: latest_commit[:timestamp] } } }]

      allow(GitHubRepoFetcher.instance).to receive(:repo)
        .with(repo_name) { OpenStruct.new(default_branch: default_branch) }
      stub_request(:get, docs_url(repo_name))
        .to_return(body: doc_response.to_json, headers: { content_type: "application/json" })
      stub_request(:get, "https://api.github.com/repos/alphagov/#{repo_name}/commits?path=#{path}&per_page=100&sha=#{default_branch}")
        .to_return(body: commit_response.to_json, headers: { content_type: "application/json" })
      stub_request(:get, markdown_url).to_return(body: markdown_fixture)

      expect(GitHubRepoFetcher.instance.docs(repo_name)).to eq([
        {
          title: "Analytics",
          path: "/apps/#{repo_name}/analytics.html",
          markdown: markdown_fixture,
          relative_path: path,
          source_url: source_url,
          latest_commit: latest_commit,
        },
      ])
    end

    it "skips over any non-markdown files" do
      api_response = [
        {
          "name": "digests.png",
          "download_url": "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/docs/digests.png",
        },
      ]
      stub_request(:get, docs_url(repo_name))
        .to_return(body: api_response.to_json, headers: { content_type: "application/json" })
      allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(public_repo)

      expect(GitHubRepoFetcher.instance.docs(repo_name)).to eq([])
    end

    it "returns nil if no docs folder exists" do
      stub_request(:get, docs_url(repo_name))
        .to_return(status: 404, body: "{}", headers: { content_type: "application/json" })
      allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(public_repo)

      expect(GitHubRepoFetcher.instance.docs(repo_name)).to be_nil
    end

    it "returns nil if the repo is private" do
      allow(GitHubRepoFetcher.instance).to receive(:repo).with(repo_name).and_return(private_repo)

      expect(GitHubRepoFetcher.instance.docs(repo_name)).to eq(nil)
    end
  end
end
