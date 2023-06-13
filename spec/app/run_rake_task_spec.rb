require "capybara/rspec"

RSpec.describe RunRakeTask do
  describe "#links" do
    subject(:html) do
      Capybara.string(described_class.links(application, rake_task))
    end

    let(:rake_task) { "publishing_api:republish" }

    describe "given a Repo instance" do
      let(:application) do
        Repo.new(
          "repo_name" => "content-publisher",
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

      let(:application) { "ckanext-datagovuk" }

      it "has three links" do
        expect(html).to have_link("Run publishing_api:republish on Integration", href: "https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=ckanext-datagovuk&MACHINE_CLASS=ckan&RAKE_TASK=publishing_api:republish")
        expect(html).to have_link("Run publishing_api:republish on Staging", href: "https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=ckanext-datagovuk&MACHINE_CLASS=ckan&RAKE_TASK=publishing_api:republish")
        expect(html).to have_link("Run publishing_api:republish on Production", href: "https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=ckanext-datagovuk&MACHINE_CLASS=ckan&RAKE_TASK=publishing_api:republish")
      end
    end
  end

  describe "#terse_links" do
    subject(:html) do
      Capybara.string(described_class.terse_links(application))
    end

    describe "given a Repo instance" do
      let(:application) do
        Repo.new(
          "repo_name" => "content-publisher",
          "machine_class" => "backend",
          "production_hosted_on" => "aws",
        )
      end

      it "has three links" do
        expect(html).to have_link("Integration", href: "https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=")
        expect(html).to have_link("Staging", href: "https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=")
        expect(html).to have_link("Production", href: "https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=")
      end

      it "has aria labels that describe the links in isolation" do
        expect(html.find_link("Integration")["aria-label".to_sym]).to eq("Run a Rake task on Integration")
        expect(html.find_link("Staging")["aria-label".to_sym]).to eq("Run a Rake task on Staging")
        expect(html.find_link("Production")["aria-label".to_sym]).to eq("Run a Rake task on Production")
      end
    end
  end
end
