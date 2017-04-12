require 'middleman-core/renderers/redcarpet'

class TechDocsHTMLRenderer < Middleman::Renderers::MiddlemanRedcarpetHTML
  include Redcarpet::Render::SmartyPants

  def header(text, level)
    anchor = UniqueIdentifierGenerator.instance.create(text, level)
    %(<h#{level} id="#{anchor}">#{text}</h#{level}>)
  end

  def image(link, *args)
    %(<a href="#{link}" target="_blank" rel="noopener noreferrer">#{super}</a>)
  end

  def table(header, body)
    %(<div class="table-container">
      <table>
        #{header}#{body}
      </table>
    </div>)
  end
end
