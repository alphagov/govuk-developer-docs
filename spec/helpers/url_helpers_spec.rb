require "spec_helper"
require_relative "../../helpers/url_helpers"

RSpec.describe UrlHelpers do
  let(:helper) { Class.new { extend UrlHelpers } }

  describe "#document_type_url" do
    it "returns the path to a document type page" do
      document_type = "html_publication"
      expect(helper.document_type_url(document_type)).to eq("/document-types/html_publication.html")
    end
  end

  describe "#slack_url" do
    it "returns the URL to open a channel in GDS Slack" do
      channel_name = "#general"
      expect(helper.slack_url(channel_name)).to eq("https://gds.slack.com/channels/general")
    end
  end
end
