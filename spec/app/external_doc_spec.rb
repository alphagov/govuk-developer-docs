RSpec.describe ExternalDoc do
  describe '.fetch' do
    subject(:markdown) { described_class.fetch(url) }

    let(:url) { 'https://example.org/markdown.md' }

    before do
      stub_request(:get, url).
        to_return(body: File.read('spec/fixtures/markdown.md'))
    end

    it 'removes the title of the page' do
      expect(markdown).to start_with('## tl;dr')
    end

    it 'rewrites links to markdown pages' do
      expect(markdown).to include('[turpis ultrices](/ultrices.html)')
    end
  end
end
