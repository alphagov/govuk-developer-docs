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


___need to use docker to run these commands?___

___where does unicorn as opposed to puma come in?___

___enable deployments to integration - continuous deployments?___

___Set up a deployment dashboard___

___Switch on the app in staging and production environments___




## Familiarise yourself with the conventions

We have documented [conventions for Rails
applications](/manual/conventions-for-rails-applications.html) and
[conventions for naming applications](/manual/naming.html) in GOV.UK.

## Bootstrapping a new application

To create a rails app, run the following (skip uncommon stuff).

```sh
rails new myapp --skip-javascript --skip-test --skip-bundle --skip-spring --skip-action-cable --skip-action-mailer --skip-active-storage
```

Replace the Gemfile with the gems you need. Here is an example.

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

Run `bundle && rails g rspec:install` and replace `spec/*helper.rb`.

```sh
rm spec/rails_helper.rb
```

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

In config, replace the content of `database.yml` with the following.

```yaml
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

```yaml
development:
  secret_key_base: secret

test:
  secret_key_base: secret

production:
  secret_key_base: <%= ENV['SECRET_KEY_BASE'] %>
```

In config, replace the content of `routes.rb` with the following healthcheck.

```rb
Rails.application.routes.draw do
  get "/healthcheck", to: GovukHealthcheck.rack_response
end
```

Now is a good time to run `bin/setup`. Lastly, to ensure your application has
beautiful consistent code, you should finish up by
[configuring linting](/manual/configure-linting.html) for it.

## Add a software licence

Add a LICENCE file to the project root to specify the software licence. Unless
your project has specific needs, you should use the [MIT License][mit-license].

<details markdown="block">

<summary>MIT License for GDS projects</summary>

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

</details>

## Replace the default README.md

We have a common structure that is used for GOV.UK apps. Fill in some basic
details to get started with your app and flesh it out further as your project
develops.

```markdown
# App Name

One paragraph description and purpose.

## Screenshots (if there's a client-facing aspect of it)

## Live examples (if available)

- [gov.uk/thing](https://www.gov.uk/thing)

## Nomenclature

- **Word**: definition of word, and how it's used in the code

## Technical documentation

Write a single paragraph including a general technical overview of the app.

### Dependencies

- [dependency]() - purpose

### Running the application

How to run the app

### Running the test suite

How to test the app

## Licence

[MIT License](LICENCE)
```

## Puppet, DNS, Sentry and beyond

* To prepare the servers for your app, follow the doc in [govuk-puppet]
* To configure app deployments, follow the docs in [govuk-app-deployment]
* To enable external DNS, follow the article in the [Developer Docs][dns]
* Make a PR to add your app to [data/applications.yml][docs-applications] for these docs
* Then ask 2nd line to run the task in [govuk-saas-config] to update [Sentry]
* Add the application to the [Release] app (the create button is at the bottom)
* Add the application to the [Deploy_App job][deploy-jenkins] in Jenkins (click Configure)
* Run the [Deploy_App job][deploy-jenkins] using with `with_migrations` option to get started

When adding your application to `data/application.yml` - ensure your new repository has
a description set in the "About" section on github. This will be used to describe what your app
is on the [application listings](https://docs.publishing.service.gov.uk/#applications) and is also
required to render an application page.

If you do not do this, you may see Middleman errors when the docs are building which reference
attempts to modify a frozen empty string.


___https://github.com/alphagov/govuk-saas-config is a little broken, it only lets you “update all” instead of targeting to a single repo - so when we went to update our sentry config it started changing other folks projects too! :scream: should be fixed from follow up PR here, but anyone still trying to run the update all like the docs say will encounter everyone else being out of sync!___


___Configure the GitHub repo as per https://docs.publishing.service.gov.uk/manual/configure-github-repo.html#auto-configuration page___


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

1. In GitHub, go to Settings -&gt; Integrations & Services
2. Add Jenkins (GitHub plugin)
3. Add the link to the CI GitHub webhook
4. Make sure Active is ticked

Finally, add your app to the list of deployable applications in [govuk-puppet].

___Run the deploy_app job comes after this___
