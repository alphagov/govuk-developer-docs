class RepoData
  SEARCH_URL = "https://www.gov.uk/api/search.json?facet_publishing_app=100,examples:10,example_scope:global&facet_rendering_app=100,examples:10,example_scope:global&count=0".freeze

  def self.publishing_examples
    @publishing_examples ||= extract_examples_from_search_result("publishing_app")
  end

  def self.rendering_examples
    @rendering_examples ||= extract_examples_from_search_result("rendering_app")
  end

  def self.result
    @result ||= JSON.parse(Faraday.get(SEARCH_URL).body)
  end

  def self.extract_examples_from_search_result(facet_name)
    result.dig("facets", facet_name, "options").each_with_object({}) do |option, hash|
      hash[option.dig("value", "slug")] = option.dig("value", "example_info", "examples")
    end
  end

  private_class_method :result, :extract_examples_from_search_result
end
