RSpec.describe DocumentTypes do
  describe ".pages" do
    it "returns document types" do
      stub_request(:get, "https://www.gov.uk/api/search.json?facet_content_store_document_type=500,examples:10,example_scope:global&count=0").
        to_return(
          body: File.read("spec/fixtures/search-api-app-search-response.json"),
          headers: {
            content_type: "application/json",
          },
        )

      stub_request(:get, "https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/lib/govuk_content_schemas/allowed_document_types.yml").
        to_return(body: File.read("spec/fixtures/allowed-document-types-fixture.yml"))

      document_type = DocumentTypes.pages.first

      expect(document_type.examples.first.keys).to eql(%w[title link])
    end
  end
end
