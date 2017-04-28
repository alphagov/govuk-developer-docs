RSpec.describe PageFreshness do
  describe "#to_json" do
    it "returns JSON" do
      sitemap = double(resources: [
        double(url: "/a", data: double(title: "A thing", owner_slack: "#2ndline", last_reviewed_at: Date.yesterday, review_in: "0 days")),
        double(url: "/b", data: double(title: "B thing", owner_slack: "#2ndline", last_reviewed_at: Date.yesterday, review_in: "2 days")),
      ])

      json = PageFreshness.new(sitemap).to_json

      expect(JSON.parse(json)).to eql(
        "expired_pages" => [{ "title" => "A thing", "url" => "https://docs.publishing.service.gov.uk/a", "review_by" => Date.yesterday.to_s, "owner_slack" => "#2ndline" }],
        "expiring_soon" => [{ "title" => "B thing", "url" => "https://docs.publishing.service.gov.uk/b", "review_by" => Date.tomorrow.to_s, "owner_slack" => "#2ndline" }]
      )
    end
  end
end
