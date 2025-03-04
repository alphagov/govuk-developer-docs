RSpec.describe RepoSidebar do
  it "returns an ordered list of items" do
    docs_to_import = [
      {
        path: "/repos/repo_name/base.html",
        title: "Base",
      },
      {
        path: "/repos/repo_name/something/in_a_sub_dir.html",
        title: "Single level",
      },
      {
        path: "/repos/repo_name/something/deeper/in_a_sub_dir.html",
        title: "Double level",
      },
    ]

    allow(GitHubRepoFetcher.instance).to receive(:docs)
                                     .with("repo_name")
                                     .and_return(docs_to_import)

    result = RepoSidebar.new("repo_name").items

    expect(result.count).to eq(2)

    expect(result[0].title).to eq("Base")
    expect(result[0].path).to eq("/repos/repo_name/base.html")
    expect(result[0].children).to eq([])

    expect(result[1].title).to eq("something")
    expect(result[1].path).to eq("something")
    expect(result[1].children.count).to eq(2)

    expect(result[1].children[0].title).to eq("Single level")
    expect(result[1].children[0].path).to eq("/repos/repo_name/something/in_a_sub_dir.html")

    expect(result[1].children[1].title).to eq("deeper")
    expect(result[1].children[1].path).to eq("something/deeper")
    expect(result[1].children[1].children.count).to eq(1)

    expect(result[1].children[1].children[0].title).to eq("Double level")
    expect(result[1].children[1].children[0].path).to eq("/repos/repo_name/something/deeper/in_a_sub_dir.html")
    expect(result[1].children[1].children[0].children).to eq([])
  end
end
