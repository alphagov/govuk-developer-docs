class StringToId
  def self.convert(string)
    string
      .downcase # lower case
      .gsub(/<[^>]*>/, "") # crudely remove html tags
      .gsub(/[^\w\-\. ]/, "") # remove any non-word, non-hyphen & non-period characters
      .gsub(/[ \.]/, "-") # replace spaces & periods with hyphens
      .gsub(/-{2,}/, "-") # replace two (or more) subsequent hyphens with single hyphens
  end
end
