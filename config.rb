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

helpers do
  def dashboard
    Dashboard.new
  end
end
