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

  describe "hosters_descending" do
    it "should return hosters in descending order of repo count" do
      expect(AppDocs::hosters_descending.keys).to eq(%w[
        aws
        carrenza
        heroku
        paas
        none
        ukcloud
      ])
    end
  end

  describe "apps_on_host" do
    it "should return apps hosted on the named host" do
      production_apps_count = AppDocs::pages.count { |app| app.production_hosted_on.present? }
      apps_by_host = AppDocs::HOSTERS.map { |key, _val| AppDocs::apps_on_host(key) }.flatten
      expect(apps_by_host).to all(be_an(AppDocs::App))
      expect(apps_by_host.count).to eq(production_apps_count)
    end

    it "should return apps in alphabetical order" do
      apps_on_aws = AppDocs::apps_on_host("aws")
      expect(apps_on_aws.first.app_name).to eq("asset-manager")
      expect(apps_on_aws.last.app_name).to eq("whitehall")
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
