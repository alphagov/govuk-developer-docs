require 'yaml'
require 'json'
require 'http'
require 'active_support/core_ext/hash'

require_relative './lib/doc'
require_relative './lib/utils'

desc "Regenerate data for overview pages"
task :build_dashboard do
  puts "Building dashboard pages"
  require_relative './lib/dashboard/content'
  content = Content.new.as_json
  File.open('_data/content.json', 'w') do |f|
    f.write(JSON.pretty_generate(content))
  end
end

desc "Regenerate schema documentation"
task :generate_schema_docs do
  require_relative './lib/content_schemas/generator'
  Generator.generate_markdown_for_all_schemas
end

task :fetch_publishing_api_docs do
  puts "Generating publishing-api docs"
  markdown = Doc.new("publishing-api", "doc/api.md").fetch
  markdown = Utils.remove_first_line(markdown)

  # keep current links working
  markdown.gsub!('model.md#', 'publishing-api-model.html#')

  markdown = "#{Utils::DO_NOT_EDIT} #{markdown}"
  File.write('_includes/publishing-api.md', markdown)

  markdown = Doc.new("publishing-api", "doc/model.md").fetch
  markdown = Utils.remove_first_line(markdown)
  markdown = "#{Utils::DO_NOT_EDIT} #{markdown}"
  File.write('_includes/publishing-api-model.md', markdown)
end

task :fetch_rummager_docs do
  puts "Generating search docs"

  doc = Doc.new("rummager", "docs/search-api.md")
  markdown = doc.fetch

  markdown = Utils.remove_frontmatter(markdown)

  frontmatter = Utils.frontmatter(
    layout: 'default',
    title: 'Search API',
    navigation_weight: 75,
    source_url: doc.source_url,
    edit_url: doc.edit_url,
  )

  markdown = "#{frontmatter} #{Utils::DO_NOT_EDIT} #{markdown}"
  File.write('_includes/search-api.md', markdown)
end

task :fetch_gem_documentation do
  puts "Generating gem documentation"
  require_relative './lib/gem_documentation_fetcher'
  GemDocumentationFetcher.new.fetch_docs
end

task :generate_word_graph do
  puts "Generating graphs"
  begin
    require "graphviz"
    GraphViz.parse("_config/words.dot").output(png: "assets/images/words.png")
  rescue => e
    puts "Couldn't generate graph: #{e.message}"
  end
end

task :fetch_styleguides do
  puts "Fetching styleguides"
  require_relative './lib/styleguide_fetcher'
  StyleGuideFetcher.new.fetch_guides
end

task :generate_pinfile_graph_data do
  begin
    puts "Generating dependency data for apps"
    require_relative './lib/bowler_graph'
    BowlerGraph.new.generate
  rescue => e
    puts "Couldn't generate data: #{e.message}"
  end
end

task :build => [
  :build_dashboard,
  :generate_schema_docs,
  :fetch_publishing_api_docs,
  :fetch_rummager_docs,
  :fetch_styleguides,
  :fetch_gem_documentation,
  :generate_word_graph,
  :generate_pinfile_graph_data,
]
