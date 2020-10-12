require "spec_helper"
require_relative "../../helpers/commit_helpers.rb"

RSpec.describe CommitHelpers do
  let(:helper) { Class.new { extend CommitHelpers } }

  describe "#commit_url" do
    it "returns commit URL for the commit associated with the source file of current_page" do
      source_file = "foo/bar.md"
      commit_sha = SecureRandom.hex(40)
      current_page = OpenStruct.new(file_descriptor: OpenStruct.new(relative_path: source_file))
      allow(helper).to receive(:`).and_return(commit_sha)
      expect(helper.commit_url(current_page))
        .to eq("https://github.com/alphagov/govuk-developer-docs/commit/#{commit_sha}")
    end
  end

  describe "#last_updated" do
    it "returns a datetime string of the form 'YYYY-MM-DD HH:mm:ss UTC'" do
      source_file = "index.html.erb"
      current_page = OpenStruct.new(file_descriptor: OpenStruct.new(relative_path: source_file))
      expect(helper.last_updated(current_page)).to match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} UTC/)
    end
  end
end
