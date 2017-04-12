require_relative './app/requires'

config[:tech_docs] = YAML.load_file('config/tech-docs.yml').with_indifferent_access

set :markdown_engine, :redcarpet

set :markdown,
    renderer: DeveloperDocsRenderer.new(
      with_toc_data: true
    ),
    fenced_code_blocks: true,
    tables: true,
    no_intra_emphasis: true

configure :development do
  activate :livereload
end

activate :autoprefixer
activate :sprockets
activate :syntax

# Configure the sitemap for Google
set :url_root, config[:tech_docs][:host]
activate :search_engine_sitemap,
  default_change_frequency: 'weekly'

configure :build do
  activate :minify_css
  activate :minify_javascript
end

helpers do
  def dashboard
    Dashboard.new
  end

  def publishing_api_pages
    PublishingApiDocs.pages.sort_by(&:title)
  end

  def active_app_pages
    AppDocs.pages.reject(&:retired?).sort_by(&:app_name)
  end

  def manual_pages_grouped_by_section
    manual_pages
      .group_by { |page| page.data.section || "Uncategorised" }
      .sort_by(&:first)
  end

  def most_important_pages
    manual_pages.select { |page| page.data.important }
  end

  def manual_pages
    sitemap.resources
      .select { |page| page.path.start_with?('manual/') && page.path.end_with?('.html') }
      .sort_by { |page| page.data.title.downcase || raise("#{page.path} doesn't have a title") }
  end

  def teams
    ApplicationsByTeam.teams
  end

  def page_freshness
    PageFreshness.new(sitemap)
  end

  require 'table_of_contents/helpers'
  include TableOfContents::Helpers
end

ignore 'templates/*'

PublishingApiDocs.pages.each do |page|
  proxy "/apis/publishing-api/#{page.filename}.html", "templates/publishing_api_template.html", locals: {
    title: "Publishing API: #{page.title}",
    page: page,
  }
end

GovukSchemas::Schema.schema_names.each do |schema_name|
  schema = ContentSchema.new(schema_name)

  proxy "/content-schemas/#{schema_name}.html", "templates/schema_template.html", locals: {
    title: "Schema: #{schema.schema_name}",
    description: "Everything about the '#{schema.schema_name}' schema",
    schema: schema,
  }
end

AppDocs.pages.each do |application|
  proxy "/apps/#{application.app_name}.html", "templates/application_template.html", locals: {
    title: application.page_title,
    description: "Everything about the #{application.app_name} application (#{application.description})",
    application: application,
  }
end

DocumentTypes.pages.each do |document_type|
  proxy "/document-types/#{document_type.name}.html", "templates/document_type_template.html", locals: {
    title: "Document type: #{document_type.name}",
    description: "Everything about the '#{document_type.name}' document type",
    page: document_type,
  }
end

YAML.load_file('data/redirects.yml').each do |from, to|
  redirect from, to: to
end
