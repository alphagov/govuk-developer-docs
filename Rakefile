namespace :assets do
  task :precompile do
    sh 'git clone https://github.com/alphagov/govuk-content-schemas.git /tmp/govuk-content-schemas --depth=1 && GOVUK_CONTENT_SCHEMAS_PATH=/tmp/govuk-content-schemas middleman build'
  end
end
