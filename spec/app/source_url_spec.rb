Dir.glob(::File.expand_path("../../helpers/**/*.rb", __FILE__)).each { |f| require_relative f }

RSpec.describe SourceUrl do
  describe "#source_url" do
    it "returns the URL from the page local" do
      locals = { page: double(source_url: "https://example.org/via-page") }

      source_url = SourceUrl.new(locals, double).source_url

      expect(source_url).to eql("https://example.org/via-page")
    end

    it "returns the URL from the frontmatter" do
      current_page = double(data: double(source_url: "https://example.org/via-frontmatter"))

      source_url = SourceUrl.new({}, current_page).source_url

      expect(source_url).to eql("https://example.org/via-frontmatter")
    end

    it "returns the source from this repository" do
      current_page = double(data: double(source_url: nil), file_descriptor: { relative_path: "foo.html.md" })

      source_url = SourceUrl.new({}, current_page).source_url

      expect(source_url).to eql("https://github.com/alphagov/govuk-developer-docs/blob/master/source/foo.html.md")
    end
  end
end
