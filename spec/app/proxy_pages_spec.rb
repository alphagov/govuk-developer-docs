RSpec.describe ProxyPages do
  let(:rake_tasks) { [{ name: "reslug:person" }] }

  before do
    allow(Repos).to receive(:all)
      .and_return([double("Repo", app_name: "", repo_name: "", page_title: "", description: "", skip_docs?: false, private_repo?: false, retired?: false, repo_url: "", rake_tasks:, rake_tasks_path: "/repos/some-app/rake-tasks.html")])
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

  describe ".repo_docs" do
    it "is indexed in search by its default contents" do
      expect(described_class.repo_docs).to all(
        include(frontmatter: hash_including(:title))
        .and(include(frontmatter: hash_excluding(:content))),
      )
    end

    it "sets the correct source_url for the doc" do
      expect(described_class.repo_docs).to all(
        include(frontmatter: hash_including(data: hash_including(:source_url))),
      )
    end
  end

  describe ".repo_rake_tasks" do
    it "creates a rake tasks page for each repo with rake tasks" do
      expect(described_class.repo_rake_tasks).to match([
        include(path: "/repos/some-app/rake-tasks.html", template: "templates/rake_tasks_template.html"),
      ])
    end

    it "is indexed in search by its default contents" do
      expect(described_class.repo_rake_tasks).to all(
        include(frontmatter: hash_including(:title))
          .and(include(frontmatter: hash_excluding(:content))),
      )
    end

    context "when the repo has no rake tasks" do
      let(:rake_tasks) { [] }

      it "doesn't create a page" do
        expect(described_class.repo_rake_tasks).to eq([])
      end
    end
  end

  describe ".repo_overviews" do
    it "is indexed in search by its default contents" do
      expect(described_class.repo_overviews).to all(
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
