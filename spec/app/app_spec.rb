RSpec.describe App do
  describe "production_url" do
    it "has a good default" do
      app = App.new("type" => "Publishing app", "github_repo_name" => "my-app")

      expect(app.production_url).to eql("https://my-app.publishing.service.gov.uk")
    end

    it "allows override" do
      app = App.new("type" => "Publishing app", "production_url" => "something else")

      expect(app.production_url).to eql("something else")
    end
  end

  describe "aws_puppet_class" do
    before do
      app_data = {
        "calculators_frontend" => {
          "apps" => %w[
            calculators
            finder-frontend
            licencefinder
            smartanswers
          ],
        },
      }
      allow(Applications).to receive(:aws_machines).and_return(app_data)
    end

    it "should find puppet class via github repo name if neither app name nor puppet name provided" do
      expect(App.new("github_repo_name" => "calculators").aws_puppet_class).to eq("calculators_frontend")
    end

    it "should find puppet class via app name" do
      expect(App.new("app_name" => "calculators").aws_puppet_class).to eq("calculators_frontend")
    end

    it "should find puppet class via puppet name" do
      expect(App.new("puppet_name" => "smartanswers", "github_repo_name" => "foo").aws_puppet_class).to eq("calculators_frontend")
    end

    it "should return error message if no puppet class found" do
      expect(App.new("github_repo_name" => "foo").aws_puppet_class)
        .to eq("Unknown - have you configured and merged your app in govuk-puppet/hieradata_aws/common.yaml")
    end
  end

  describe "dashboard_url" do
    let(:production_hosted_on) { nil }
    let(:app) do
      described_class.new(
        "type" => "Publishing app",
        "github_repo_name" => "my-app",
        "production_hosted_on" => production_hosted_on,
      )
    end
    subject(:dashboard_url) { app.dashboard_url }

    describe "hosted on AWS" do
      let(:production_hosted_on) { "aws" }
      it { is_expected.to eql("https://grafana.production.govuk.digital/dashboard/file/my-app.json") }
    end

    describe "hosted on Carrenza" do
      let(:production_hosted_on) { "carrenza" }
      it { is_expected.to eql("https://grafana.publishing.service.gov.uk/dashboard/file/my-app.json") }
    end
  end

  describe "rake_task_url" do
    let(:production_hosted_on) { nil }
    let(:environment) { nil }
    let(:rake_task) { "" }
    let(:app) do
      described_class.new(
        "github_repo_name" => "content-publisher",
        "machine_class" => "backend",
        "production_hosted_on" => production_hosted_on,
      )
    end
    subject(:dashboard_url) { app.rake_task_url(environment, rake_task) }

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

    describe "hosted on Carrenza and environment is production" do
      let(:production_hosted_on) { "carrenza" }
      let(:environment) { "production" }

      it { is_expected.to eql("https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=") }

      describe "with a Rake task" do
        let(:rake_task) { "task" }
        it { is_expected.to eql("https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=task") }
      end
    end

    describe "hosted on Carrenza and environment is integration" do
      let(:production_hosted_on) { "carrenza" }
      let(:environment) { "integration" }

      it { is_expected.to eql("https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=") }

      describe "with a Rake task" do
        let(:rake_task) { "task" }
        it { is_expected.to eql("https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=task") }
      end
    end
  end
end
