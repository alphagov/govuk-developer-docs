require "capybara/rspec"

RSpec.describe RunRakeTask do
  describe "#links" do
    subject(:html) do
      Capybara.string(described_class.links(application, rake_task))
    end

    let(:rake_task) { "publishing_api:republish" }

    describe "given an application instance" do
      let(:application) do
        AppDocs::App.new(
          "github_repo_name" => "content-publisher",
          "machine_class" => "backend",
          "production_hosted_on" => "aws",
        )
      end

      it "has three links" do
        expect(html).to have_link("Run publishing_api:republish on Integration", href: "https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish")
        expect(html).to have_link("Run publishing_api:republish on Staging", href: "https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish")
        expect(html).to have_link("Run publishing_api:republish on Production", href: "https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish")
      end
    end

    describe "given an application name" do
      before do
        stub_request(:get, "https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata_aws/common.yaml")
          .to_return(body: File.read("spec/fixtures/puppet-hieradata-common.yaml"))
      end

      let(:application) { "content-publisher" }

      it "has three links" do
        expect(html).to have_link("Run publishing_api:republish on Integration", href: "https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish")
        expect(html).to have_link("Run publishing_api:republish on Staging", href: "https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish")
        expect(html).to have_link("Run publishing_api:republish on Production", href: "https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish")
      end
    end
  end
end
