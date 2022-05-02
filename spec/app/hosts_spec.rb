RSpec.describe Hosts do
  before :each do
    allow(Repos).to receive(:all) do
      applications.map(&:stringify_keys).map { |repo_data| Repo.new(repo_data) }
    end
  end

  let(:applications) do
    [
      { github_repo_name: "whitehall", production_hosted_on: "aws" },
      { github_repo_name: "asset-manager", production_hosted_on: "aws" },
      { github_repo_name: "content-store", production_hosted_on: "aws" },
      { github_repo_name: "govuk-frontend", production_hosted_on: "aws" },
      { github_repo_name: "app-on-heroku", production_hosted_on: "heroku" },
      { github_repo_name: "app-on-paas", production_hosted_on: "paas" },
      { github_repo_name: "some-retired-application" },
    ]
  end

  describe "hosters_descending" do
    it "should return hosters in descending order of repo count" do
      expect(Hosts.hosters_descending(Repos.all).keys).to eq(%w[
        aws
        heroku
        paas
      ])
    end
  end

  describe "on_host" do
    it "should return apps hosted on the named host" do
      paas_app = Hosts.on_host(Repos.all, "paas").first
      expect(paas_app).to be_a(Repo)
      expect(paas_app.app_name).to eq("app-on-paas")
    end
  end
end
