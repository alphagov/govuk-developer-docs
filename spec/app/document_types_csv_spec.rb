RSpec.describe DocumentTypesCsv do
  describe ".to_csv" do
    it "returns document types" do
      stub_request(:get, "https://www.gov.uk/api/search.json?count=0&facet_content_store_document_type=500,examples:10,example_scope:global").
        to_return(
          body: File.read("spec/fixtures/search-api-app-search-response.json"),
          headers: {
            content_type: "application/json"
          }
        )

      stub_request(:get, "https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/lib/govuk_content_schemas/allowed_document_types.yml").
        to_return(body: File.read("spec/fixtures/allowed-document-types-fixture.json"))

      stub_request(:get, "https://raw.githubusercontent.com/alphagov/govuk_document_types/master/data/supertypes.yml").
        to_return(body: File.read("spec/fixtures/supertypes.yml"))

      csv = DocumentTypes.to_csv

      expect(csv).to eql(File.read('spec/fixtures/document-types-export.csv'))
    end
  end
end
