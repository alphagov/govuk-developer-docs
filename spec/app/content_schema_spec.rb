RSpec.describe ContentSchema do
  describe "#frontend_schema" do
    it "it can link to GitHub" do
      schema = ContentSchema.new("generic").frontend_schema

      expect(schema.link_to_github).to eql("https://github.com/alphagov/govuk-content-schemas/blob/master/dist/formats/generic/frontend/schema.json")
    end

    it "it has a random example" do
      schema = ContentSchema.new("generic").frontend_schema

      expect(schema.random_example["content_id"]).not_to be_nil
    end

    it "it has properties with inlined definitions" do
      schema = ContentSchema.new("generic").frontend_schema

      expect(schema.properties["base_path"]["$ref"]).to eql(nil)
      expect(schema.properties["base_path"]["type"]).to eql("string")
    end
  end

  describe "#publisher_content_schema" do
    it "it can link to GitHub" do
      schema = ContentSchema.new("generic").publisher_content_schema

      expect(schema.link_to_github).to eql("https://github.com/alphagov/govuk-content-schemas/blob/master/dist/formats/generic/publisher/schema.json")
    end

    it "it has a random example" do
      schema = ContentSchema.new("generic").publisher_content_schema

      expect(schema.random_example["base_path"]).not_to be_nil
    end

    it "it has properties with inlined definitions" do
      schema = ContentSchema.new("generic").publisher_content_schema

      expect(schema.properties["base_path"]["$ref"]).to eql(nil)
      expect(schema.properties["base_path"]["type"]).to eql("string")
    end
  end

  describe "#publisher_links_schema" do
    it "it can link to GitHub" do
      schema = ContentSchema.new("generic").publisher_links_schema

      expect(schema.link_to_github).to eql("https://github.com/alphagov/govuk-content-schemas/blob/master/dist/formats/generic/publisher/links.json")
    end
  end
end
