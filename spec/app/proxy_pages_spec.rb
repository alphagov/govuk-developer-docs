RSpec.describe ProxyPages do
  before :each do
    allow(AppDocs).to receive(:pages)
      .and_return([double("App", app_name: "", page_title: "", description: "")])
    allow(DocumentTypes).to receive(:pages)
      .and_return([double("Page", name: "")])
    allow(Supertypes).to receive(:all)
      .and_return([double("Supertype", name: "", description: "", id: "")])
  end

  describe ".publishing_api_docs" do
    it "is indexed in search by its default contents" do
      expect(described_class.publishing_api_docs).to all(
        include(frontmatter: hash_including(:title))
        .and(include(frontmatter: hash_excluding(:content))),
      )
    end
  end

  describe ".email_alert_api_docs" do
    it "is indexed in search by its default contents" do
      expect(described_class.email_alert_api_docs).to all(
        include(frontmatter: hash_including(:title))
        .and(include(frontmatter: hash_excluding(:content))),
      )
    end
  end

  describe ".app_docs" do
    it "is indexed in search by its default contents" do
      expect(described_class.app_docs).to all(
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
