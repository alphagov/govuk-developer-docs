module PropertiesTableHelpers
  def table_of_properties(properties)
    return unless properties

    rows = properties.map do |name, attrs|
      "<tr><td><strong>#{name}</strong><br/>#{possible_types(attrs)}</td> <td>#{display_attribute_value(attrs)}</td></tr>"
    end

    "<table class='schema-table'>#{rows.join("\n")}</table>"
  end

private

  def display_attribute_value(attrs)
    return unless attrs

    if attrs["properties"]
      table_of_properties(attrs["properties"])
    else
      [attrs["description"], enums(attrs)].join("<br/>")
    end
  end

  def enums(attrs)
    return unless attrs["enum"]

    values = attrs["enum"].map { |value| "<code>#{value}</code>" }
    "Allowed values: #{values.join(', ')}"
  end

  def possible_types(attrs)
    return unless attrs

    possible_types = attrs["type"] ? [attrs] : attrs["anyOf"]
    return unless possible_types

    possible_types.map { |a| "<code>#{a['type']}</code>" }.join(" or ")
  end
end
