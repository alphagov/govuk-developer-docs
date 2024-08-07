require "spec_helper"
require_relative "../../helpers/analytics_helpers"

RSpec.describe AnalyticsHelpers do
  let(:helper) { Class.new { extend AnalyticsHelpers } }

  describe "#urlize" do
    it "returns a url safe version of the given string" do
      expect(helper.urlize("An event-name")).to eq("an_event_name")
    end
  end

  describe "#build_event" do
    it "returns an ordered hash given an array of un-ordered hashes" do
      input = [
        { "name" => "type", "value" => "accordion" },
        { "name" => "event_name", "value" => "select_content" },
      ]

      expected = {
        "event_name" => {
          "value" => "select_content",
          "variant" => nil,
        },
        "type" => {
          "value" => "accordion",
          "variant" => nil,
        },
      }

      expect(helper.build_event(input)).to eq(expected)
    end

    it "returns a nested ordered hash given an array of hashes with one having
      a value that is an array" do
      input = [
        {
          "name" => "event_data",
          "value" => [
            { "name" => "event_name", "value" => "select_content" },
          ],
        },
      ]

      expected = {
        "event_data" => { "event_name" => { "value" => "select_content", "variant" => nil } },
      }

      expect(helper.build_event(input)).to eq(expected)
    end

    it "returns a deeply nested ordered hash given an array of hashes with one
      having a value that is an array and another where the value is also an array and requires attribute lookup" do
      input = [
        {
          "name" => "event_data",
          "value" => [
            { "name" => "event_name", "value" => "select_content" },
            {
              "name" => "index",
              "value" => [
                { "name" => "index_section" },
              ],
            },
          ],
        },
      ]

      attributes = [
        { "name" => "index_section", "type" => "integer" },
      ]

      expected = {
        "event_data" => {
          "event_name" => {
            "value" => "select_content",
            "variant" => nil,
          },
          "index" => {
            "index_section" => {
              "value" => "integer",
              "variant" => nil,
            },
          },
        },
      }

      expect(helper.build_event(input, attributes)).to eq(expected)
    end

    it "returns a deeply nested ordered hash given an array of hashes with one
      having a value that is an array and another where the value is also an array and requires attribute lookup and one with a matching variant" do
      input = [
        {
          "name" => "event_data",
          "value" => [
            { "name" => "event_name", "value" => "select_content" },
            {
              "name" => "index",
              "value" => [
                { "name" => "index_section" },
                { "name" => "index_link" },
              ],
            },
          ],
        },
      ]

      attributes = [
        {
          "name" => "index_section",
          "type" => "integer",
          "variants" => [
            {
              "event_name" => "select_content",
            },
          ],
        },
        {
          "name" => "index_link",
          "type" => "noun",
        },
      ]

      expected = {
        "event_data" => {
          "event_name" => {
            "value" => "select_content",
            "variant" => nil,
          },
          "index" => {
            "index_section" => {
              "value" => "integer",
              "variant" => "select_content",
            },
            "index_link" => {
              "value" => "noun",
              "variant" => nil,
            },
          },
        },
      }

      expect(helper.build_event(input, attributes)).to eq(expected)
    end

    it "returns a deeply nested ordered hash given an array of hashes with one
      having a value that is an array and another where the value is also an array and requires attribute lookup but without a matching value" do
      input = [
        {
          "name" => "event_data",
          "value" => [
            { "name" => "event_name", "value" => "select_content" },
            {
              "name" => "index",
              "value" => [
                { "name" => "index_section" },
              ],
            },
          ],
        },
      ]

      expected = {
        "event_data" => {
          "event_name" => {
            "value" => "select_content",
            "variant" => nil,
          },
          "index" => {
            "index_section" => {
              "value" => nil,
              "variant" => nil,
            },
          },
        },
      }

      expect(helper.build_event(input)).to eq(expected)
    end
  end

  describe "#find_variant" do
    it "returns nothing if nothing is passed" do
      expect(helper.find_variant(nil, {})).to eq(nil)
    end

    it "does not error if the passed data is incomplete" do
      input = {
        "name" => "text",
      }

      expect(helper.find_variant("not_in_the_data", input)).to eq(nil)
    end

    it "finds a variant in passed data" do
      input = {
        "name" => "text",
        "variants" => [
          {
            "event_name" => "search",
          },
          {
            "event_name" => "navigation",
          },
          {
            "event_name" => "file_download",
          },
        ],
      }

      expect(helper.find_variant("search", input)).to eq("search")
    end

    it "returns nil if it cannot find a variant in passed data" do
      input = {
        "name" => "text",
        "variants" => [
          {
            "event_name" => "search",
          },
          {
            "event_name" => "navigation",
          },
          {
            "event_name" => "file_download",
          },
        ],
      }

      expect(helper.find_variant("not_in_the_data", input)).to eq(nil)
    end
  end

  describe "#to_html" do
    it "returns an HTML list item set given a hash" do
      input = {
        "event_name" => {
          "value" => "select_content",
          "variant" => nil,
        },
        "type" => {
          "value" => "accordion",
          "variant" => nil,
        },
      }

      expected = <<~HTML.gsub(/^\s+/, "").gsub("\n", "")
        <ul class='govuk-list indented-list'>
          <li>
            <a href='/analytics/attribute_event_name.html' class='govuk-link'>event_name</a>: select_content
          </li>
          <li>
            <a href='/analytics/attribute_type.html' class='govuk-link'>type</a>: accordion
          </li>
        </ul>
      HTML

      expect(helper.to_html(input)).to eq(expected)
    end

    it "returns an HTML list item set given a hash with variants" do
      input = {
        "event_name" => {
          "value" => "select_content",
          "variant" => "select_content",
        },
        "type" => {
          "value" => "accordion",
          "variant" => nil,
        },
      }

      expected = <<~HTML.gsub(/^\s+/, "").gsub("\n", "")
        <ul class='govuk-list indented-list'>
          <li>
            <a href='/analytics/attribute_event_name/variant_select_content.html' class='govuk-link'>event_name</a>: select_content
          </li>
          <li>
            <a href='/analytics/attribute_type.html' class='govuk-link'>type</a>: accordion
          </li>
        </ul>
      HTML

      expect(helper.to_html(input)).to eq(expected)
    end

    it "returns a nested HTML list item set given a nested hash" do
      input = {
        "event_data" => {
          "event_name" => {
            "value" => "select_content",
            "variant" => nil,
          },
        },
      }

      expected = <<~HTML.gsub(/^\s+/, "").gsub("\n", "")
        <ul class='govuk-list indented-list'>
          <li>event_data: <ul class='govuk-list indented-list'>
              <li>
                <a href='/analytics/attribute_event_name.html' class='govuk-link'>event_name</a>: select_content
              </li>
            </ul>
          </li>
        </ul>
      HTML

      expect(helper.to_html(input)).to eq(expected)
    end

    it "returns a deeply nested HTML list item set given a deeply nested hash" do
      input = {
        "event_data" => {
          "event_name" => {
            "value" => "select_content",
            "variant" => nil,
          },
          "index" => {
            "index_section" => {
              "value" => "integer",
              "variant" => nil,
            },
          },
        },
      }

      expected = <<~HTML.gsub(/^\s+/, "").gsub("\n", "")
        <ul class='govuk-list indented-list'>
          <li>event_data: <ul class='govuk-list indented-list'>
              <li>
                <a href='/analytics/attribute_event_name.html' class='govuk-link'>event_name</a>: select_content
              </li>
              <li>index: <ul class='govuk-list indented-list'>
                  <li>
                    <a href='/analytics/attribute_index_section.html' class='govuk-link'>index_section</a>: integer
                  </li>
                </ul>
              </li>
            </ul>
          </li>
        </ul>
      HTML

      expect(helper.to_html(input)).to eq(expected)
    end
  end

  describe "#implementation_percentage" do
    it "should be 0% when there are no events" do
      expect(helper.implementation_percentage([])).to eq("0 of 0 (0%)")
    end

    it "should be 0% when none of the events are implemented" do
      events = [
        { "implemented" => false },
      ]

      expect(helper.implementation_percentage(events)).to eq("0 of 1 (0%)")
    end

    it "should be 100% when all the events are implemented" do
      events = [
        { "implemented" => true },
      ]

      expect(helper.implementation_percentage(events)).to eq("1 of 1 (100.0%)")
    end

    it "should be 50% when half of the events are implemented" do
      events = [
        { "implemented" => true },
        { "implemented" => false },
      ]

      expect(helper.implementation_percentage(events)).to eq("1 of 2 (50.0%)")
    end
  end

  describe "#events_by_type" do
    it "converts YML into a usable object" do
      input = YAML.load_file("spec/fixtures/events-fixture.yml", aliases: true)
      expected = {
        navigation: {
          name: "navigation",
          events: [
            {
              event_name: "Accordion links",
              index: 2,
              name: "accordion",
            },
            {
              event_name: "link click",
              index: 0,
              name: "back link",
            },
          ],
        },
        select_content: {
          name: "select_content",
          events: [
            {
              event_name: "Accordion section",
              index: 0,
              name: "accordion",
            },
            {
              event_name: "Show all sections",
              index: 1,
              name: "accordion",
            },
          ],
        },
      }
      expect(helper.events_by_type(input)).to eq(expected)
    end
  end
end
