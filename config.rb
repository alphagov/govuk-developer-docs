require_relative './lib/requires'

set :markdown_engine, :redcarpet

set :markdown,
    renderer: TechDocsHTMLRenderer.new(
      with_toc_data: true
    ),
    fenced_code_blocks: true,
    tables: true

configure :development do
  activate :livereload
end

activate :autoprefixer
activate :sprockets
activate :syntax

configure :build do
end

helpers do
  def dashboard
    Dashboard.new
  end

  def publishing_api_pages
    PublishingApiDocs.pages
  end

  def app_pages
    AppDocs.pages.sort_by(&:title)
  end
end

ignore 'templates/*'

PublishingApiDocs.pages.each do |page|
  proxy "/apis/publishing-api/#{page.filename}.html", "templates/publishing_api_template.html", locals: {
    page_title: page.title,
    page: page,
  }
end

GovukSchemas::Schema.schema_names.each do |schema_name|
  schema = ContentSchema.new(schema_name)

  proxy "/content-schemas/#{schema_name}.html", "templates/schema_template.html", locals: {
    schema: schema,
    page_title: "Schema: #{schema.schema_name}",
  }
end

AppDocs.pages.each do |application|
  proxy "/apps/#{application.app_name}.html", "templates/application_template.html", locals: {
    page_title: application.title,
    application: application,
  }
end

DocumentTypes.pages.each do |page|
  proxy "/document-types/#{page.name}.html", "templates/document_type_template.html", locals: {
    page: page,
    page_title: page.name
  }
end

config[:tech_docs] = YAML.load_file('config/tech-docs.yml')
                         .with_indifferent_access
