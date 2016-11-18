require 'nokogiri'

class GemDocumentationFetcher
  def fetch_docs
    fetch_gds_api_adapters
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
    actual_content.search('.source_code').remove

    actual_content.search('h1').each do |h1|
      h1.name = 'h2'
    end

    frontmatter = Utils.frontmatter(
      layout: 'default',
      title: 'APIs',
      navigation_weight: 75,
      permalink: 'gds-api-adapters.html'
    )

    actual_content = actual_content.to_s.gsub("  ", " ")

    File.write("_generated_pages/gds-api-adapters.html", "#{frontmatter} #{Utils::DO_NOT_EDIT} #{actual_content}")
  end
end
