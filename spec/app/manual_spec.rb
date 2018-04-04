RSpec.describe Manual do
  describe '#manual_pages_grouped_by_section' do
    it "returns the correct groups" do
      sitemap = double(resources: [
        double(path: "foo.html", data: double(title: "Won't be included", important: true, review_by: Date.today, section: "Foo")),
        double(path: "manual/foo.html", data: double(title: "Foo", important: true, review_by: Date.today, section: "Foo")),
        double(path: "manual/bar.html", data: double(title: "Bar", important: true, review_by: Date.today, section: "Bar")),
      ])

      manual_pages_grouped_by_section = Manual.new(sitemap).manual_pages_grouped_by_section

      expect(manual_pages_grouped_by_section.map(&:first)).to eql(["Common tasks", "Bar", "Foo"])
    end
  end

  describe '#other_pages_from_section' do
    it "returns the correct groups" do
      one = double(path: "manual/foo.html", data: double(title: "Foo", important: true, section: "A section"))
      other = double(path: "manual/bar.html", data: double(title: "Bar", important: true, section: "A section"))

      sitemap = double(resources: [
        one,
        other,
        double(path: "manual/baz.html", data: double(title: "Baz", section: "B section")),
      ])

      other_pages_from_section = Manual.new(sitemap).other_pages_from_section(one)

      expect(other_pages_from_section).to eql([other])
    end
  end

  describe '#pages_for_application' do
    it "returns the pages that are relevant to an application" do
      sitemap = double(resources: [
        double(path: "foo.html", data: double(title: "Won't be included", important: true, review_by: Date.today, section: "Foo")),
        double(path: "manual/foo.html", data: double(title: "Foo", related_applications: %w[publisher], section: "Foo")),
        double(path: "manual/bar.html", data: double(title: "Bar", related_applications: %w[collections], section: "Bar")),
      ])

      pages_for_application = Manual.new(sitemap).pages_for_application("publisher")

      expect(pages_for_application.map(&:path)).to eql(["manual/foo.html"])
    end
  end
end
