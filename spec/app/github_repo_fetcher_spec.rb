RSpec.describe GitHubRepoFetcher do
  describe "#repo" do
    it "returns a repo if the user is specified" do
      stub_request(:get, "https://api.github.com/repos/some-user/some-repo")
        .to_return(body: "{}", headers: { content_type: "application/json" })

      repo = GitHubRepoFetcher.new.repo("some-user/some-repo")

      expect(repo).not_to be_nil
    end

    it "raises if no alphagov repo is found" do
      stub_request(:get, "https://api.github.com/users/alphagov/repos?per_page=100")
        .to_return(body: "[]", headers: { content_type: "application/json" })

      expect {
        GitHubRepoFetcher.new.repo("something-not-here")
      }.to raise_error(StandardError)
    end
  end

  describe "#readme" do
    it "caches the first response" do
      repo_name = SecureRandom.uuid
      api_endpoint = "https://api.github.com/repos/alphagov/#{repo_name}/readme"
      stubbed_request = stub_request(:get, api_endpoint)
        .to_return(status: 200, body: '{ "content": "" }', headers: { content_type: "application/json" })

      GitHubRepoFetcher.new.readme(repo_name)
      GitHubRepoFetcher.new.readme(repo_name)
      expect(stubbed_request).to have_been_requested.once
    end

    it "retrieves the README content from the GitHub API response" do
      repo_name = SecureRandom.uuid
      readme_contents = "# temporary-test"
      base64_readme_contents = "IyB0ZW1wb3JhcnktdGVzdA=="
      response = { "content": base64_readme_contents }
      stub_request(:get, "https://api.github.com/repos/alphagov/#{repo_name}/readme")
        .to_return(status: 200, body: response.to_json, headers: { content_type: "application/json" })

      expect(GitHubRepoFetcher.new.readme(repo_name)).to eq(readme_contents)
    end

    it "forces encoding to UTF-8" do
      repo_name = SecureRandom.uuid
      stub_request(:get, "https://api.github.com/repos/alphagov/#{repo_name}/readme")
        .to_return(status: 200, body: '{ "content": "" }', headers: { content_type: "application/json" })
      encoded_input = "abc½½½".force_encoding("iso-8859-1")
      allow(Base64).to receive(:decode64).and_return(encoded_input.dup)

      decoded_output = GitHubRepoFetcher.new.readme(repo_name)
      expect(encoded_input.encoding.name).to eq("ISO-8859-1")
      expect(decoded_output.encoding.name).to eq("UTF-8")
    end

    it "returns nil if no README exists" do
      repo_name = SecureRandom.uuid
      stub_request(:get, "https://api.github.com/repos/alphagov/#{repo_name}/readme")
        .to_return(status: 404, body: "{}", headers: { content_type: "application/json" })

      expect(GitHubRepoFetcher.new.readme(repo_name)).to eq(nil)
    end
  end
end
