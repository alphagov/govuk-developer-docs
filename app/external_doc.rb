require "html/pipeline"
require "uri"
require_relative "./string_to_id"

class ExternalDoc
  def self.fetch(repository:, path:)
    contents = HTTP.get(
      "https://raw.githubusercontent.com/#{repository}/master/#{path}",
    )

    context = {
      # Turn off hardbreaks as they behave different to github rendering
      gfm: false,
      base_url: URI.join(
        "https://github.com",
        "#{repository}/blob/master/",
      ),

      image_base_url: URI.join(
        "https://raw.githubusercontent.com",
        "#{repository}/master/",
      ),
    }

    context[:subpage_url] =
      URI.join(context[:base_url], File.join(".", File.dirname(path), "/"))

    context[:image_subpage_url] =
      URI.join(context[:image_base_url], File.join(".", File.dirname(path), "/"))

    filters = [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::AbsoluteSourceFilter,
      PrimaryHeadingFilter,
      HeadingFilter,
      AbsoluteLinkFilter,
      MarkdownLinkFilter,
    ]

    HTML::Pipeline
      .new(filters)
      .to_html(contents, context)
  end

  def self.parse(markdown)
    filters = [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::AbsoluteSourceFilter,
      PrimaryHeadingFilter,
      HeadingFilter,
      MarkdownLinkFilter,
    ]

    HTML::Pipeline.new(filters).call(markdown)[:output]
  end

  # When we import external documentation it can contain relative links to
  # source files within the repository that the documentation resides. We need
  # to filter out these types of links and make them absolute so that they
  # continue to work when rendered as part of GOV.UK Developer Docs.
  #
  # For example a link to `lib/link_expansion.rb` would be rewritten to
  # https://github.com/alphagov/publishing-api/blob/master/lib/link_expansion.rb
  class AbsoluteLinkFilter < HTML::Pipeline::Filter
    def call
      doc.search("a").each do |element|
        next if element["href"].nil? || element["href"].empty?

        href = element["href"].strip
        uri = URI.parse(href)
        path = uri.path

        unless uri.scheme || href.start_with?("#") || path.end_with?(".md")
          base = if path.start_with? "/"
                   base_url
                 else
                   subpage_url
                 end

          element["href"] = URI.join(base, href).to_s
        end
      end

      doc
    end

    def subpage_url
      context[:subpage_url]
    end
  end

  # When we import external documentation formatted with Markdown it can
  # contain links to other pages of documentation also formatted with Markdown.
  # When the documentation is rendered as part of GOV.UK Developer Docs we
  # render it as HTML so we need to rewrite the links so that they have a .html
  # extension to match our routing.
  #
  # For example a link to `link-expansion.md` would be rewritten to
  # `link-expansion.html`
  class MarkdownLinkFilter < HTML::Pipeline::Filter
    def call
      doc.search("a").each do |element|
        next if element["href"].nil? || element["href"].empty?

        href = element["href"].strip
        uri = URI.parse(href)
        if uri.path.end_with?(".md") && uri.host.nil?
          uri.path.sub!(/.md$/, ".html")
          element["href"] = uri.to_s
        end
      end

      doc
    end
  end

  # Removes the H1 from the page so that we can choose our own title
  class PrimaryHeadingFilter < HTML::Pipeline::Filter
    def call
      doc.at("h1:first-of-type").unlink
      doc
    end
  end

  # This adds a unique ID to each header element so that we can reference
  # each section of the document when we build our table of contents navigation.
  class HeadingFilter < HTML::Pipeline::Filter
    def call
      headers = Hash.new(0)

      doc.css("h1, h2, h3, h4, h5, h6").each do |node|
        text = node.text
        id = StringToId.convert(text)

        headers[id] += 1

        if node.children.first
          node[:id] = id
        end
      end

      doc
    end
  end
end
