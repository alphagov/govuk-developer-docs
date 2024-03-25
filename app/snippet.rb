require "sanitize"

class Snippet
  HEADINGS = %i[h1 h2 h3 h4 h5 h6].freeze

  def self.generate(html)
    # Discard first heading and everything before it.
    fragment = html.partition("</h1>")[2]

    remove_headings = Sanitize::Config.merge(
      Sanitize::Config::DEFAULT,
      remove_contents: Sanitize::Config::DEFAULT[:remove_contents] + HEADINGS,
    )

    snippet = Sanitize.fragment(fragment, remove_headings)
    Nokogiri::HTML.parse(snippet).text # Avoid double-encoding.
      .squish
      .truncate(300) # https://stackoverflow.com/a/8916327
  end
end
