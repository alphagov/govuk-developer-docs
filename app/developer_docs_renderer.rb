class DeveloperDocsRenderer < TechDocsHTMLRenderer
  def header(text, header_level)
    %(<h#{header_level} id="#{githubify_fragment_id(text)}" class="anchored-heading">
        <a href="##{githubify_fragment_id(text)}" class="anchored-heading__icon" aria-hidden="true"></a>
        #{text}
      </h#{header_level}>)
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
