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

Before you create a Rails app, you must complete all steps in the [GOV.UK developer get started documentation](get-started).

## Create a new Rails app

1. To create a Rails app, go to your development space on your local machine and run the following in the command line:

    ```sh
    rails new myapp --skip-javascript --skip-test --skip-bundle --skip-spring --skip-action-cable --skip-action-mailer --skip-active-storage
    ```

    The `--skip` commands excludes unneeded Rails plugins.

1. Replace the Gemfile with the gems you need. The following code shows an example.

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

    Open up `spec_helper.rb` and replace its contents with the following:

    ```rb
    ## spec/spec_helper.rb
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

1. If your app has a database, replace the content of `config/database.yml` with the following:

    ```yaml
    default: &default
      adapter: postgresql
      encoding: unicode
      pool: 12
      template: template0

    development:
      <<: *default
      database: <YOUR APP's NAME>_development
      url: <%= ENV["DATABASE_URL"]%>

    test:
      <<: *default
      database: <YOUR APP's NAME>_test
      url: <%= ENV["TEST_DATABASE_URL"] %>

    production:
      <<: *default
      database: <YOUR APP's NAME>_production
      url: <%= ENV["DATABASE_URL"]%>
    ```

1. Delete the `config/credentials.yml.env` and `config/master.key` files, and create `config/secrets.yml` with the following:

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

1. Configure linting for your Rails app to make sure the app's code is consistent with other GOV.UK apps. See the [GOV.UK developer documentation on configuring linting](linting) for more information.

### Set up Unicorn web server

1. Open your Gemfile and delete `gem "puma"` if needed.

1. Create a `Procfile` in your app's root directory with the following contents:

    ```
    web: bundle exec unicorn -c ./config/unicorn.rb -p ${PORT:-3000}
    ```

1. Create `config/unicorn.rb` with the following content:

    ```
    require "govuk_app_config/govuk_unicorn"
    GovukUnicorn.configure(self)
    ```

## Develop the Rails app

You should:

- develop your Rails app in line with the [GOV.UK developer documentation on conventions for Rails applications](rails-conv)
- name your Rails app in line with the [GOV.UK developer documentation on conventions for naming apps](naming)

## Set up GitHub repo

Set up a GitHub repo for your Rails app by following the [GOV.UK developer documentation on automatically configuring a GitHub repo](auto-config).

You must add a description to the __About__ section in the GitHub repo to make sure that you can add your app to the [GOV.UK developer documentation applications page](app-list). If you do not do this, you will see Middleman errors when the GOV.UK developer documentation is building. These errors will refer to attempts to modify a frozen empty string

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

## API documentation

## Licence

Link to the [MIT License](LICENCE).
```
See the example [account-api README.md](https://github.com/alphagov/account-api/blob/main/README.md) for more information.

## Prepare your app to run in production


### Configuring the app for Jenkins

Create a `Jenkinsfile` in your repo with the following content.

```
#!/usr/bin/env groovy

library("govuk")

node {
  govuk.buildProject()
}
```

You also need to add a Jenkins integration to the repo on GitHub:

___Follow the link to the github repo config docs___

___delete following 4 bullet list___

1. In GitHub, go to Settings -&gt; Integrations & Services
2. Add Jenkins (GitHub plugin)
3. Add the link to the CI GitHub webhook
4. Make sure Active is ticked

### Set up your app in govuk-puppet

Add your app to the list of deployable applications in [govuk-puppet].

### Configure your app's deployment

To configure your app's deployments, follow the docs in [govuk-app-deployment]

### Enable external DNS

If you need to.

To enable external DNS, follow the article in the [Developer Docs][dns]

### Add your app to the GOV.UK Developer Docs

* Make a PR to add your app to [data/applications.yml][docs-applications] for these docs

### Ask GOV.UK 2nd line to update Sentry

After app added to gov.uk developer docs, do this. Pre-req.

Then ask 2nd line to run the update-project task in [govuk-saas-config] to update [Sentry]

### Add app to Release app

Complete the form at that location and then select Create

Add the application to the [Release] app (the create button is at the bottom)

### Run deploy app job

Run the [Deploy_App job][deploy-jenkins] using with `with_migrations` option to get started

include the `with_migrations` option if your app has a DATABASE

### Add application to GOV.UK Docker

Add app to Docker so app can be run locally. Example PR - https://github.com/alphagov/govuk-docker/pull/465







* Add the application to the [Deploy_App job][deploy-jenkins] in Jenkins (click Configure) - to be moved by MSW to puppet docs___


*



.


___https://github.com/alphagov/govuk-saas-config is a little broken, it only lets you “update all” instead of targeting to a single repo - so when we went to update our sentry config it started changing other folks projects too! :scream: should be fixed from follow up PR here, but anyone still trying to run the update all like the docs say will encounter everyone else being out of sync!___


___Configure the GitHub repo as per https://docs.publishing.service.gov.uk/manual/configure-github-repo.html#auto-configuration page___
