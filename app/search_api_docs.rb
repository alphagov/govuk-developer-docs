class SearchApiReference
  def self.fetch_field_definitions
    contents = HTTP.get(
      field_definitions_url,
    )

    fields = JSON.parse(contents)
    fields.sort_by { |name, definition| [definition["type"], name] }
  end

  def self.field_definitions_url
    "https://raw.githubusercontent.com/alphagov/search-api/main/config/schema/field_definitions.json"
  end
end
