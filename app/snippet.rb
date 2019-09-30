class Snippet
  def self.generate(html)
    body_text = html
      .split("</h1>")[1..-1].join # make sure we skip anything before <h1>
      .gsub(/<h.+?>.+?<\/h.>/, "") # remove headings
      .gsub(/<\/?[^>]*>/, "") # remove other HTML but keep the contents
      .squish # remove whitespace

    # unescape HTML entities to avoid double encoding
    unescaped_text = Nokogiri::HTML.parse(body_text).text

    unescaped_text.truncate(300) # http://stackoverflow.com/questions/8914476/facebook-open-graph-meta-tags-maximum-content-length
  end
end
