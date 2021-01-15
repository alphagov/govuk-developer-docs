RSpec.describe Applications do
  before :each do
    allow(Applications).to receive(:all) do
      applications.map(&:stringify_keys).map { |app_data| App.new(app_data) }
    end
  end

  let(:applications) do
    [
      { github_repo_name: "whitehall", production_hosted_on: "aws" },
      { github_repo_name: "asset-manager", production_hosted_on: "aws" },
      { github_repo_name: "content-store", production_hosted_on: "aws" },
      { github_repo_name: "govuk-frontend", production_hosted_on: "aws" },
      { github_repo_name: "collections-publisher", production_hosted_on: "carrenza" },
      { github_repo_name: "second-app-on-carrenza", production_hosted_on: "carrenza" },
      { github_repo_name: "app-on-heroku", production_hosted_on: "heroku" },
      { github_repo_name: "app-on-paas", production_hosted_on: "paas" },
      { github_repo_name: "some-retired-application" },
    ]
  end

  describe "hosters_descending" do
    it "should return hosters in descending order of repo count" do
      expect(Applications.hosters_descending.keys).to eq(%w[
        aws
        carrenza
        heroku
        paas
        none
        ukcloud
      ])
    end
  end

  describe "on_host" do
    it "should return apps hosted on the named host" do
      paas_app = Applications.on_host("paas").first
      expect(paas_app).to be_an(App)
      expect(paas_app.app_name).to eq("app-on-paas")
    end

    it "should return all apps in production" do
      production_apps_count = applications.count { |app| app[:production_hosted_on].present? }
      apps_by_host = Applications::HOSTERS.map { |key, _val| Applications.on_host(key) }.flatten
      expect(apps_by_host.count).to eq(production_apps_count)
    end

    it "should return apps in alphabetical order" do
      apps_on_aws = Applications.on_host("aws")
      expect(apps_on_aws.map(&:app_name)).to eq(%w[
        asset-manager
        content-store
        govuk-frontend
        whitehall
      ])
    end
  end
end
