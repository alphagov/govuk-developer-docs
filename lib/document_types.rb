class DocumentTypes
  def self.pages
    @@pages ||= begin
      facet_query.dig("facets", "content_store_document_type", "options").map { |o|
        Page.new(
          name: o.dig("value", "slug"),
          total_count: o.dig("documents"),
          examples: o.dig("value", "example_info", "examples"),
        )
      }.sort_by(&:name)
    end
  end

  def self.coverage_percentage
    ((pages.sum(&:total_count) / facet_query.fetch("total").to_f) * 100).round(1)
  end

  def self.facet_query
    @@facet_query ||= begin
      json = Faraday.get('https://www.gov.uk/api/search.json?facet_content_store_document_type=100,examples:10,example_scope:global&count=0').body
      JSON.parse(json)
    end
  end

  class Page
    attr_reader :name, :total_count, :examples

    def initialize(name:, total_count:, examples:)
      @name = name
      @total_count = total_count
      @examples = examples
    end

    def search_url
      "https://www.gov.uk/api/search.json?filter_content_store_document_type=#{name}&count=10"
    end
  end
end
