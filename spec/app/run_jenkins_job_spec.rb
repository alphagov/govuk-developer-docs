require "capybara/rspec"

RSpec.describe RunJenkinsJob do
  describe "#links" do
    subject(:html) do
      Capybara.string(described_class.links(jenkins_job))
    end

    let(:jenkins_job) { "SomeTask" }

    it "has three links" do
      expect(html).to have_link("Run SomeTask on Integration", href: "https://deploy.integration.publishing.service.gov.uk/job/SomeTask")
      expect(html).to have_link("Run SomeTask on Staging", href: "https://deploy.blue.staging.govuk.digital/job/SomeTask")
      expect(html).to have_link("Run SomeTask on Production", href: "https://deploy.blue.production.govuk.digital/job/SomeTask")
    end
  end

  describe "#terse_links" do
    subject(:html) do
      Capybara.string(described_class.terse_links(jenkins_job))
    end

    let(:jenkins_job) { "SomeTask" }

    it "has three links" do
      expect(html).to have_link("Integration", href: "https://deploy.integration.publishing.service.gov.uk/job/SomeTask")
      expect(html).to have_link("Staging", href: "https://deploy.blue.staging.govuk.digital/job/SomeTask")
      expect(html).to have_link("Production", href: "https://deploy.blue.production.govuk.digital/job/SomeTask")
    end

    it "has aria labels that describe the links in isolation" do
      expect(html.find_link("Integration")["aria-label".to_sym]).to eq("Run SomeTask on Integration")
      expect(html.find_link("Staging")["aria-label".to_sym]).to eq("Run SomeTask on Staging")
      expect(html.find_link("Production")["aria-label".to_sym]).to eq("Run SomeTask on Production")
    end
  end
end
