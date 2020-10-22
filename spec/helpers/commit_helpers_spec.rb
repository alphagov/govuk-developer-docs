require "spec_helper"
require_relative "../../helpers/commit_helpers.rb"

RSpec.describe CommitHelpers do
  let(:helper) { Class.new { extend CommitHelpers } }

  describe "#commit_url" do
    it "returns the commit_url associated with the page data, if that exists" do
      app_name = "some-repo"
      commit_sha = SecureRandom.hex(40)
      current_page = OpenStruct.new(data: OpenStruct.new(
        app_name: app_name,
        latest_commit: {
          sha: commit_sha,
        },
      ))
      expect(helper.commit_url(current_page)).to eq("https://github.com/alphagov/#{app_name}/commit/#{commit_sha}")
    end

    it "returns commit URL for the commit associated with the source file of current_page" do
      source_file = "index.html.erb"
      current_page = OpenStruct.new(
        data: OpenStruct.new,
        file_descriptor: OpenStruct.new(relative_path: source_file),
      )
      expect(helper.commit_url(current_page)).to match(
        /https:\/\/github.com\/alphagov\/govuk-developer-docs\/commit\/[0-9a-f]{40}$/,
      )
    end
  end

  describe "#last_updated" do
    it "formats the commit timestamp associated with the (remote) page data, if that exists" do
      last_committed = "2020-09-03 09:53:56 UTC"
      current_page = OpenStruct.new(data: OpenStruct.new(
        latest_commit: { timestamp: last_committed },
      ))
      expect(helper.last_updated(current_page)).to eq("3 Sep 2020")
    end

    it "formats the commit date of the local file if no page data exists" do
      source_file = "index.html.erb"
      current_page = OpenStruct.new(
        data: OpenStruct.new,
        file_descriptor: OpenStruct.new(relative_path: source_file),
      )
      expect(helper.last_updated(current_page)).to match(/\d{1,2} \w+ \d{4}/)
    end
  end
end
