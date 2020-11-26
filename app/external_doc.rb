require "html/pipeline"
require "uri"
require_relative "./string_to_id"

class ExternalDoc
  def self.parse(markdown, repository: "", path: "")
    context = {
      repository: repository,
      # Turn off hardbreaks as they behave different to github rendering
      gfm: false,
      base_url: URI.join(
        "https://github.com",
        "alphagov/#{repository}/blob/master/",
      ),
      image_base_url: URI.join(
        "https://raw.githubusercontent.com",
        "alphagov/#{repository}/master/",
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
      .to_html(markdown.to_s.force_encoding("UTF-8"), context)
  end

  def self.title(markdown)
    markdown_title = markdown.split("\n")[0].to_s.match(/#(.+)/)
    return nil unless markdown_title

    markdown_title[1].strip
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

        next if uri.scheme || href.start_with?("#")

        base = if path.start_with? "/"
                 base_url
               else
                 subpage_url
               end

        element["href"] = URI.join(base, href).to_s
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
        if is_github_link?(uri.host) && opted_into_docs_consumption?(repository)
          doc_name = internal_doc_name(repository, uri.path)
          element["href"] = internal_doc_path(repository, doc_name) if doc_name
        end
      end

      doc
    end

  private

    def is_github_link?(host)
      host == "github.com"
    end

    def opted_into_docs_consumption?(repository)
      AppDocs.apps_with_docs.map(&:github_repo_name).include?(repository)
    end

    def internal_doc_name(repository, uri_path = "")
      internal_doc = uri_path.match(/^\/alphagov\/#{repository}\/blob\/(?:main|master)\/docs\/([^\/]+)\.md$/)
      internal_doc.is_a?(MatchData) ? internal_doc[1] : nil
    end

    def internal_doc_path(repository, doc_name)
      "/apis/#{repository}/#{doc_name}.html"
    end
  end

  # Removes the H1 from the page so that we can choose our own title
  class PrimaryHeadingFilter < HTML::Pipeline::Filter
    def call
      h1 = doc.at("h1:first-of-type")
      h1.unlink if h1.present?
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
