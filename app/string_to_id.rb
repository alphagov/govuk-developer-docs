class StringToId
  # Redcarpet uses a different algo to create fragment ids than github
  # which has caused a TOC bug // ref https://trello.com/c/Re6fSBKj/24-change-internal-links-to-work-or-remove-internal-links
  # this implementation modified for our purposes from version at jch/html-pipeline
  # https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/toc_filter.rb
  def self.convert(string)
    string
      .downcase # lower case
      .gsub(/<[^>]*>/, "") # crudely remove html tags
      .gsub(/[^\w\-\. ]/, "") # remove any non-word, non-hyphen & non-period characters
      .gsub(/[ \.]/, "-") # replace spaces & periods with hyphens
      .gsub(/-{2,}/, "-") # replace two (or more) subsequent hyphens with single hyphens
  end
end
