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
    no_intra_emphasis: true

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

  def publishing_api_pages
    GitHubRepoFetcher.client.docs("publishing-api").sort_by { |doc| doc[:title] }
  end

  def email_alert_api_pages
    GitHubRepoFetcher.client.docs("email-alert-api").sort_by { |doc| doc[:title] }
  end

  def active_app_pages
    AppDocs.pages.reject(&:retired?).sort_by(&:app_name)
  end

  def manual
    Manual.new(sitemap)
  end

  def teams
    ApplicationsByTeam.teams
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
end

ignore "templates/*"

ProxyPages.resources.each do |resource|
  proxy resource[:path], resource[:template], resource[:frontmatter]
end
