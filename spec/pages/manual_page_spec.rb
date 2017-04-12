Dir.glob("source/manual/**/*.md").each do |filename|
  RSpec.describe filename do
    raw = File.read(filename)
    frontmatter = YAML.load(raw.split('---')[1])

    it "has an owner" do
      expect(frontmatter['owner_slack']).to be_present, "Page doesn't have `owner_slack` set"
      expect(frontmatter['owner_slack'][0]).to be_in(%[# @]), "`owner_slack` should be a @username or #channel"
    end

    it "has a review_by date" do
      expect(frontmatter['review_by']).to be_a(Date)
    end
  end
end
