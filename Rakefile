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
  doc = Doc.new("publishing-api", "doc/api.md")
  markdown = Utils.remove_first_line(doc.fetch)

  # keep current links working
  markdown.gsub!('model.md#', 'publishing-api-model.html#')

  frontmatter = Utils.frontmatter(
    layout: 'api_layout',
    title: 'Publishing API',
    source_url: doc.source_url,
    edit_url: doc.edit_url,
  )

  markdown = "#{frontmatter} #{Utils::DO_NOT_EDIT} #{markdown}"
  File.write('_apis/publishing-api.md', markdown)

  doc = Doc.new("publishing-api", "doc/model.md")
  markdown = Utils.remove_first_line(doc.fetch)
  frontmatter = Utils.frontmatter(
    layout: 'api_layout',
    title: 'Publishing API Model',
    source_url: doc.source_url,
    edit_url: doc.edit_url,
  )

  markdown = "#{Utils::DO_NOT_EDIT} #{markdown}"
  File.write('_apis/publishing-api-model.md', markdown)
end

task :fetch_rummager_docs do
  puts "Generating search docs"

  doc = Doc.new("rummager", "docs/search-api.md")
  markdown = doc.fetch

  markdown = Utils.remove_frontmatter(markdown)

  frontmatter = Utils.frontmatter(
    layout: 'api_layout',
    title: 'Search API (Rummager)',
    navigation_weight: 75,
    source_url: doc.source_url,
    edit_url: doc.edit_url,
  )

  markdown = "#{frontmatter} #{Utils::DO_NOT_EDIT} #{markdown}"
  File.write('_apis/search-api.md', markdown)
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

task :dictionary do
  json = JSON.pretty_generate(YAML.load_file('_config/dictionary.yml'))
  File.write("_data/dictionary.json", json)
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
  :dictionary,
]
