require "capybara/rspec"

RSpec.describe ExternalDoc do
  describe ".fetch" do
    subject(:html) do
      Capybara.string(described_class.fetch(repository: repository, path: path))
    end

    let(:repository) { "example/lipsum" }
    let(:path) { "markdown.md" }

    before do
      stub_request(:get, "https://raw.githubusercontent.com/example/lipsum/master/markdown.md")
        .to_return(body: File.read("spec/fixtures/markdown.md"))
    end

    it "removes the title of the page" do
      expect(html).not_to have_selector("h1", text: "Lorem ipsum")
    end

    it "rewrites links to markdown pages" do
      expect(html).to have_link("turpis ultrices", href: "/ultrices.html")
    end

    it "does not rewrite links to markdown pages with a host" do
      expect(html).to have_link("Nam eget dui", href: "https://nam.com/eget/dui/uploading.md")
      expect(html).not_to have_link("Nam eget dui", href: "https://nam.com/eget/dui/uploading.html")
    end

    it "rewrites relative images" do
      expect(html).to have_css('img[src="https://raw.githubusercontent.com/example/lipsum/master/suspendisse_iaculis.png"]')
    end

    it "rewrites relative URLs" do
      expect(html).to have_link("tincidunt leo", href: "https://github.com/example/lipsum/blob/master/lib/tincidunt_leo.rb")
    end

    it "maintains anchor links" do
      expect(html).to have_link("Suspendisse iaculis", href: "#suspendisse-iaculis")
    end

    it "adds an id attribute to all headers so they can be accessed from a table of contents" do
      expect(html).to have_selector("h2#tldr")
    end

    it "converts heading IDs properly" do
      expect(html).to have_selector("h3#data-gov-uk")
      expect(html).to have_selector("h3#patterns-style-guides")
    end
  end

  describe ".parse" do
    it "converts arbitrary markdown to HTML" do
      markdown = <<~MD
        # Title
        [link](#anchor)
      MD
      expected_html = "\n\n<p><a href=\"#anchor\">link</a></p>"
      expect(described_class.parse(markdown).to_s).to eq(expected_html)
    end
  end
end
