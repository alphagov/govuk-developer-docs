require 'nokogiri'

class GemDocumentationFetcher
  def fetch_docs
    fetch_gds_api_adapters
    fetch_slimmer_docs
  end

  def fetch_slimmer_docs
    slimmer_directory = ENV["SLIMMER_PATH"] || "../slimmer"

    begin
      html = File.read("#{slimmer_directory}/docs/index.html")
    rescue Errno::ENOENT
      puts "Can't find slimmer docs. Run `bundle exec yard doc --one-file`"
      return
    end

    doc = Nokogiri::HTML(html)
    actual_content = doc.search('#content')

    actual_content.search('#label-GDS+API+Adapters').remove

    clean(actual_content)

    frontmatter = Utils.frontmatter(
      layout: 'gem_layout',
      title: 'Slimmer',
      permalink: 'slimmer.html'
    )

    File.write("_gems/slimmer.html", "#{frontmatter} #{Utils::DO_NOT_EDIT} #{actual_content}")
  end

  def fetch_gds_api_adapters
    gds_api_directory = ENV["GDS_API_PATH"] || "../gds-api-adapters"

    begin
      html = File.read("#{gds_api_directory}/docs/index.html")
    rescue Errno::ENOENT
      puts "Can't find gds-api-adapters docs. Run `bundle exec yard doc --one-file`"
      return
    end

    doc = Nokogiri::HTML(html)
    actual_content = doc.search('#content')

    actual_content.search('#label-GDS+API+Adapters').remove
    clean(actual_content)

    frontmatter = Utils.frontmatter(
      layout: 'gem_layout',
      title: 'GDS API Adapters',
      permalink: 'gds-api-adapters.html'
    )

    File.write("_gems/gds-api-adapters.html", "#{frontmatter} #{Utils::DO_NOT_EDIT} #{actual_content}")
  end

private

  def clean(actual_content)
    actual_content.search('.source_code').remove
    actual_content.search('small').remove
    # remove "Documentation by YARD" & "Top Level Namespace"
    actual_content.search('h1').first(2).compact.map(&:remove)
    actual_content.search('.clear').remove
    actual_content.search('dl.box').remove

    actual_content.search('h1').each do |h1|
      h1.name = 'h2'
    end

    actual_content.to_s.gsub!("\n\n", " ")
    actual_content.to_s.gsub!("\n ", " ")
    actual_content.to_s.gsub!("  ", " ")
  end
end
