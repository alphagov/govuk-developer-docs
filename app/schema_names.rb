class SchemaNames
  # TODO: We can't use `content_block_email_address`, as is relies on functionality
  # in the later versions of `GovukSchemas`, which is blocked by dependency issues
  # with Middleman. We have an upstream PR (https://github.com/middleman/middleman/pull/2709)
  # that, once merged will unblock this issue
  def self.all
    (GovukSchemas::Schema.schema_names - %w[content_block_email_address])
  end
end
