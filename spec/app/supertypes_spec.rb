RSpec.describe Supertypes do
  describe ".all" do
    it "works" do
      stub_request(:get, "https://raw.githubusercontent.com/alphagov/govuk_document_types/master/data/supertypes.yml").
        to_return(body: File.read("spec/fixtures/supertypes.yml"))

      supertypes = Supertypes.all

      expect(supertypes.first).to be_a(Supertypes::Supertype)
    end
  end
end
