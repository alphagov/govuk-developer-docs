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

# Set the directory to /docs so GitHub can serve it
set :build_dir, 'docs'

require_relative './lib/dashboard/dashboard'

helpers do
  def dashboard
    Dashboard.new
  end
end
