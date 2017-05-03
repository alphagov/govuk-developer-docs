class Snippet
  def self.generate(html)
    html
      .split('</h1>')[1..-1].join # make sure we skip anything before <h1>
      .gsub(/<h.+?>.+?<\/h.>/, "") # remove headings
      .gsub(/<\/?[^>]*>/, "") # remove other HTML but keep the contents
      .squish # remove whitespace
      .truncate(300) # http://stackoverflow.com/questions/8914476/facebook-open-graph-meta-tags-maximum-content-length
  end
end
