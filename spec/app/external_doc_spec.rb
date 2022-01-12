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
      before do
        lipsum = double(
          "Lipsum",
          app_name: "Lipsum",
          github_repo_name: "lipsum",
        )
        allow(Repos).to receive(:all) { [lipsum] }
      end

      let(:path) { "markdown.md" }

      subject(:html) do
        Capybara.string(described_class.parse(
          File.read("spec/fixtures/markdown.md"),
          repository: "lipsum",
          path: path,
        ).to_s)
      end

      it "removes the title of the page" do
        expect(html).not_to have_selector("h1", text: "Lorem ipsum")
      end

      it "does not rewrite links to markdown pages with a host" do
        expect(html).to have_link("Absolute link", href: "https://nam.com/eget/dui/absolute-link.md")
      end

      it "converts relative links to absolute GitHub URLs" do
        expect(html).to have_link("inline link", href: "https://github.com/alphagov/lipsum/blob/main/inline-link.md")
      end

      it "converts aliased links to absolute GitHub URLs" do
        expect(html).to have_link("aliased link", href: "https://github.com/alphagov/lipsum/blob/main/lib/aliased_link.rb")
      end

      it "converts relative GitHub links to Developer Docs HTML links if it is an imported document" do
        expect(html).to have_link("Relative docs link with period", href: "/repos/lipsum/prefixed.html")
        expect(html).to have_link("Relative docs link without period", href: "/repos/lipsum/no-prefix.html")
      end

      it "converts relative links to absolute GitHub URLs if link is outside of the `docs` folder" do
        expect(html).to have_link("inline link", href: "https://github.com/alphagov/lipsum/blob/main/inline-link.md")
      end

      it "converts relative links to absolute GitHub URLs if link is in a subfolder of the `docs` folder" do
        expect(html).to have_link("Subfolder", href: "https://github.com/alphagov/lipsum/blob/main/docs/some-subfolder/foo.md")
      end

      it "converts links relative to the 'root' to absolute GitHub URLs" do
        expect(html).to have_link("Link relative to root", href: "https://github.com/alphagov/lipsum/blob/main/public/json_examples/requests/foo.json")
      end

      context "the document we are parsing is in the `docs` folder" do
        let(:path) { "docs/some-document.md" }

        it "converts links relative to the `docs` folder and applies the same business logic as before" do
          expect(html).to have_link("inline link", href: "/repos/lipsum/inline-link.html")
        end

        it "converts links relative to the 'root' to absolute GitHub URLs" do
          expect(html).to have_link("Link relative to root", href: "https://github.com/alphagov/lipsum/blob/main/public/json_examples/requests/foo.json")
        end
      end

      it "rewrites relative images" do
        expect(html).to have_css('img[src="https://raw.githubusercontent.com/alphagov/lipsum/main/suspendisse_iaculis.png"]')
      end

      it "treats URLs containing non-default ports as absolute URLs" do
        expect(html).to have_link("localhost", href: "localhost:999")
      end

      it "skips over URLs with trailing unicode characters" do
        expect(html).not_to have_link("http://localhost:3108")
        expect(html).not_to have_link("http://localhost:3108”")
        expect(html).to have_content("Visit “http://localhost:3108”")
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
