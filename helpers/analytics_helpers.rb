module AnalyticsHelpers
  def urlize(string)
    string.downcase.gsub(" ", "_").gsub("-", "_")
  end

  def build_event(data, attributes = [], output = {})
    data.sort_by { |k, _v| k["name"] }.each do |item|
      name = item["name"]
      value = item["value"]
      if value
        case value
        when String
          output[name] = value
        when Array
          output[name] = build_event(value, attributes)
        end
      else
        attribute = attributes.find { |x| x["name"] == name }
        output[name] = attribute ? attribute["type"] : value
      end
    end
    output
  end

  def to_html(hash, html = "")
    html += "<ul class='govuk-list indented-list'>"
    hash.each do |key, value|
      case value
      when String
        html += "<li><a href='/analytics/attribute_#{urlize(key)}.html'>#{key}</a>: #{value}</li>"
      when Hash
        html += "<li>#{key}: #{to_html(value)}</li>"
      end
    end
    html += "</ul>"
    html
  end
end
