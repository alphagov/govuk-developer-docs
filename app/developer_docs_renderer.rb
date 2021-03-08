require_relative "./string_to_id"

class DeveloperDocsRenderer < GovukTechDocs::TechDocsHTMLRenderer
  def header(text, header_level)
    anchor = StringToId.convert(text)
    tag = "h#{header_level}"
    "<#{tag} id='#{anchor}'>#{text}</#{tag}>"
  end
end
