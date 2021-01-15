RSpec.describe ProxyPages do
  before do
    allow(Applications).to receive(:apps)
      .and_return([double("App", app_name: "", page_title: "", description: "", github_repo_name: "", private_repo?: false)])
    allow(DocumentTypes).to receive(:pages)
      .and_return([double("Page", name: "")])
    allow(Supertypes).to receive(:all)
      .and_return([double("Supertype", name: "", description: "", id: "")])
    allow(GitHubRepoFetcher.instance).to receive(:docs)
      .and_return([
        {
          title: "A doc page",
          markdown: "# A doc page\n Foo",
          latest_commit: {
            sha: SecureRandom.hex(40),
            timestamp: Time.now.utc,
          },
        },
      ])
  end

  describe ".app_docs" do
    it "is indexed in search by its default contents" do
      expect(described_class.app_docs).to all(
        include(frontmatter: hash_including(:title))
        .and(include(frontmatter: hash_excluding(:content))),
      )
    end

    it "sets the correct source_url for the doc" do
      expect(described_class.app_docs).to all(
        include(frontmatter: hash_including(data: hash_including(:source_url))),
      )
    end
  end

  describe ".app_overviews" do
    it "is indexed in search by its default contents" do
      expect(described_class.app_overviews).to all(
        include(frontmatter: hash_including(:title))
        .and(include(frontmatter: hash_excluding(:content))),
      )
    end
  end

  describe ".document_types" do
    it "is indexed in search by title only" do
      expect(described_class.document_types).to all(include(frontmatter: hash_including(:title, content: "")))
    end
  end

  describe ".supertypes" do
    it "is indexed in search by title only" do
      expect(described_class.supertypes).to all(include(frontmatter: hash_including(:title, content: "")))
    end
  end
end
