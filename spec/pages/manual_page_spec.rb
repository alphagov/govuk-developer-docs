Dir.glob("source/manual/**/*.md").each do |filename|
  RSpec.describe filename do
    raw = File.read(filename)
    frontmatter = YAML.load(raw.split('---')[1])

    it "uses the correct spelling of GOV.UK" do
      expect(raw).not_to match "Gov.uk"
    end

    it "has an owner" do
      expect(frontmatter['owner_slack']).to be_present, "Page doesn't have `owner_slack` set"
      expect(frontmatter['owner_slack'][0]).to be_in(%[# @]), "`owner_slack` should be a @username or #channel"
    end

    it "has a valid review date" do
      review_by = PageReview.new(double(data: double(frontmatter)))

      expect(review_by.review_by).to be_a(Date)
    end

    it "has a title" do
      expect(frontmatter['title']).to be_present, "Page doesn't have `title` set"
    end

    it "has the correct suffix" do
      expect(filename).to match(/\.html\.md$/)
    end
  end
end
