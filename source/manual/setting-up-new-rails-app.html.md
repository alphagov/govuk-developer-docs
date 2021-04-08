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
[dns]: https://docs.publishing.service.gov.uk/manual/dns.html#making-changes-to-publishing-service-gov-uk
[govuk-saas-config]: https://github.com/alphagov/govuk-saas-config
[govuk-app-deployment]: https://github.com/alphagov/govuk-app-deployment
[sentry]: https://sentry.io/settings/govuk/teams/
[release]: https://release.publishing.service.gov.uk/applications
[deploy-jenkins]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/
[docs-applications]: https://github.com/alphagov/govuk-developer-docs/blob/master/data/applications.yml
[get-started]: https://docs.publishing.service.gov.uk/manual/get-started.html
[linting]: https://docs.publishing.service.gov.uk/manual/configure-linting.html
[rails-conv]: https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html
[naming]: https://docs.publishing.service.gov.uk/manual/naming.html
[auto-config]: https://docs.publishing.service.gov.uk/manual/configure-github-repo.html#auto-configuration
[app-list]: https://docs.publishing.service.gov.uk/#applications

## Before you start

Before you create a Rails app, you must complete all steps in the [GOV.UK developer get started documentation][get-started].

## Create a new Rails app

1. To create a Rails app, go to the development space on your local machine and run the following in the command line:

    ```sh
    rails new myapp --skip-javascript --skip-test --skip-bundle --skip-spring --skip-action-cable --skip-action-mailer --skip-active-storage
    ```

    The `--skip` commands exclude unneeded Rails components.

1. Replace the Gemfile with the gems you need. The following code shows an example:

    ```rb
    source "https://rubygems.org"

    gem "rails", "6.0.3.4"

    gem "bootsnap",
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

1. Run `bundle && rails g rspec:install` to install all gems specified in the Gemfile and generate files used for testing.

1. Delete `spec/rails_helper.rb`:

    ```sh
    rm spec/rails_helper.rb
    ```

    Open `spec/spec_helper.rb` and replace its contents with the following:

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

    where `<APP-NAME>` is the name of the Rails app.

1. Delete the `config/credentials.yml.env` and `config/master.key` files, and create a `config/secrets.yml` file that contains the following code:

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
      get "/healthcheck", to: GovukHealthcheck.rack_response
    end
    ```

1. Configure linting for your Rails app to make sure the app's code is consistent with other GOV.UK apps. See the [GOV.UK developer documentation on configuring linting][linting] for more information.

### Set up Unicorn web server

1. If your Rails app's Gemfile includes `gem "puma"`, open the Gemfile and delete `gem "puma"`.

1. Create a `Procfile` in your app's root directory that contains the following code:

    ```
    web: bundle exec unicorn -c ./config/unicorn.rb -p ${PORT:-3000}
    ```

1. Create `config/unicorn.rb` that contains the following code:

    ```
    require "govuk_app_config/govuk_unicorn"
    GovukUnicorn.configure(self)
    ```

## Develop the Rails app

You should:

- develop your Rails app in line with the [GOV.UK developer documentation on conventions for Rails applications][rails-conv]
- name your Rails app in line with the [GOV.UK developer documentation on conventions for naming apps][naming]

## Set up a GitHub repo for the Rails app

Set up a GitHub repo for your Rails app by following the [GOV.UK developer documentation on automatically configuring a GitHub repo][auto-config].

You must add a description to the __About__ section in the GitHub repo to make sure that you can add your app to the [GOV.UK developer documentation applications page][app-list].

If you do not do this, you will see Middleman errors when the GOV.UK developer documentation is building. These errors will refer to attempts to modify a frozen empty string

## Add a software licence

Add a LICENCE file to the project root to specify the software licence. Unless your project has specific needs, you should use the [MIT License][mit-license].

```
The MIT License (MIT)

Copyright (c) <year> Crown Copyright (Government Digital Service)

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

## Replace the default README.md

Replace the default `README.md` file with the following content structure:

```markdown
# App Name

Information about the app's description and purpose.

## Technical documentation

Write a single paragraph including a general technical overview of the app.

### Testing

Information about how to test the app.

## Further documentation

More information on how the app works.

## API documentation

If applicable, include API reference information including the following sections:

- resources
- endpoints and methods
- parameters
- example requests and responses
- error codes

## Licence

Link to the [MIT License][LICENCE].
```

See the example [account-api README.md](https://github.com/alphagov/account-api/blob/main/README.md) for more information.

See the [GOV.UK Writing API reference documentation](https://www.gov.uk/guidance/writing-api-reference-documentation) for more information on API references.

## Prepare the Rails app to run in production

### Configure the Rails app for Jenkins

1. Create a `Jenkinsfile` in your repo with the following content.

    ```
    #!/usr/bin/env groovy

    library("govuk")

    node {
      govuk.buildProject()
    }
    ```

1. Add a Jenkins integration to the repo on GitHub. See the [GOV.UK developer documentation on automatically configuring a GitHub repo][auto-config] for more information.

### Set up the Rails app in govuk-puppet

Follow the [`govuk-puppet` documentation on adding a new app to GOV.UK][govuk-puppet].

### Configure the Rails app's deployment

To configure your app's deployment, see the [GOV.UK application deployment scripts documentation][govuk-app-deployment] for more information.

### Enable external DNS

If you need to enable external DNS, see the [GOV.UK developer documentation on making changes to publishing.service.gov.uk][dns] for more information.

### Add your app to the GOV.UK Developer Docs

Open a pull request to add the Rails app to the [GOV.UK developer documentation `data/applications.yml` file][docs-applications].

### Ask GOV.UK 2nd line to update Sentry

After you have added the Rails app to the GOV.UK developer documentation, [ask GOV.UK 2nd line support](mailto:2nd-line-support@digital.cabinet-office.gov.uk) to run the `update-project` task in [GOV.UK SaaS Config][govuk-saas-config] to update [Sentry][sentry].

### Add Rails app to Release app

Add the Rails app to the [Release] app (requires sign in) and select __Create__.

### Run the Deploy_App job

Run the [Deploy_App job][deploy-jenkins].

Use the `with_migrations` option if your Rails app has a database.

### Add Rails app to GOV.UK Docker

Add the Rails app to GOV.UK Docker so the Rails app can be run locally. See this [example GOV.UK Docker pull request](https://github.com/alphagov/govuk-docker/pull/465) for more information.
