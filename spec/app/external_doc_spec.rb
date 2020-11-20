require "capybara/rspec"

RSpec.describe ExternalDoc do
  describe ".parse" do
    it "converts arbitrary markdown to HTML" do
      markdown = <<~MD
        # Title
        [link](#anchor)
      MD
      expected_html = "\n<p><a href=\"#anchor\">link</a></p>"
      expect(described_class.parse(markdown).to_s).to eq(expected_html)
    end

    it "forces encoding to UTF-8 " do
      markdown = String.new(
        "These curly quotes “make commonmarker throw an exception”",
        encoding: "ASCII-8BIT",
      )
      expected_html = "<p>These curly quotes “make commonmarker throw an exception”</p>"
      expect(described_class.parse(markdown).to_s).to eq(expected_html)
    end

    context "when passed a repository and path" do
      subject(:html) do
        Capybara.string(described_class.parse(
          File.read("spec/fixtures/markdown.md"),
          repository: "lipsum",
          path: "markdown.md",
        ).to_s)
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
        expect(html).to have_css('img[src="https://raw.githubusercontent.com/alphagov/lipsum/master/suspendisse_iaculis.png"]')
      end

      it "rewrites relative URLs" do
        expect(html).to have_link("tincidunt leo", href: "https://github.com/alphagov/lipsum/blob/master/lib/tincidunt_leo.rb")
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
  end

  describe ".title" do
    it "returns the title from markdown" do
      markdown = <<~MD
        #Title
        [link](#anchor)
      MD
      expect(described_class.title(markdown)).to eq("Title")
    end

    it "strips extra spaces from the title markdown" do
      markdown = "#  My Title"
      expect(described_class.title(markdown)).to eq("My Title")
    end

    it "returns nil if no title is found" do
      markdown = ""
      expect(described_class.title(markdown)).to be_nil
    end
  end
end
