RSpec.describe ManualIndexPage do
  describe '#columns' do
    it "returns the correct groups" do
      sitemap = double(resources: [
        double(path: "foo.html", data: double(title: "Won't be included", important: true, review_by: Date.today, section: "Foo")),
        double(path: "manual/foo.html", data: double(title: "Foo", important: true, review_by: Date.today, section: "Foo")),
        double(path: "manual/bar.html", data: double(title: "Bar", important: true, review_by: Date.today, section: "Bar")),
      ])

      columns = ManualIndexPage.new(sitemap).columns

      expect(columns[0].keys).to eql(["Top tasks", "Manual", "Expired pages", "Pages due for review this week", "Icinga alerts"])
      expect(columns[1].map(&:first)).to eql(["Bar"])
      expect(columns[2].map(&:first)).to eql(["Foo"])
    end
  end
end
