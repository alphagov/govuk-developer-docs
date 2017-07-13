YAML.load_file("data/redirects.yml").each do |from, to|
  RSpec.describe "#{from} -> #{to}" do
    it "redirects to and from HTML pages" do
      expect(from).to end_with ".html"
      expect(to).to end_with ".html"
    end
  end
end
