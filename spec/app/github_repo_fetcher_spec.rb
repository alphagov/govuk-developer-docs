RSpec.describe GitHubRepoFetcher do
  describe "#repo" do
    it "returns a repo if the user is specified" do
      stub_request(:get, "https://api.github.com/repos/some-user/some-repo")
        .to_return(body: "{}", headers: { content_type: "application/json" })

      repo = GitHubRepoFetcher.instance.repo("some-user/some-repo")

      expect(repo).not_to be_nil
    end

    it "raises if no alphagov repo is found" do
      stub_request(:get, "https://api.github.com/users/alphagov/repos?per_page=100")
        .to_return(body: "[]", headers: { content_type: "application/json" })

      expect {
        GitHubRepoFetcher.instance.repo("something-not-here")
      }.to raise_error(StandardError)
    end
  end

  describe "#readme" do
    def readme_url(repo_name)
      "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/README.md"
    end

    it "caches the first response" do
      repo_name = SecureRandom.uuid
      stubbed_request = stub_request(:get, readme_url(repo_name))
        .to_return(status: 200, body: "Foo")

      GitHubRepoFetcher.instance.readme(repo_name)
      GitHubRepoFetcher.instance.readme(repo_name)
      expect(stubbed_request).to have_been_requested.once
    end

    it "retrieves the README content from the GitHub CDN" do
      repo_name = SecureRandom.uuid
      readme_contents = "# temporary-test"
      stub_request(:get, readme_url(repo_name))
        .to_return(status: 200, body: readme_contents)

      expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(readme_contents)
    end

    it "returns nil if no README exists" do
      repo_name = SecureRandom.uuid
      stub_request(:get, readme_url(repo_name))
        .to_return(status: 404)

      expect(GitHubRepoFetcher.instance.readme(repo_name)).to eq(nil)
    end
  end

  describe "#docs" do
    def docs_url(repo_name)
      "https://api.github.com/repos/alphagov/#{repo_name}/contents/docs"
    end

    it "returns an array of hashes including title derived from markdown contents" do
      repo_name = SecureRandom.uuid
      markdown_url = "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/docs/analytics.md"
      source_url = "https://github.com/alphagov/#{repo_name}/blob/master/docs/analytics.md"
      markdown_fixture = "# Analytics \n Foo"
      api_response = [
        {
          name: "analytics.md",
          download_url: markdown_url,
          html_url: source_url,
        },
      ]
      expected_output = [
        {
          title: "Analytics",
          path: "/apis/#{repo_name}/analytics.html",
          markdown: markdown_fixture,
          source_url: source_url,
        },
      ]
      stub_request(:get, docs_url(repo_name))
        .to_return(body: api_response.to_json, headers: { content_type: "application/json" })
      stub_request(:get, markdown_url).to_return(body: markdown_fixture)

      expect(GitHubRepoFetcher.instance.docs(repo_name)).to eq(expected_output)
    end

    it "skips over any non-markdown files" do
      repo_name = SecureRandom.uuid
      api_response = [
        {
          "name": "digests.png",
          "download_url": "https://raw.githubusercontent.com/alphagov/#{repo_name}/master/docs/digests.png",
        },
      ]
      stub_request(:get, docs_url(repo_name))
        .to_return(body: api_response.to_json, headers: { content_type: "application/json" })

      expect(GitHubRepoFetcher.instance.docs(repo_name)).to eq([])
    end

    it "returns nil if no docs folder exists" do
      repo_name = SecureRandom.uuid
      stub_request(:get, docs_url(repo_name))
        .to_return(status: 404, body: "{}", headers: { content_type: "application/json" })

      expect(GitHubRepoFetcher.instance.docs(repo_name)).to be_nil
    end
  end
end
