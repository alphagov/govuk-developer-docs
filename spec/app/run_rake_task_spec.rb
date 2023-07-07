require "capybara/rspec"

RSpec.describe RunRakeTask do
  describe "#links" do
    subject(:html) do
      Capybara.string(described_class.links(application, rake_task))
    end

    describe "given a Repo instance" do
      let(:application) do
        Repo.new(
          "repo_name" => "content-publisher",
        )
      end
      let(:rake_task) { "publishing_api:republish" }

      it "contains the app name" do
        expect(html).to have_text("content-publisher")
      end
      it "contains the full name of the Rake task" do
        expect(html).to have_text(" publishing_api:republish")
      end
    end

    describe "given an application name" do
      let(:application) { "ckanext-datagovuk" }
      let(:rake_task) { "do:something" }

      it "contains the app name" do
        expect(html).to have_text("ckanext-datagovuk ")
      end
      it "contains the full name of the Rake task" do
        expect(html).to have_text(" do:something")
      end
    end
  end
end
