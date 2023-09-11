---
owner_slack: "#govuk-developers"
title: Set up a new Rails application
section: Applications
layout: manual_layout
parent: "/manual.html"
---

[mit-license]: https://en.wikipedia.org/wiki/MIT_License
[govuk-puppet]: https://github.com/alphagov/govuk-puppet/blob/master/docs/adding-a-new-app.md#including-the-app-on-machines
[govuk-puppet-jenkins]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml
[dns]: /manual/dns.html#dns-for-the-publishingservicegovuk-domain
[govuk-saas-config]: https://github.com/alphagov/govuk-saas-config
[govuk-app-deployment]: https://github.com/alphagov/govuk-app-deployment
[sentry]: https://sentry.io/settings/govuk/teams/
[release]: https://release.publishing.service.gov.uk/applications
[deploy-jenkins]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/
[docs-applications]: https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml
[get-started]: /manual/get-started.html
[linting]: /manual/configure-linting.html
[rails-conv]: /manual/conventions-for-rails-applications.html
[naming]: /manual/naming.html
[auto-config]: /manual/github.html
[app-list]: /#applications
[sentry-update-project-rake-task]: https://github.com/alphagov/govuk-saas-config/blob/045668beed8aebc50b876108363c8d1a25bdf80c/sentry/Rakefile#L69-L83

## Before you start

Before you create a Ruby on Rails (“Rails”) app, you must complete all steps in the [GOV.UK developer get started documentation][get-started].

You should:

- develop your Rails app in line with the [conventions for Rails applications][rails-conv]
- name your Rails app in line with the [conventions for naming apps][naming]

## Create a new Rails app

1. To create a Rails app on your local machine, run the following in the command line:

    ```sh
    rails new myapp --skip-javascript --skip-test --skip-bundle --skip-spring --skip-action-cable --skip-action-mailer --skip-active-storage
    ```

    The `--skip` commands exclude unneeded Rails components.

1. Include the gems you need for your app in `Gemfile`. For example:

    ```rb
    source "https://rubygems.org"

    gem "rails", "6.0.3.4"

    gem "bootsnap"
    gem "gds-api-adapters"
    gem "gds-sso"
    gem "govuk_app_config"
    gem "govuk_publishing_components"
    gem "pg"
    gem "plek"
    gem "uglifier"

    group :development do
      gem "listen"
    end

    group :test do
      gem "simplecov"
    end

    group :development, :test do
      gem "byebug"
      gem "govuk_test"
      gem "rspec-rails"
      gem "rubocop-govuk"
    end
    ```

1. Run `bundle && rails g rspec:install` to install all the gems you included in `Gemfile` and generate files you can use to test your app.

1. Run `rm spec/rails_helper.rb` to delete `spec/rails_helper.rb`.

1. Replace the contents of `spec/spec_helper.rb` with the following:

    ```rb
    ENV["RAILS_ENV"] ||= "test"

    require "simplecov"
    SimpleCov.start "rails"

    require File.expand_path("../../config/environment", __FILE__)
    require "rspec/rails"

    Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
    GovukTest.configure

    RSpec.configure do |config|
      config.expose_dsl_globally = false
      config.infer_spec_type_from_file_location!
      config.use_transactional_fixtures = true
    end
    ```

1. If your Rails app has a database, replace the content of `config/database.yml` with the following:

    ```yaml
    default: &default
      adapter: postgresql
      encoding: unicode
      pool: 12
      template: template0

    development:
      <<: *default
      database: <APP-NAME>_development
      url: <%= ENV["DATABASE_URL"]%>

    test:
      <<: *default
      database: <APP-NAME>_test
      url: <%= ENV["TEST_DATABASE_URL"] %>

    production:
      <<: *default
      database: <APP-NAME>_production
      url: <%= ENV["DATABASE_URL"]%>
    ```

    where `<APP-NAME>` is the name of your Rails app.

1. Delete the `config/credentials.yml.env` and `config/master.key` files, and create a `config/secrets.yml` file that contains the following:

    ```yaml
    development:
      secret_key_base: secret

    test:
      secret_key_base: secret

    production:
      secret_key_base: <%= ENV['SECRET_KEY_BASE'] %>
    ```

1. Replace the content of `config/routes.rb` with the following:

    ```rb
    Rails.application.routes.draw do
      get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
      get "/healthcheck/ready", to: GovukHealthcheck.rack_response
    end
    ```

1. Configure linting for your Rails app to make sure the app's code is consistent with other GOV.UK apps. Find out more information about [configuring linting][linting].

### Setting up a Puma web server

Puma is already included in the [govuk_app_config](https://github.com/alphagov/govuk_app_config) gem.

Create a `config/puma.rb` file that contains the following code:

  ```rb
  require "govuk_app_config/govuk_puma"
  GovukPuma.configure_rails(self)
  ```

### Add your Rails app to GOV.UK Docker

Add your Rails app to GOV.UK Docker so you can run the app locally. See an [example GOV.UK Docker pull request](https://github.com/alphagov/govuk-docker/pull/465).

### Set up contract tests for your app

If your app provides an internal API, it should have [contract tests](/manual/pact-testing.html).

## Set up a GitHub repo for your Rails app

When you’ve finished developing your Rails app, you can [set up a GitHub repo for your Rails app][auto-config].

You must add a description to the _About_ section in the GitHub repo, or the GOV.UK developer documentation build will break when it tries to build the [list of apps][app-list].

### Add a software licence

You must add a `LICENCE` file to your project’s root folder that specifies the software licence. You should usually use the following MIT License text. Replace <YEAR> with the current year.

```
The MIT License (MIT)

Copyright (c) <YEAR> Crown Copyright (Government Digital Service)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### Replace the default README.md

Change the default `README.md` file to match [the standard README template](/manual/readmes.html#template-for-new-readmes).

### Write API documentation

If your app is an API, you should create a `docs/api.md` file.

[Guidance on writing API reference documentation on GOV.UK](https://www.gov.uk/guidance/writing-api-reference-documentation).

## Prepare your Rails app to run in production

### Configure your Rails app for Jenkins

Find out how to [set up an app in Jenkins](/manual/test-and-build-a-project-on-jenkins-ci.html#setting-up).

### Add your Rails app to GOV.UK

Find out how to [add your Rails app to GOV.UK using `govuk-puppet`][govuk-puppet].

### Configure your Rails app's deployment

To configure your app's deployment, see the [GOV.UK application deployment scripts][govuk-app-deployment].

### Enable external DNS

If you need to enable external DNS, find out how to [make changes to publishing.service.gov.uk][dns].

### Add your app to the GOV.UK developer documentation

Open a pull request to add your Rails app to the [GOV.UK developer documentation `data/repos.yml` file][docs-applications].

### Create the application in Sentry

After you’ve added your Rails app to the GOV.UK developer documentation,
[add the project to Sentry](/manual/sentry.html#how-govuk-projects-are-added-to-sentry).

### Add your Rails app to Release app

Add your Rails app to the [Release][release] app and select __Create__.

### Run the Deploy_App job

Run the [Deploy_App job][deploy-jenkins].

Use the `with_migrations` option if your Rails app has a database.
