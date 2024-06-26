RSpec.describe DocumentTypes do
  describe ".pages" do
    it "returns document types" do
      stub_request(:get, "https://www.gov.uk/api/search.json?facet_content_store_document_type=500,examples:10,example_scope:global&count=0")
        .to_return(
          body: File.read("spec/fixtures/search-api-app-search-response.json"),
          headers: {
            content_type: "application/json",
          },
        )

      stub_request(:get, "https://raw.githubusercontent.com/alphagov/publishing-api/main/content_schemas/allowed_document_types.yml")
        .to_return(body: File.read("spec/fixtures/allowed-document-types-fixture.yml"))

      document_type = DocumentTypes.pages.first

      expect(document_type.examples.first.keys.sort).to eql(%w[link title])
    end
  end

  describe "#schema_names_by_document_type" do
    it "returns schema names by document type" do
      schema_name = "aaib_report"
      allow(SchemaNames).to receive(:all).and_return([schema_name])
      allow(GovukSchemas::Schema).to receive(:find).with(notification_schema: schema_name).and_return({
        properties: {
          document_type: {
            enum: %w[
              embassies_index
              field_of_operation
            ],
          },
        },
      }.as_json)

      expect(DocumentTypes.schema_names_by_document_type).to eq({
        embassies_index: [schema_name],
        field_of_operation: [schema_name],
      }.as_json)
    end
  end

  describe "DocumentTypes::Page.schemas" do
    it "shifts low value schemas to the bottom of the list" do
      allow(DocumentTypes).to receive(:schema_names_by_document_type).and_return({
        "aaib_report": %w[
          generic
          generic_with_external_links
          placeholder
          x_something
          z_something
        ],
      }.as_json)
      page = DocumentTypes::Page.new(name: "aaib_report", total_count: nil, examples: nil)

      expect(page.schemas).to eq(%w[
        x_something
        z_something
        generic
        generic_with_external_links
        placeholder
      ])
    end
  end
end
