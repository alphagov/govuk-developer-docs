module UrlHelpers
  def document_type_url(document_type_name)
    "/document-types/#{document_type_name}.html"
  end

  def view_source_url
    SourceUrl.new(locals, current_page).source_url
  end

  def report_issue_url
    "https://github.com/alphagov/govuk-developer-docs/issues/new?labels=bug&title=Problem with '#{current_page.data.title}'&body=Problem with '#{current_page.data.title}' (#{config[:tech_docs][:host]}#{current_page.url})"
  end
end
