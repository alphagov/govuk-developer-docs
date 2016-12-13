set :markdown_engine, :redcarpet

set :markdown,
  fenced_code_blocks: true,
  smartypants: true,
  with_toc_data: true

configure :development do
  activate :livereload
end

activate :sprockets

configure :build do
end

require_relative './lib/dashboard/dashboard'
require_relative './lib/external_doc'
require_relative './lib/publishing_api_docs'

helpers do
  def dashboard
    Dashboard.new
  end

  def publishing_api_pages
    PublishingApiDocs.pages
  end
end

ignore 'publishing_api_template.html.md.erb'

PublishingApiDocs.pages.each do |page|
  proxy "/apis/publishing-api/#{page.filename}.html", "publishing_api_template.html", locals: {
    page_title: page.title,
    page: page,
  }
end

config[:tech_docs] = YAML.load_file('config/tech-docs.yml')
                         .with_indifferent_access
