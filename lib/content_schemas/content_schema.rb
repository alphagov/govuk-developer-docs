require 'json'
require 'active_support/core_ext/string'

class ContentSchema
  CONTENT_SCHEMA_DIR = '../govuk-content-schemas'

  attr_reader :schema_name

  def initialize(schema_name)
    @schema_name = schema_name
  end

  def renderable?
    File.exists?("#{CONTENT_SCHEMA_DIR}/dist/formats/#{schema_name}/frontend/schema.json")
  end

  def table_of_properties(properties)
    return unless properties

    rows = properties.map do |name, attrs|
      "<tr><td><strong>#{name}</strong> #{possible_types(attrs)}</td> <td>#{display_attribute_value(attrs)}</td></tr>"
    end

    "<table class='schema-table'>#{rows.join("\n")}</table>"
  end

  def display_attribute_value(attrs)
    return unless attrs
    if attrs['properties']
      table_of_properties(attrs['properties'])
    else
      [enums(attrs), attrs['description']].join
    end
  end

  def enums(attrs)
    return unless attrs['enum']
    "Allowed values: " + attrs['enum'].map { |value| "<code>#{value}</code>" }.join(" or ")
  end

  def publisher_properties
    schema = JSON.parse(File.read("#{CONTENT_SCHEMA_DIR}/dist/formats/#{schema_name}/publisher_v2/schema.json"))
    collapso(schema.dig('oneOf', 1, 'properties') || schema['properties'], schema)
  end

  def links_properties
    return unless File.exists?("#{CONTENT_SCHEMA_DIR}/dist/formats/#{schema_name}/publisher_v2/links.json")

    schema = JSON.parse(File.read("#{CONTENT_SCHEMA_DIR}/dist/formats/#{schema_name}/publisher_v2/links.json"))
    collapso(schema.dig('oneOf', 1, 'properties') || schema['properties'], schema)
  end

  def frontend_properties
    return unless File.exists?("#{CONTENT_SCHEMA_DIR}/dist/formats/#{schema_name}/frontend/schema.json")

    schema = JSON.parse(File.read("#{CONTENT_SCHEMA_DIR}/dist/formats/#{schema_name}/frontend/schema.json"))
    collapso(schema.dig('oneOf', 1, 'properties') || schema['properties'], schema)
  end

  def possible_types(attrs)
    return unless attrs
    possible_types = attrs['type'] ? [attrs] : attrs['anyOf']
    return unless possible_types
    possible_types.map { |a| "<code>#{a['type']}</code>" }.join(" or ")
  end

  def frontend_examples
    Dir.glob("#{CONTENT_SCHEMA_DIR}/formats/#{schema_name}/frontend/examples/*.json").map do |filename|
      { 'filename' => File.basename(filename), 'json' => File.read(filename) }
    end
  end

  def get_binding
    binding
  end

private

  # Inline any keys that use definitions
  def collapso(original_properties, schema)
    original_properties.each do |k, v|
      next unless v['$ref']
      original_properties[k] = schema['definitions'][v['$ref'].gsub('#/definitions/', '')]
    end

    # Inline any keys that use definitions
    if original_properties['details']
      original_properties['details']['properties'].each do |k, v|
        next unless v['$ref']
        definition_name = v['$ref'].gsub('#/definitions/', '')
        original_properties['details']['properties'][k] = schema['definitions'].fetch(definition_name)
      end
    end

    # Sort by keyname
    Hash[original_properties.sort_by(&:first)]
  end
end
