RSpec.describe Repos do
  before :each do
    allow(Repos).to receive(:all) do
      applications.map(&:stringify_keys).map { |repo_data| Repo.new(repo_data) }
    end
  end

  describe "public" do
    let(:applications) do
      [
        { repo_name: "whitehall", private_repo: true },
        { repo_name: "asset-manager", private_repo: false },
      ]
    end

    it "should return only apps with public repos" do
      expect(Repos.public.map(&:repo_name)).to eq(%w[asset-manager])
    end
  end

  describe "active" do
    let(:applications) do
      [
        { repo_name: "whitehall", retired: true },
        { repo_name: "asset-manager", retired: false },
      ]
    end

    it "should return only repos that are not retired" do
      expect(Repos.active.map(&:repo_name)).to eq(%w[asset-manager])
    end
  end

  describe "active_apps" do
    let(:applications) do
      [
        { repo_name: "whitehall", retired: true },
        { repo_name: "asset-manager", retired: false, production_hosted_on: "aws" },
        { repo_name: "some-non-hosted-thing", retired: false },
      ]
    end

    it "should return only apps that are not retired and are hosted" do
      expect(Repos.active_apps.map(&:repo_name)).to eq(%w[asset-manager])
    end
  end
end
