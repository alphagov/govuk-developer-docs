RSpec.describe ExternalDoc do
  describe '.fetch' do
    it 'returns the markdown file without title' do
      stub_request(:get, "https://example.org/markdown.md").
        to_return(body: File.read("spec/fixtures/markdown.md"))

      text = ExternalDoc.fetch('https://example.org/markdown.md')

      expect(text).to eql('And some text')
    end
  end
end
