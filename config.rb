require "govuk_tech_docs"
require_relative "./app/requires"

GovukTechDocs.configure(self)

set :markdown,
    renderer: DeveloperDocsRenderer.new(
      with_toc_data: true,
      api: true,
      context: self,
    ),
    fenced_code_blocks: true,
    tables: true,
    no_intra_emphasis: true,
    hard_wrap: false

configure :development do
  # Disable Google Analytics in development
  config[:tech_docs][:ga_tracking_id] = nil
end

# Configure the sitemap for Google
set :url_root, config[:tech_docs][:host]
activate :search_engine_sitemap,
         default_change_frequency: "weekly"

helpers do
  def dashboard
    Dashboard.new
  end

  def manual
    Manual.new(sitemap)
  end

  def related_things
    @related_things ||= RelatedThings.new(manual, current_page)
  end

  def section_url
    StringToId.convert(current_page.data.section)
  end

  def page_title
    (defined?(locals) && locals[:title]) || [current_page.data.title, current_page.data.section].compact.join(" - ")
  end

  def sanitize(contents)
    ActionController::Base.helpers.sanitize(contents)
  end
end

ignore "templates/*"

unless ENV["SKIP_PROXY_PAGES"] == "true"
  ProxyPages.resources.each do |resource|
    proxy resource[:path], resource[:template], resource[:frontmatter]
  end
end
