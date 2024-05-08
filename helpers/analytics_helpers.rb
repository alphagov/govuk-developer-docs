module AnalyticsHelpers
  def urlize(string)
    string.downcase.gsub(" ", "_").gsub("-", "_")
  end

  def build_event(data, attributes = [], event_name = nil, output = {})
    event_name ||= find_event_name(data)
    data.sort_by { |k, _v| k["name"] }.each do |item|
      name = item["name"]
      value = item["value"]
      variant = nil

      # look up name in the attributes, compare with this event's event_name, check if matching variant
      if attributes.any? && !variant
        attribute = attributes.find { |x| x["name"] == name }
        variant = find_variant(event_name, attribute) if attribute
      end

      if value
        case value
        when String
          output[name] = {
            "value" => value,
            "variant" => variant,
          }
        when Array
          output[name] = build_event(value, attributes, event_name)
        end
      else
        output[name] = {
          "value" => attribute ? attribute["type"] : value,
          "variant" => variant,
        }
      end
    end
    output
  end

  def find_variant(event_name, attribute)
    if attribute["variants"]
      attribute["variants"].each do |variant|
        return event_name if variant["event_name"] == event_name
      end
    end

    nil
  end

  def to_html(hash, html = "")
    html += "<ul class='govuk-list indented-list'>"
    hash.each do |key, value|
      if value.key?("value")
        link = "/analytics/attribute_#{urlize(key)}.html"
        link = "/analytics/attribute_#{urlize(key)}/variant_#{value['variant']}.html" if value["variant"]
        html += "<li><a href='#{link}' class='govuk-link'>#{key}</a>: #{value['value']}</li>"
      else
        html += "<li>#{key}: #{to_html(value)}</li>"
      end
    end
    html += "</ul>"
    html
  end

  def tag_colours
    {
      "high" => "govuk-tag--red",
      "medium" => "govuk-tag--yellow",
      "low" => "govuk-tag--green",
    }
  end

  def implementation_percentage(events)
    implemented = events.select { |x| x["implemented"] == true }.count
    percentage = ((implemented.to_f / events.count) * 100.00).round(2)
    percentage = 0 if implemented.zero? || events.count.zero?
    "#{implemented} of #{events.count} (#{percentage}%)"
  end

  def create_page_title(title)
    header = ["GOV.UK GA4 Implementation record"]
    header.prepend(title) if title
    header.join(" | ")
  end

  def events_by_type(events = nil)
    events ||= data.analytics.events.map { |e| JSON.parse(e.to_json) }
    by_type = {}
    events.each do |event|
      event["events"].each_with_index do |e, index|
        event_name = find_event_name(e["data"])
        result = {
          name: event["name"],
          event_name: e["name"],
          index:,
        }
        if by_type[event_name.to_sym]
          by_type[event_name.to_sym][:events] << result
        else
          by_type[event_name.to_sym] = {
            name: event_name,
            events: [
              result,
            ],
          }
        end
      end
    end

    by_type
  end

  def find_event_name(data)
    data.each do |item|
      next unless item["name"] == "event_data"

      item["value"].each do |i|
        return i["value"] if i["name"] == "event_name"
      end
    end

    "undefined"
  end
end
