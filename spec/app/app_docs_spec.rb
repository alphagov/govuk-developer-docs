RSpec.describe AppDocs::App do
  describe "production_url" do
    it "has a good default" do
      app = AppDocs::App.new("type" => "Publishing app", "github_repo_name" => "my-app")

      expect(app.production_url).to eql("https://my-app.publishing.service.gov.uk")
    end

    it "allows override" do
      app = AppDocs::App.new("type" => "Publishing app", "production_url" => "something else")

      expect(app.production_url).to eql("something else")
    end
  end

  describe "dashboard_url" do
    let(:production_hosted_on) { nil }
    let(:app) do
      described_class.new(
        "type" => "Publishing app",
        "puppet_name" => "my_app",
        "production_hosted_on" => production_hosted_on,
      )
    end
    subject(:dashboard_url) { app.dashboard_url }

    describe "hosted on AWS" do
      let(:production_hosted_on) { "aws" }
      it { is_expected.to eql("https://grafana.production.govuk.digital/dashboard/file/my_app.json") }
    end

    describe "hosted on Carrenza" do
      let(:production_hosted_on) { "carrenza" }
      it { is_expected.to eql("https://grafana.publishing.service.gov.uk/dashboard/file/my_app.json") }
    end
  end
end
