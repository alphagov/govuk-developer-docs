RSpec.describe DocumentTypesCsv do
  describe ".to_csv" do
    it "returns document types" do
      stub_request(:get, "https://www.gov.uk/api/search.json?facet_content_store_document_type=500,examples:10,example_scope:global&count=0").
        to_return(
          body: File.read("spec/fixtures/search-api-app-search-response.json"),
          headers: {
            content_type: "application/json"
          }
        )

      stub_request(:get, "https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/lib/govuk_content_schemas/allowed_document_types.yml").
        to_return(body: File.read("spec/fixtures/allowed-document-types-fixture.yml"))

      stub_request(:get, "https://raw.githubusercontent.com/alphagov/govuk_document_types/master/data/supertypes.yml").
        to_return(body: File.read("spec/fixtures/supertypes.yml"))

      csv = DocumentTypes.to_csv

      expect(csv).to eql(File.read('spec/fixtures/document-types-export.csv'))
    end
  end
end
