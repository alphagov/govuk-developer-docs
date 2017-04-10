require 'simplecov'
SimpleCov.start

require 'webmock/rspec'

require_relative './../app/requires'

RSpec.configure do |config|
  config.before do
    WebMock.reset!
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand config.seed
end
