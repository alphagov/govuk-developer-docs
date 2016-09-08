require 'json'

desc "Regenerate data for overview pages"
task :build_overview_pages do
  require_relative './lib/content_generator/content'
  content = Content.new.as_json
  File.open('_data/content.json', 'w') do |f|
    f.write(JSON.dump(content))
  end
end

desc "Regenerate schema documentation"
task :generate_schema_docs do
  require_relative './lib/content_schemas/generator'
  Generator.generate_markdown_for_all_schemas
end

desc "Regenerate all static data for the site (default)"
task :build_data => [:build_overview_pages, :generate_schema_docs]
task :default => [:build_data]
