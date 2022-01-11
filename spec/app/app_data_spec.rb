RSpec.describe AppData do
  before do
    stub_request(:get, AppData::SEARCH_URL)
      .to_return(body: "{}")
  end

  describe "result" do
    it "cannot be queried from outside the class" do
      expect { AppData.result }.to raise_error(NoMethodError)
    end
  end

  describe "extract_examples_from_search_result" do
    it "cannot be queried from outside the class" do
      expect { AppData.extract_examples_from_search_result }.to raise_error(NoMethodError)
    end
  end
end
