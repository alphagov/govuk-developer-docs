RSpec.describe Repos do
  before :each do
    allow(Repos).to receive(:all) do
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
      expect(Repos.public.map(&:github_repo_name)).to eq(%w[asset-manager])
    end
  end

  describe "active_apps" do
    let(:applications) do
      [
        { github_repo_name: "whitehall", retired: true },
        { github_repo_name: "asset-manager", retired: false, production_hosted_on: "aws" },
        { github_repo_name: "some-non-hosted-thing", retired: false },
      ]
    end

    it "should return only apps that are not retired and are hosted" do
      expect(Repos.active_apps.map(&:github_repo_name)).to eq(%w[asset-manager])
    end
  end

  describe "for_team" do
    let(:applications) do
      [
        { github_repo_name: "retired", team: "#foo", retired: true },
        { github_repo_name: "private", team: "#foo", private_repo: true },
        { github_repo_name: "hosted-app", team: "#foo", retired: false, production_hosted_on: "aws" },
        { github_repo_name: "unhosted-tool", team: "#foo", retired: false },
      ]
    end

    it "should return all public, non-retired repos owned by a particular team" do
      expect(Repos.for_team("#foo")).to eq(%w[hosted-app unhosted-tool])
    end
  end
end
