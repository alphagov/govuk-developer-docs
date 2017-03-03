class DocumentTypes
  FACET_QUERY = 'https://www.gov.uk/api/search.json?facet_content_store_document_type=500,examples:10,example_scope:global&count=0'.freeze

  def self.pages
    @@pages ||= begin
      known_from_search = facet_query.dig("facets", "content_store_document_type", "options").map { |o|
        Page.new(
          name: o.dig("value", "slug"),
          total_count: o.dig("documents"),
          examples: o.dig("value", "example_info", "examples"),
        )
      }

      all_document_types.map do |document_type|
        from_search = known_from_search.find { |p| p.name == document_type }
        from_search || Page.new(name: document_type, total_count: 0, examples: [])
      end
    end
  end

  def self.coverage_percentage
    ((pages.sum(&:total_count) / facet_query.fetch("total").to_f) * 100).round(1)
  end

  def self.facet_query
    @@facet_query ||= begin
      json = Faraday.get(FACET_QUERY).body
      JSON.parse(json)
    end
  end

  def self.all_document_types
    yaml = Faraday.get("https://raw.githubusercontent.com/alphagov/govuk-content-schemas/lock-down-document-type/lib/govuk_content_schemas/allowed_document_types.yml").body
    YAML.load(yaml).sort
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
