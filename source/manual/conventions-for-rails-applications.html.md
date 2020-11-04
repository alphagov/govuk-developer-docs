---
owner_slack: "#govuk-developers"
title: Conventions for Rails applications
section: Applications
type: learn
layout: manual_layout
parent: "/manual.html"
---

The majority of GOV.UK applications are built using [Ruby on Rails][] and over
the years we have created a lot them. Along the way we've used a variety of
patterns and conventions. We aim for GOV.UK apps to be [consistent in their
implementation][consistent-govuk] with differences in domain logic. However,
it isn't practical to evolve all apps at the same pace so there can be
differences in approaches used.

This document serves as a guide to the _current_ conventions and preferences. It
is intended to serve as a guide for teams creating new applications and for
teams iterating older ones. If you are creating a new application do also
consult the guides on [setting up a new Rails application][new-rails-app] and
[how to name an application][name-an-app].

Non-Rails GOV.UK applications may still benefit from these conventions.
Consider applying them if they do not conflict with existing
conventions in an adopted framework.

[Ruby on Rails]: https://rubyonrails.org/
[consistent-govuk]: https://docs.google.com/document/d/1jEjPOFJ2s1cjQv9vHAbE-KF68LSletpnUVaG5lXlHy4/edit#heading=h.yod40rauhyhu
[new-rails-app]: /manual/setting-up-new-rails-app.html
[name-an-app]: /manual/naming.html

## Our approach

GOV.UK's use of Rails is intended to be consistent with the conventions of
the framework itself and we intend to embrace developments and deprecations
from the framework. Where GOV.UK apps differ from Rails conventions (such as
using the RSpec testing framework) these are intended to be consistent with
common industry practices.

## Tooling choices

### Use GOV.UK supporting Gems

GOV.UK have published a number of gems that help achieve common needs across
Ruby / Rails applications:

- [gds-api-adapters][] - provides common patterns to communicate between GOV.UK
  applications
- [gds-sso][] - integration with [signon][] for user and application
  authentication
- [govuk_app_config][] - provides common configuration for applications such as
  logging, error handling and metric reporting
- [govuk_message_queue_consumer][] - provides a consistent means to work with
  the the RabbitMQ queue that the [Publishing API][] broadcasts to
- [govuk_publishing_components][] - provides a framework for embedding common
  GOV.UK interface components and creating your own application specific ones
- [govuk_sidekiq][] - Provides common configuration for using sidekiq with
  GOV.UK infrastructure
- [govuk_schemas][] - Provides helper utilities for interfacing with
  [govuk-content-schemas][]
- [govuk_test][] - Provides configuration and dependencies for headless browser
  testing
- [plek][] - Utility tool to access determine base URLs for GOV.UK applications
  for the current environment
- [rubocop-govuk][] - Provides GOV.UK linting rules for Ruby, Rails, RSpec and
  Rake
- [scss-lint-govuk][] - Provides linting for SCSS files according to GDS
  conventions
- [slimmer][] - Provides consistent templating for apps that serve content on
  the www.gov.uk host

Using these helps maintain consistency across the programme and enables common
iterations to be pushed out. It is encouraged that gems are iterated or issues
filed ([example][issue-example]) when apps need to vary from conventions
introduced by these gems.

[gds-api-adapters]: https://github.com/alphagov/gds-api-adapters
[gds-sso]: https://github.com/alphagov/gds-sso
[signon]: https://github.com/alphagov/signon
[govuk_app_config]: https://github.com/alphagov/govuk_app_config
[govuk_message_queue_consumer]: https://github.com/alphagov/govuk_message_queue_consumer
[Publishing API]: https://github.com/alphagov/publishing-api
[govuk_publishing_components]: https://github.com/alphagov/govuk_publishing_components
[govuk_sidekiq]: https://github.com/alphagov/govuk_sidekiq
[govuk_schemas]: https://github.com/alphagov/govuk_schemas
[govuk-content-schemas]: https://github.com/alphagov/govuk-content-schemas
[govuk_test]: https://github.com/alphagov/govuk_test
[plek]: https://github.com/alphagov/plek
[rubocop-govuk]: https://github.com/alphagov/rubocop-govuk
[scss-lint-govuk]: https://github.com/alphagov/scss-lint-govuk
[slimmer]: https://github.com/alphagov/slimmer
[issue-example]: https://github.com/alphagov/govuk_app_config/issues/121

### Gemfile organisation

Aim for your Gemfile to feel consistent, logical and concise. It is easy for
these files to become confusing with arbitrary orderings and a sporadic
approach to versioning ([example][confusing-gemfile]). However, this can
be avoided by following simple conventions.

The first gem in your Gemfile should be `"rails"` as the root dependency of
the application. This should have the version of Rails specified as an absolute
version number (for example `"6.0.3.4"` rather than relative `"~> 6.0"`) which
stops any other gems being able to alter the version of Rails used.

You should then declare the other gems your application needs to run in
all environments, which should be followed by
[groups](https://bundler.io/v1.5/groups.html) to specify gem dependencies
for particular environments (typically development and test).

You should avoid specifying the version of a gem (known as pinning) unless
you have a specific need to do so. Pinning a version is rarely necessary
as the Gemfile.lock file already stores the particular version used
and typically we intend to keep applications compatible with a current
version of a gem. Avoiding this makes future maintainers of your Gemfile not
need to consider whether a versioning choice was arbitrary or specific - it
also makes for a file that is easier to read - [example][email-alert-api-gemfile].

Should you have a need to specify a particular version of the gem (for example,
to indicate lack of compatibility with a newer release) leave a comment to
explain the particular version. This documents why we need to care
about the gem version. For example:

```
gem "elasticsearch", "~> 6" # We need a 6.x release to interface with Elasticsearch 6
```

[confusing-gemfile]: https://github.com/alphagov/publisher/blob/c8ccf5458c0497ebdf3776085316fc6750172cb8/Gemfile#L3-L23
[email-alert-api-gemfile]: https://github.com/alphagov/email-alert-api/blob/6409c1d57771c18b7b0a917f4634594ca6e7b52d/Gemfile

### Data storage

For non-specialist database needs you should use
[PostgreSQL](https://www.postgresql.org/) with [ActiveRecord][]. The
[db/seeds.rb][] can be used to populate the database for development and test
environments.

For [key-value datastore][] access (such as queues or distributed caches)
[Redis][] should be used. Typically a Redis datastore will not be shared
between applications, for queue-based communication between applications we
have precedent for using [RabbitMQ][] via the [Bunny][] gem.

For file storage local to an application [Amazon S3][] is the preferred choice,
where this needs to be associated with a database [ActiveStorage][] should be
used.

[ActiveRecord]: https://guides.rubyonrails.org/active_record_basics.html
[db/seeds.rb]: https://github.com/alphagov/content-publisher/blob/master/db/seeds.rb
[key-value datastore]: https://en.wikipedia.org/wiki/Key-value_database
[Redis]: https://redis.io/
[RabbitMQ]: https://www.rabbitmq.com/
[Bunny]: https://github.com/ruby-amqp/bunny
[Amazon S3]: https://aws.amazon.com/s3/
[ActiveStorage]: https://guides.rubyonrails.org/active_storage_overview.html

### Background job processing

The preferred approach for background job processing is to use [ActiveJob][]
with [Sidekiq][] with the [govuk_sidekiq][] gem providing configuration.
ActiveJob is preferred due to it's closer integration of Rails components
(such as [ActionMailer][]).

Scheduled background jobs for applications should also make use of Sidekiq,
where [sidekiq-scheduler][] is the conventional choice to achieve this.

[Sidekiq]: https://sidekiq.org
[ActiveJob]: https://guides.rubyonrails.org/active_job_basics.html
[ActionMailer]: https://guides.rubyonrails.org/action_mailer_basics.html
[sidekiq-scheduler]: https://github.com/moove-it/sidekiq-scheduler

### JavaScript package management

For Rails applications you should use the [Yarn](https://yarnpkg.com) package
manager for JavaScript packages. Yarn is preferable to using
[NPM](https://www.npmjs.com/) as Rails [integrates][yarn-integration] directly
with Yarn, providing default tasks and automating some workflows.

[yarn-integration]: https://guides.rubyonrails.org/5_1_release_notes.html#yarn-support

### Frontend assets

GOV.UK applications use the Rails [asset pipeline][] for building assets. We
aspire to migrate to [webpacker][] as the conventional approach when we have
resolved [blocking issues][].

[asset pipeline]: https://guides.rubyonrails.org/asset_pipeline.html
[webpacker]: https://github.com/rails/webpacker
[blocking issues]: https://github.com/alphagov/govuk_publishing_components/issues/505

### Sending emails

[GOV.UK Notify][] is the preferred approach for sending email. The
[mail-notify][] gem is conventionally used to integrate Notify with
[ActionMailer][]. There is [further documentation][govuk-notify-docs] on how
GOV.UK applications use Notify.

[GOV.UK Notify]: https://www.notifications.service.gov.uk/
[mail-notify]: https://github.com/dxw/mail-notify
[govuk-notify-docs]: /manual/govuk-notify.html

### Testing utilities

The preferred framework for testing Rails applications is [rspec-rails][] where
we aim to adhere to the project's conventions. [rubocop-govuk][] provides
a linting configuration for RSpec. For mocking and test doubles you should use
the provided [rspec-mocks][] framework.

When working with rspec-rails we prefer merging the [spec_helper.rb][] and
[rails_helper.rb][] files into a [single spec_helper.rb][] to avoid the
complexities of two configuration files. We also choose to specify
[`--require spec_helper`][rspec-file-example] in a [`.rspec` file][rspec-file]
to avoid prefixing every test with `require "spec_helper"`.

Common tools used with RSpec are:

- [webmock][] gem to stub HTTP requests - for stubbing communication between
  GOV.UK applications [gds-api-adapters][] provides a library of helper methods
  that are preferred to manual stubbing;
- [SimpleCov][] for monitoring code coverage;
- [factory_bot_rails][] for providing fixtures/test data;
- [Climate Control][] gem for modifying environment variables within tests;
- [`ActiveSupport::Testing::TimeHelpers`][time-helpers] for time manipulation.

The conventional testing framework for JavaScript files in GOV.UK Rails
applications is [Jasmine][]. This is dictated by Jasmine integrating
with the [asset-pipeline][] which rules out other common JavaScript testing
frameworks such as Jest or Karma. Jasmine should be [configured][jasmine-chrome]
to run tests with Chrome headless using [jasmine_selenium_runner][] - this
replaces the default runtime of PhantomJS (which is a project no longer
under development).

[rspec-rails]: https://relishapp.com/rspec/rspec-rails/docs
[rspec-mocks]: https://relishapp.com/rspec/rspec-mocks/docs
[spec_helper.rb]: https://github.com/rspec/rspec-core/blob/7b6b9c3f2e2878213f97d6fc9e9eb23c323cfe1c/lib/rspec/core/project_initializer/spec/spec_helper.rb
[rails_helper.rb]: https://github.com/rspec/rspec-rails/blob/a9e3f18c47cf83e0a40c3870f3bab5fe2f4e609a/lib/generators/rspec/install/templates/spec/rails_helper.rb
[single spec_helper.rb]: https://github.com/alphagov/content-publisher/blob/92eb7afe4344d32905b30204c94e033332342e6b/spec/spec_helper.rb
[rspec-file-example]: https://github.com/alphagov/content-publisher/blob/92eb7afe4344d32905b30204c94e033332342e6b/.rspec
[rspec-file]: https://github.com/rspec/rspec/wiki#rspec
[webmock]: https://github.com/bblimke/webmock
[webmock-localhost]: https://github.com/alphagov/content-publisher/blob/8c88972d461c8c25ae4e8c8b22c367eb28d6b79a/spec/spec_helper.rb#L18
[simplecov]: https://github.com/colszowka/simplecov
[factory_bot_rails]: https://github.com/thoughtbot/factory_bot_rails
[factory-bot-lint]: https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#linting-factories
[Climate Control]: https://github.com/thoughtbot/climate_control
[time-helpers]: https://api.rubyonrails.org/v6.0.2/classes/ActiveSupport/Testing/TimeHelpers.html
[jasmine]: https://github.com/jasmine/jasmine-gem
[jasmine_selenium_runner]: https://github.com/jasmine/jasmine_selenium_runner
[asset-pipeline]: #frontend-assets
[jasmine-chrome]: https://github.com/alphagov/service-manual-publisher/commit/adcc93f3c4aa92f6fa6ea590bbf9fef852991199

## Configuration

### Embrace 12 factor conventions

GOV.UK Rails applications aim to follow
[12 factor](https://12factor.net/) conventions. These should manifest in your
Rails application with practices such as:

- environmental configuration done by environment variables, for example using
  `ENV["DATABASE_URL"]` over hardcoding the production database configuration;
- close parity between development and production environments, for example using
  PostgreSQL in all environments - as opposed to SQLite for development and
  PostgreSQL for production;
- avoiding, where possible, the need for additional configuration on the
  serving machine, for example needing additional Nginx rules to serve requests.

### Inject secrets with environment variables

The conventional place to store secrets for a GOV.UK Rails application is
`config/secrets.yml`. All production secrets should be populated with an
environment variable; for dev and test environments it's preferred to leave
a usable dummy default if an actual secret isn't needed
([example][secrets-example]).

We haven't migrated to using the [encrypted `config/credentials.yml.enc`
introduced in Rails 5.2][rails-credentials]. This approach presents us
with a few problems, most notably that we run our apps in Rails
"production" environment in numerous places (integration, staging,
production) and need different secrets for them.

[secrets-example]: https://github.com/alphagov/content-publisher/blob/654d1885dd94e347e236be73d20f2304913bc906/config/secrets.yml
[rails-credentials]: https://edgeguides.rubyonrails.org/security.html#custom-credentials

### Specify London as the timezone

Configure your Rails application to consider the local timezone to be London
time, this can be done with `config.time_zone = "London"` in your
`config/application.rb`. This allows the presentation of dates to users, and
any time based logic, to automatically be in UK time.

Note, you shouldn't change the default configuration for the ActiveRecord
timezone (`config.active_record.default_timezone`). This should remain as UTC
which keeps the database un-opinionated on timezone.

### Use `api_only` mode for API projects

For applications that do not serve requests to a web browser you should
configure the Rails application to be [API only][], this simplifies Rails by
removing unnecessary functionality. If you need to add a web browser interface
to an API application you should consider creating a distinct frontend
application (for example: [email-alert-frontend][] and [email-alert-api][]).

[API only]: https://guides.rubyonrails.org/api_app.html
[email-alert-frontend]: https://github.com/alphagov/email-alert-frontend
[email-alert-api]: https://github.com/alphagov/email-alert-api

### Editing of microcopy by non-developers

When it is intended for non-developers to edit microcopy in an application it is
conventional to use [Rails Internationalization (I18n)][i18n] to abstract
the copy outside of the application code. We use this even when an application
is only in English. These files are stored in `/config/locales` as per Rails
convention. You should only use these files for accessing copy and not
for any application configuration.

[i18n]: https://guides.rubyonrails.org/i18n.html

### Error handling

GOV.UK Rails applications should anticipate failure and do so gracefully. This
[happens automatically, to a degree, on GOV.UK frontend
applications][frontend-errors] but not on admin applications where there is more
granular control over error responses. GOV.UK Rails applications should be
configured to provide GOV.UK branded error responses.
[Content Publisher][cp-errors]  provides an example of implementing this with
the [GOV.UK admin layout][].

[frontend-errors]: /manual/errors.html
[cp-errors]: https://github.com/alphagov/content-publisher/pull/1252
[GOV.UK admin layout]: https://components.publishing.service.gov.uk/component-guide/layout_for_admin

## Organising your code

Organising code in a Rails application is frequently a source of debate and
confusion, [particularly as to what code belongs in the `/app` directory and
what belongs in the `/lib` directory][app-lib]. We aim to follow what appears
to be the prevalent convention where:

- `/app` is used for:
  - the default Rails components (such as controllers, models, views, helpers, jobs)
  - commonly used classes in the application that have a common purpose and
    interface (good example: [interactors][], consistent interface and usage;
    bad example: [reporters][], just a one-off class)
- `/lib` is used for:
  - classes that don't logically fit into an app directory
  - complex business logic for the application, (for example, [link expansion][]
    in the Publishing API)
  - Rake tasks

GOV.UK Rails applications should avoid creating an `/app/lib` directory, as this
causes confusion with the prevalent `/lib` directory.

Configuration for applications, typically [YAML][] files, should live in the
`/config` directory.

[app-lib]: https://medium.com/extreme-programming/what-goes-in-rails-lib-92c74dfd955e
[interactors]: https://github.com/alphagov/content-publisher/tree/92eb7afe4344d32905b30204c94e033332342e6b/app/interactors
[reporters]: https://github.com/alphagov/specialist-publisher/blob/077123cc45c86e39d16be2ce2df239adef6ed2d3/app/reporters
[link expansion]: https://github.com/alphagov/publishing-api/blob/6595cd840e56aefd29964a2df5e86bd397869034/lib/link_expansion.rb
[YAML]: https://yaml.org/

## Documenting your decisions

It's conventional to create a `/docs` directory in GOV.UK Rails applications to
store application documentation (which is typically linked to from the readme).

For recording the reasoning behind architectural decisions it's conventional
to use [architectural decision records][adr] in the `/docs/adr` directory
([example][adr-example]).

[adr]: http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions
[adr-example]: https://github.com/alphagov/content-publisher/blob/master/docs/adr/0002-use-local-datastore.md

## Testing strategies

We aim for well tested Rails applications that provide a good degree of coverage
and provide assurances that an application is operating correctly. We value
test suites that are fast to run, easy to read and [test things consistently at
different abstractions (unit, integration and functional)][cp-testing-strategy].

[cp-testing-strategy]: https://github.com/alphagov/content-publisher/blob/f26d9b551842fdf2084159b5b7f1bb078da56936/docs/testing-strategy.md

### Feature/system testing

When testing Rails applications from the perspective of an end user it is
conventional to use RSpec Rails' [feature specs][] (new applications should
use the more modern equivalent: [system specs][]) via [govuk_test][]'s
[Capybara](https://teamcapybara.github.io/capybara/) configuration.

GOV.UK have adopted the [Future Learn readable feature test][future-learn]
approach to writing feature tests in RSpec. This offers a similar level of
readability of a [cucumber][] test, without the difficulties in identifying
the code used to perform the test.

[feature specs]: https://relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec
[system specs]: https://relishapp.com/rspec/rspec-rails/docs/system-specs/system-spec
[future-learn]: https://www.futurelearn.com/info/blog/how-we-write-readable-feature-tests-with-rspec
[cucumber]: https://cucumber.io/

### Testing controllers

Use [request specs][] for testing controllers, this is the [recommended
approach][rspec-request-moj] to replace [controller specs][] reflecting a
[direction introduced in Rails 5][controller-rails-5].

[request specs]: https://relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec
[rspec-request-moj]: https://medium.com/just-tech/rspec-controller-or-request-specs-d93ef563ef11
[controller specs]: https://relishapp.com/rspec/rspec-rails/docs/controller-specs
[controller-rails-5]: https://github.com/rails/rails/issues/18950
