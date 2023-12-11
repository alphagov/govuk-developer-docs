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

    context "repo contains multiple apps" do
      let(:repos) do
        [
          { repo_name: "licensify", app_name: "licensify" },
          { repo_name: "licensify", app_name: "licensify-feed" },
          { repo_name: "licensify", app_name: "licensify-admin" },
        ]
      end

      it "should return one repo name" do
        expect(Repos.active.map(&:repo_name)).to eq(%w[licensify])
      end
    end
  end

  describe "active_public" do
    let(:repos) do
      [
        { repo_name: "secret-squirrel", private_repo: true },
        { repo_name: "olde-time-public-repo", retired: true },
        { repo_name: "active-public-repo", retired: false },
        { repo_name: "retired-secret-squirrel", private_repo: true, retired: true },
      ]
    end

    it "should return only repos that are both public and not retired" do
      expect(Repos.active_public.map(&:repo_name)).to eq(%w[active-public-repo])
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

  describe "active_gems" do
    let(:repos) do
      [
        { repo_name: "cache-clearing-service", type: "Services" },
        { repo_name: "gds-api-adapters", type: "Gems" },
      ]
    end

    it "should return only apps that are classified as gems" do
      expect(Repos.active_gems.map(&:repo_name)).to eq(%w[gds-api-adapters])
    end
  end
end
