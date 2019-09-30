class AppData
  SEARCH_URL = "https://www.gov.uk/api/search.json?facet_publishing_app=100,examples:10,example_scope:global&facet_rendering_app=100,examples:10,example_scope:global&count=0".freeze

  def publishing_examples
    extract_examples_from_search_result("publishing_app")
  end

  def rendering_examples
    extract_examples_from_search_result("rendering_app")
  end

private

  def result
    @result ||= JSON.parse(Faraday.get(SEARCH_URL).body)
  end

  def extract_examples_from_search_result(facet_name)
    result.dig("facets", facet_name, "options").reduce({}) do |hash, option|
      hash[option.dig("value", "slug")] = option.dig("value", "example_info", "examples")
      hash
    end
  end
end
