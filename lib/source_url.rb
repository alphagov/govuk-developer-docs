class SourceUrl
  attr_reader :locals, :current_page

  def initialize(locals, current_page)
    @locals = locals
    @current_page = current_page
  end

  def source_url
    override_from_page || source_from_yaml_file || source_from_file
  end

private

  # If a `page` local exists, see if it has a `source_url`. This is used by the
  # pages that are created by the proxy system because they can't use frontmatter
  def override_from_page
    locals.key?(:page) ? locals[:page].try(:source_url) : false
  end

  # In the frontmatter we can specify a `source_url`. Use this if the actual
  # source of the page is in another GitHub repo.
  def source_from_yaml_file
    current_page.data.source_url
  end

  # As the last fallback link to the source file in this repository.
  def source_from_file
    "https://github.com/alphagov/govuk-developer-docs/blob/master/source/#{current_page.file_descriptor[:relative_path]}"
  end
end
