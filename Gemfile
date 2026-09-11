source "https://rubygems.org"

gem "activesupport"
gem "csv"
gem "dotenv"
gem "ffi"
gem "mutex_m" # TODO: remove direct dependency on mutex_m once govuk_tech_docs updates from activesupport-7.0.8.1.
gem "rake"
gem "sanitize"
gem "webmock"

gem "govuk_tech_docs"
gem "middleman"
gem "middleman-search_engine_sitemap"

gem "git"
gem "html-pipeline", "~>3.2" # TODO: remove direct dependency + constraint for html-pipeline once govuk_tech_docs is fixed.
gem "mdl"

gem "govuk_publishing_components"
gem "govuk_schemas"

# GitHub API
gem "faraday-http-cache"
gem "faraday_middleware"
gem "octokit"

group :test, :development do
  gem "byebug"
  gem "capybara"
  gem "rspec"
  gem "rubocop-govuk", require: false
  gem "simplecov", require: false
end
