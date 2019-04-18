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

    it "has a title" do
      expect(frontmatter['title']).to be_present, "Page doesn't have `title` set"
    end

    unless frontmatter["section"] == "Icinga alerts"
      it "follows the styleguide" do
        expect(frontmatter['title'].split(" ").first).not_to end_with("ing"),
          "Page title `#{frontmatter['title']}`: don't use 'ing' at the end of verbs - https://docs.publishing.service.gov.uk/manual/docs-style-guide.html#title"
      end
    end

    it "has the correct suffix" do
      expect(filename).to match(/\.html\.md$/)
    end

    unless filename.in?(%w[
      source/manual/readmes.html.md
      source/manual/kibana.html.md
      source/manual/howto-merge-a-pull-request-from-an-external-contributor.html.md
    ])
      it "doesn't use H1 tags (the page title is already an H1)" do
        raw_without_code_blocks = raw.remove(/```[a-z]*\n[\s\S]*?\n```/) # want to allow `#` (comments) in code blocks
        expect(raw_without_code_blocks).not_to match(/\n#\s/), "This page contains an unnecessary H1."
      end
    end
  end
end
