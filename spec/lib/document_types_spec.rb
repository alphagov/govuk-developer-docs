require "spec_helper"

RSpec.describe DocumentTypes do
  describe ".pages" do
    it "returns document types" do
      stub_request(:get, "https://www.gov.uk/api/search.json?count=0&facet_content_store_document_type=100,examples:10,example_scope:global").
        to_return(body: File.read("spec/fixtures/rummager-app-search-response.json"))

      document_type = DocumentTypes.pages.first

      expect(document_type.examples.first).to eql(
        "title" => "Disclosure and Barring Service – About us",
        "link" => "/government/organisations/disclosure-and-barring-service/about"
      )
    end
  end
end
