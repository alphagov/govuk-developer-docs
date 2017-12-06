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

  # Disable Google Analytics in development
  config[:tech_docs][:ga_tracking_id] = nil
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

  def manual_index_page
    ManualIndexPage.new(sitemap)
  end

  def manual
    Manual.new(sitemap)
  end

  def teams
    ApplicationsByTeam.teams
  end

  def page_review
    @page_review ||= PageReview.new(current_page)
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

  proxy "/apps/#{application.app_name}.json", "templates/json_response.json", locals: {
    payload: application.api_payload,
  }
end

DocumentTypes.pages.each do |document_type|
  proxy "/document-types/#{document_type.name}.html", "templates/document_type_template.html", locals: {
    title: "Document type: #{document_type.name}",
    description: "Everything about the '#{document_type.name}' document type",
    page: document_type,
  }
end

Supertypes.all.each do |supertype|
  proxy "/document-types/#{supertype.id}.html", "templates/supertype_template.html", locals: {
    title: "#{supertype.name} supertype",
    description: supertype.description,
    supertype: supertype,
  }
end

YAML.load_file('data/redirects.yml').each do |from, to|
  redirect from, to: to
end
