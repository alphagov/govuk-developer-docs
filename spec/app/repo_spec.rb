RSpec.describe Repo do
  describe "is_app?" do
    it "returns false if 'production_hosted_on' is omitted" do
      expect(Repo.new({}).is_app?).to be(false)
    end

    it "returns true if 'production_hosted_on' is supplied" do
      expect(Repo.new({ "production_hosted_on" => "aws" }).is_app?).to be(true)
    end
  end

  describe "app_name" do
    it "returns repo_name if app_name not specified" do
      expect(Repo.new({ "repo_name" => "foo" }).app_name).to eq("foo")
    end

    it "returns app_name if both app_name and repo_name are specified" do
      expect(Repo.new({ "app_name" => "foo", "repo_name" => "bar" }).app_name).to eq("foo")
    end
  end

  describe "api_payload" do
    it "returns a hash of keys describing the app" do
      app_details = {
        "repo_name" => "foo",
        "team" => "bar",
        "dependencies_team" => "baz",
        "production_hosted_on" => "aws",
      }
      payload = Repo.new(app_details).api_payload
      expect(payload[:app_name]).to eq(app_details["repo_name"])
      expect(payload[:team]).to eq(app_details["team"])
      expect(payload[:dependencies_team]).to eq(app_details["dependencies_team"])
      expect(payload[:production_hosted_on]).to eq(app_details["production_hosted_on"])
      expect(payload[:links]).to include(:self, :html_url, :repo_url, :sentry_url)
    end
  end

  describe "production_url" do
    it "has a good default" do
      app = Repo.new("type" => "Publishing apps", "repo_name" => "my-app")

      expect(app.production_url).to eql("https://my-app.publishing.service.gov.uk")
    end

    it "allows override" do
      app = Repo.new("type" => "Publishing apps", "production_url" => "something else")

      expect(app.production_url).to eql("something else")
    end
  end

  describe "aws_puppet_class" do
    before do
      repo_data = {
        "calculators_frontend" => {
          "apps" => %w[
            finder-frontend
            licencefinder
            smartanswers
          ],
        },
      }
      allow(Hosts).to receive(:aws_machines).and_return(repo_data)
    end

    it "should find puppet class via github repo name if neither app name nor puppet name provided" do
      expect(Repo.new("repo_name" => "finder-frontend").aws_puppet_class).to eq("calculators_frontend")
    end

    it "should find puppet class via shortname" do
      expect(Repo.new("shortname" => "smartanswers", "repo_name" => "foo").aws_puppet_class).to eq("calculators_frontend")
    end

    it "should return error message if no puppet class found" do
      expect(Repo.new("repo_name" => "foo").aws_puppet_class)
        .to eq("Unknown - have you configured and merged your app in govuk-puppet/hieradata_aws/common.yaml")
    end
  end

  describe "dashboard_url" do
    let(:configured_dashboard_url) { nil }
    let(:app) do
      described_class.new(
        "type" => "Publishing app",
        "repo_name" => "my-app",
        "dashboard_url" => configured_dashboard_url,
      )
    end
    subject(:dashboard_url) { app.dashboard_url }

    describe "configured dashboard_url set to false" do
      let(:configured_dashboard_url) { false }
      it { is_expected.to be_nil }
    end

    describe "configured dashboard_url" do
      let(:configured_dashboard_url) { "https://example.com" }
      it { is_expected.to eql("https://example.com") }
    end

    describe "default dashboard_url" do
      it { is_expected.to eql("https://grafana.production.govuk.digital/dashboard/file/my-app.json") }
    end
  end

  describe "rake_task_url" do
    let(:production_hosted_on) { nil }
    let(:environment) { nil }
    let(:rake_task) { "" }
    let(:app) do
      described_class.new(
        "repo_name" => "content-publisher",
        "machine_class" => "backend",
        "production_hosted_on" => production_hosted_on,
      )
    end
    subject(:dashboard_url) { app.rake_task_url(environment, rake_task) }

    describe "not hosted on AWS" do
      it { is_expected.to be_nil }
    end

    describe "hosted on AWS and environment is production" do
      let(:production_hosted_on) { "aws" }
      let(:environment) { "production" }

      it { is_expected.to eql("https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=") }

      describe "with a Rake task" do
        let(:rake_task) { "task" }
        it { is_expected.to eql("https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=task") }
      end
    end

    describe "hosted on AWS and environment is integration" do
      let(:production_hosted_on) { "aws" }
      let(:environment) { "integration" }

      it { is_expected.to eql("https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=") }

      describe "with a Rake task" do
        let(:rake_task) { "task" }
        it { is_expected.to eql("https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=task") }
      end
    end
  end
end
