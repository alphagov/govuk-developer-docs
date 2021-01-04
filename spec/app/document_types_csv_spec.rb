RSpec.describe DocumentTypesCsv do
  describe ".to_csv" do
    it "returns document types" do
      allow(DocumentTypes).to receive(:facet_query).and_return(
        JSON.parse(File.read("spec/fixtures/search-api-app-search-response.json")),
      )
      allow(DocumentTypes).to receive(:all_document_types).and_return(
        YAML.load_file("spec/fixtures/allowed-document-types-fixture.yml"),
      )
      allow(Supertypes).to receive(:data).and_return(
        YAML.load_file("spec/fixtures/supertypes.yml"),
      )

      csv = DocumentTypes.to_csv

      expect(csv).to eql(File.read("spec/fixtures/document-types-export.csv"))
    end
  end
end
