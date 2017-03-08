require 'spec_helper'

RSpec.describe GitHub do
  describe "#repo" do
    it "returns a repo if the user is specified" do
      stub_request(:get, "https://api.github.com/repos/some-user/some-repo").
        to_return(body: "{}", headers: { content_type: "application/json" })

      repo = GitHub.new.repo("some-user/some-repo")

      expect(repo).not_to be_nil
    end

    it "raises if no alphagov repo is found" do
      stub_request(:get, "https://api.github.com/users/alphagov/repos?per_page=100").
        to_return(body: "[]", headers: { content_type: "application/json" })

      expect {
        GitHub.new.repo("something-not-here")
      }.to raise_error(StandardError)
    end
  end
end
