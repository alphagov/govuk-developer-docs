RSpec.describe "repos.yml" do
  describe "repos.yml" do
    let!(:repos) { YAML.load_file("data/repos.yml", aliases: true) }

    it "lists each repository in alphabetical order" do
      expect(repos.pluck("repo_name")).to eq(repos.pluck("repo_name").sort)
    end
  end
end
