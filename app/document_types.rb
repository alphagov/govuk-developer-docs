class DocumentTypes
  FACET_DOCUMENT_TYPES_QUERY = "https://www.gov.uk/api/search.json?facet_content_store_document_type=500,examples:10,example_scope:global&count=0".freeze
  FACET_FORMATS_QUERY = "https://www.gov.uk/api/search.json?facet_format=500,examples:10,example_scope:global&count=0".freeze
  DOCUMENT_TYPES_URL = "https://raw.githubusercontent.com/alphagov/publishing-api/main/content_schemas/allowed_document_types.yml".freeze

  def self.pages
    all_document_types.map do |document_type|
      pages_with_content_type(document_type) ||
        pages_with_format(document_type) ||
        Page.new(name: document_type, total_count: 0, examples: [])
    end
  end

  def self.to_csv
    DocumentTypesCsv.new(pages).to_csv
  end

  def self.facet_document_types_query
    @facet_document_types_query ||= HTTP.get(FACET_DOCUMENT_TYPES_QUERY)
  end

  def self.facet_formats_query
    @facet_formats_query ||= HTTP.get(FACET_FORMATS_QUERY)
  end

  def self.all_document_types
    @all_document_types ||= HTTP.get_yaml(DOCUMENT_TYPES_URL).sort
  end

  def self.rendering_apps_from_content_store
    YAML.load_file("data/rendering-apps.yml", aliases: true)
  end

  def self.schema_names_by_document_type
    @schema_names_by_document_type ||= GovukSchemas::Schema.schema_names.each_with_object({}) do |schema_name, memo|
      # Notification schema is used as that is the only schema type that is currently generated for every type
      schema = GovukSchemas::Schema.find(notification_schema: schema_name)
      document_types = schema.dig("properties", "document_type", "enum")

      raise "Expected #{schema_name} to have a document_type property with an enum" unless document_types

      document_types.each do |document_type|
        memo[document_type] ||= []
        memo[document_type] << schema_name
      end
    end
  end

  def self.pages_with_content_type(content_type)
    all_pages_by_content_type.find { |p| p.name == content_type }
  end

  def self.all_pages_by_content_type
    @all_pages_by_content_type ||= facet_document_types_query.dig("facets", "content_store_document_type", "options").map do |o|
      Page.new(
        name: o.dig("value", "slug"),
        total_count: o["documents"],
        examples: o.dig("value", "example_info", "examples"),
      )
    end
  end

  def self.pages_with_format(format)
    all_pages_by_format.find { |p| p.name == format }
  end

  def self.all_pages_by_format
    @all_pages_by_format ||= facet_formats_query.dig("facets", "format", "options").map do |o|
      Page.new(
        name: o.dig("value", "slug"),
        total_count: o["documents"],
        examples: o.dig("value", "example_info", "examples"),
      )
    end
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

    def schemas
      shift_low_value_schemas(DocumentTypes.schema_names_by_document_type[name]) || []
    end

    def shift_low_value_schemas(schemas)
      %w[
        generic
        generic_with_external_links
        placeholder
      ].each do |low_value_schema|
        if schemas.include?(low_value_schema)
          schemas.delete(low_value_schema)
          schemas.append(low_value_schema)
        end
      end
      schemas
    end
  end
end
