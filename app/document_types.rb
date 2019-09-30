class DocumentTypes
  FACET_QUERY = "https://www.gov.uk/api/search.json?facet_content_store_document_type=500,examples:10,example_scope:global&count=0".freeze
  DOCUMENT_TYPES_URL = "https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/lib/govuk_content_schemas/allowed_document_types.yml".freeze

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

  def self.to_csv
    DocumentTypesCsv.new(pages).to_csv
  end

  def self.facet_query
    @@facet_query ||= HTTP.get(FACET_QUERY)
  end

  def self.all_document_types
    @@all_document_types ||= HTTP.get_yaml(DOCUMENT_TYPES_URL).sort
  end

  def self.rendering_apps_from_content_store
    YAML.load_file("data/rendering-apps.yml")
  end

  class Page
    attr_reader :name, :total_count, :examples

    def initialize(name:, total_count:, examples:)
      @name = name
      @total_count = total_count
      @examples = examples
    end

    def url
      "https://docs.publishing.service.gov.uk/document-types/#{name}.html"
    end

    def rendering_apps
      entry = DocumentTypes.rendering_apps_from_content_store.find { |el| el[:name] == name }
      entry.to_h[:apps].to_a.compact
    end

    def search_url
      "https://www.gov.uk/api/search.json?filter_content_store_document_type=#{name}&count=10"
    end
  end
end
