RSpec.describe Applications do
  before :each do
    allow(Applications).to receive(:all) do
      applications.map(&:stringify_keys).map { |app_data| App.new(app_data) }
    end
  end

  describe "public" do
    let(:applications) do
      [
        { github_repo_name: "whitehall", private_repo: true },
        { github_repo_name: "asset-manager", private_repo: false },
      ]
    end

    it "should return only apps with public repos" do
      expect(Applications.public.map(&:github_repo_name)).to eq(%w[asset-manager])
    end
  end

  describe "active" do
    let(:applications) do
      [
        { github_repo_name: "whitehall", retired: true },
        { github_repo_name: "asset-manager", retired: false },
      ]
    end

    it "should return only apps that are not retired" do
      expect(Applications.active.map(&:github_repo_name)).to eq(%w[asset-manager])
    end
  end
end
