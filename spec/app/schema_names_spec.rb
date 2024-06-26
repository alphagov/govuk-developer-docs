RSpec.describe SchemaNames do
  it "ignores content_block_email_address" do
    allow(GovukSchemas::Schema).to receive(:schema_names).and_return(%w[foo bar content_block_email_address])

    expect(SchemaNames.all).to eql(%w[foo bar])
  end
end
