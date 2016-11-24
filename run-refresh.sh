# Clone the content schemas so we can access them
rm -rf /tmp/govuk-content-schemas
git clone git@github.com:alphagov/govuk-content-schemas.git /tmp/govuk-content-schemas
export GOVUK_CONTENT_SCHEMAS_PATH=/tmp/govuk-content-schemas

# Recreate docs for gds-api-adapters
rm -rf /tmp/gds-api-adapters
git clone git@github.com:alphagov/gds-api-adapters.git /tmp/gds-api-adapters
export GDS_API_PATH=/tmp/gds-api-adapters
(
  cd /tmp/gds-api-adapters
  bundle install --path "${HOME}/bundles/${JOB_NAME}"
  bundle exec yard doc --one-file
)

# Recreate docs for slimmer
rm -rf /tmp/slimmer
git clone git@github.com:alphagov/slimmer.git /tmp/slimmer
export SLIMMER_PATH=/tmp/slimmer
(
  cd /tmp/slimmer
  bundle install --path "${HOME}/bundles/${JOB_NAME}"
  bundle exec yard doc --one-file
)

# Run the build
bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment
bundle exec rake build
git add .
git commit -m "Refresh data from GitHub"
git push origin master:master
