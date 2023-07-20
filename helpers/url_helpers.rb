module UrlHelpers
  def document_type_url(document_type_name)
    "/document-types/#{document_type_name}.html"
  end

  def slack_url(channel_name)
    "https://gds.slack.com/channels/#{channel_name.sub('#', '')}"
  end
end
