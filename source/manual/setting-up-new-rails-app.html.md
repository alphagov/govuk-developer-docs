---
owner_slack: "#govuk-developers"
title: Set up a new Rails application
section: Applications
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-22
review_in: 6 months
---

[govuk-puppet]: https://github.com/alphagov/govuk-puppet/blob/master/docs/adding-a-new-app.md#including-the-app-on-machines
[govuk-puppet-jenkins]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml
[dns]: https://docs.publishing.service.gov.uk/manual/dns.html#making-changes-to-publishingservicegovuk
[govuk-saas-config]: https://github.com/alphagov/govuk-saas-config
[govuk-app-deployment]: https://github.com/alphagov/govuk-app-deployment
[sentry]: https://sentry.io/settings/govuk/teams/
[release]: https://release.publishing.service.gov.uk/applications
[deploy-jenkins]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/
[docs-applications]: https://github.com/alphagov/govuk-developer-docs/blob/master/data/applications.yml

## Bootstrapping a new application

To create a rails app, run the following (skip uncommon stuff).

```
rails new myapp --skip-javascript --skip-test --skip-bundle --skip-spring --skip-action-cable --skip-action-mailer --skip-active-storage
```

Replace the Gemfile with the gems you need. Here is an example.

```
ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "rails", "~> 5.2"

gem "bootsnap", "~> 1"
gem "gds-api-adapters", "~> 52"
gem "gds-sso", "~> 13"
gem "govuk_app_config", "~> 1"
gem "govuk_publishing_components", "~> 9.5"
gem "pg", "~> 1"
gem "plek", "~> 2"
gem "uglifier", "~> 4"

group :development do
  gem "listen", "~> 3"
end

group :test do
  gem "simplecov", "~> 0.16"
end

group :development, :test do
  gem "byebug", "~> 10"
  gem "rspec-rails", "~> 3"
  gem "rubocop-govuk"
  gem "scss-lint-govuk"
end
```

Run `bundle && rails g rspec:install` and replace `spec/*helper.rb`.

```
## spec/rails_helper.rb
rm spec/rails_helper.rb

## spec/spec_helper.rb
require "byebug"
require "simplecov"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
SimpleCov.start

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end
```

In config, replace the content of `database.yml` with the following.

```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 12
  template: template0

development:
  <<: *default
  database: myapp_development
  url: <%= ENV["DATABASE_URL"]%>

test:
  <<: *default
  database: myapp_test
  url: <%= ENV["TEST_DATABASE_URL"] %>

production:
  <<: *default
  database: myapp_production
  url: <%= ENV["DATABASE_URL"]%>
```

In config, replace `credentials.yml.env` and `master.key` with `secrets.yml`.

```
development:
  secret_key_base: secret

test:
  secret_key_base: secret

production:
  secret_key_base: <%= ENV['SECRET_KEY_BASE'] %>
```

In config, replace the content of `routes.rb` with the following healthcheck.

```
Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
end
```

Now is a good time to run `bin/setup`. Lastly, create `lib/tasks/lint.rake` with this.

```
desc "Lint files"
task "lint" do
  sh "rubocop --format clang"
  sh "scss-lint app/assets/stylesheets"
end
```

Then add `task default: %i(spec lint)` in Rakefile and finally run `rake`.

## Puppet, DNS, Sentry and beyond

  * To prepare the servers for your app, follow the doc in [govuk-puppet]
  * To configure app deployments, follow the docs in [govuk-app-deployment]
  * To enable external DNS, follow the article in the [Developer Docs][dns]
  * Make a PR to add your app to [data/applications.yml][docs-applications] for these docs
  * Then ask 2nd line to run the task in [govuk-saas-config] to update [Sentry]
  * Add the application to the [Release] app (the create button is at the bottom)
  * Add the application to the [Deploy_App job][deploy-jenkins] in Jenkins (click Configure)
  * Run the [Deploy_App job][deploy-jenkins] using with `with_migrations` option to get started

## Configuring the app for Jenkins

Create a `Jenkinsfile` in your repo with the following content.

```
#!/usr/bin/env groovy

library("govuk")

node {
  govuk.buildProject()
}
```

You also need to add a Jenkins integration to the repo on GitHub:

1.  In GitHub, go to Settings -&gt; Integrations & Services
2.  Add Jenkins (GitHub plugin)
3.  Add the link to the CI GitHub webhook
4.  Make sure Active is ticked

Finally, add your app to the list of deployable applications in [govuk-puppet].
