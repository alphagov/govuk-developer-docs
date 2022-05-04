RSpec.describe RepoData do
  before do
    stub_request(:get, RepoData::SEARCH_URL)
      .to_return(body: "{}")
  end

  describe "result" do
    it "cannot be queried from outside the class" do
      expect { RepoData.result }.to raise_error(NoMethodError)
    end
  end

  describe "extract_examples_from_search_result" do
    it "cannot be queried from outside the class" do
      expect { RepoData.extract_examples_from_search_result }.to raise_error(NoMethodError)
    end
  end
end
