class DeveloperDocsRenderer < GovukTechDocs::TechDocsHTMLRenderer
  def header(text, header_level)
    anchor = githubify_fragment_id(text)
    tag = "h" + header_level.to_s
    "<#{tag} id='#{anchor}'>#{text}</#{tag}>"
  end

  # Redcarpet uses a different algo to create fragment ids than github
  # which has caused a TOC bug // ref https://trello.com/c/Re6fSBKj/24-change-internal-links-to-work-or-remove-internal-links
  # this implementation modified for our purposes from version at jch/html-pipeline
  # https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/toc_filter.rb
  def githubify_fragment_id(text)
    text
      .downcase # lower case
      .gsub(/<[^>]*>/, '') # crudely remove html tags
      .gsub(/[^\w\- ]/, '') # remove any non-word characters
      .tr(' ', '-') # replace spaces with hyphens
  end
end
