require "govuk_schemas"

class ContentSchema
  attr_reader :schema_name

  def initialize(schema_name)
    @schema_name = schema_name
  end

  def frontend_schema
    FrontendSchema.new(schema_name)
  rescue Errno::ENOENT
    nil
  end

  def publisher_content_schema
    PublisherContentSchema.new(schema_name)
  rescue Errno::ENOENT
    nil
  end

  def publisher_links_schema
    PublisherLinksSchema.new(schema_name)
  rescue Errno::ENOENT
    nil
  end

  class FrontendSchema
    attr_reader :schema_name

    def initialize(schema_name)
      @schema_name = schema_name
      raw_schema
    end

    def link_to_github
      "https://github.com/alphagov/govuk-content-schemas/blob/master/dist/formats/#{schema_name}/frontend/schema.json"
    end

    def random_example
      GovukSchemas::RandomExample.new(schema: raw_schema).payload
    end

    def properties
      Utils.inline_definitions(raw_schema["properties"], raw_schema["definitions"])
    end

  private

    def raw_schema
      @raw_schema ||= GovukSchemas::Schema.find(frontend_schema: schema_name)
    end
  end

  class PublisherContentSchema
    attr_reader :schema_name

    def initialize(schema_name)
      @schema_name = schema_name
      raw_schema
    end

    def link_to_github
      "https://github.com/alphagov/govuk-content-schemas/blob/master/dist/formats/#{schema_name}/publisher/schema.json"
    end

    def random_example
      GovukSchemas::RandomExample.new(schema: raw_schema).payload
    end

    def properties
      Utils.inline_definitions(raw_schema["properties"], raw_schema["definitions"])
    end

  private

    def raw_schema
      @raw_schema ||= GovukSchemas::Schema.find(publisher_schema: schema_name)
    end
  end

  class PublisherLinksSchema
    attr_reader :schema_name

    def initialize(schema_name)
      @schema_name = schema_name
      raw_schema
    end

    def link_to_github
      "https://github.com/alphagov/govuk-content-schemas/blob/master/dist/formats/#{schema_name}/publisher/links.json"
    end

    def random_example
      GovukSchemas::RandomExample.new(schema: raw_schema).payload
    end

    def properties
      Utils.inline_definitions(raw_schema["properties"], raw_schema["definitions"])
    end

  private

    def raw_schema
      @raw_schema ||= GovukSchemas::Schema.find(links_schema: schema_name)
    end
  end

  module Utils
    # Inline any keys that use definitions
    def self.inline_definitions(original_properties, definitions)
      original_properties.to_h.each do |k, v|
        next unless v["$ref"]

        original_properties[k] = definitions[v["$ref"].gsub("#/definitions/", "")]
      end

      # Inline any keys that use definitions
      if original_properties.to_h.dig("details", "properties")
        original_properties["details"]["properties"].each do |k, v|
          next unless v["$ref"]

          definition_name = v["$ref"].gsub("#/definitions/", "")
          original_properties["details"]["properties"][k] = definitions.fetch(definition_name)
        end
      end

      # Sort by keyname
      Hash[original_properties.to_h.sort_by(&:first)]
    end
  end
end
