set :markdown_engine, :redcarpet

set :markdown,
  fenced_code_blocks: true,
  smartypants: true,
  with_toc_data: true

configure :development do
  activate :livereload
end

activate :sprockets
activate :syntax

configure :build do
end

require_relative './lib/dashboard/dashboard'
require_relative './lib/external_doc'
require_relative './lib/publishing_api_docs'
require_relative './lib/content_schemas/content_schema'

helpers do
  def dashboard
    Dashboard.new
  end

  def publishing_api_pages
    PublishingApiDocs.pages
  end
end

ignore 'publishing_api_template.html.md.erb'
ignore 'schema_template.html.md.erb'

PublishingApiDocs.pages.each do |page|
  proxy "/apis/publishing-api/#{page.filename}.html", "publishing_api_template.html", locals: {
    page_title: page.title,
    page: page,
  }
end

ContentSchema.schema_names.each do |schema_name|
  schema = ContentSchema.new(schema_name)

  proxy "/content-schemas/#{schema_name}.html", "schema_template.html", locals: {
    schema: schema,
    page_title: "Schema: #{schema.schema_name}",
  }
end

config[:tech_docs] = YAML.load_file('config/tech-docs.yml')
                         .with_indifferent_access
