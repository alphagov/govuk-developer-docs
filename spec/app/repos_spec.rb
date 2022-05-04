RSpec.describe Repos do
  before :each do
    allow(Repos).to receive(:all) do
      repos.map(&:stringify_keys).map { |repo_data| Repo.new(repo_data) }
    end
  end

  describe "public" do
    let(:repos) do
      [
        { repo_name: "whitehall", private_repo: true },
        { repo_name: "asset-manager", private_repo: false },
      ]
    end

    it "should return only repos that are public" do
      expect(Repos.public.map(&:repo_name)).to eq(%w[asset-manager])
    end
  end

  describe "active" do
    let(:repos) do
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
    let(:repos) do
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

  describe "for_team" do
    let(:repos) do
      [
        { repo_name: "retired", team: "#foo", retired: true },
        { repo_name: "private", team: "#foo", private_repo: true },
        { repo_name: "hosted-app", team: "#foo", retired: false, production_hosted_on: "aws" },
        { repo_name: "unhosted-tool", team: "#foo", retired: false },
      ]
    end

    it "should return all public, non-retired repos owned by a particular team" do
      expect(Repos.for_team("#foo")).to eq(%w[hosted-app unhosted-tool])
    end
  end
end
