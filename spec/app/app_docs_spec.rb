RSpec.describe AppDocs::App do
  describe "production_url" do
    it "has a good default" do
      app = AppDocs::App.new("type" => "Publishing app", "github_repo_name" => "my-app")

      expect(app.production_url).to eql("https://my-app.publishing.service.gov.uk")
    end

    it "allows override" do
      app = AppDocs::App.new("type" => "Publishing app", "production_url" => "something else")

      expect(app.production_url).to eql("something else")
    end
  end
end
