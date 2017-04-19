class SearchApiReference
  def self.fetch_field_definitions
    contents = HTTP.get(
      field_definitions_url,
    )

    JSON.parse(contents)
  end

  def self.field_definitions_url
    "https://raw.githubusercontent.com/alphagov/rummager/master/config/schema/field_definitions.json"
  end
end
