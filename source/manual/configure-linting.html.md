---
owner_slack: "#govuk-developers"
title: Configure linting
section: Applications
type: learn
layout: manual_layout
parent: "/manual.html"
---

This explains how to configure [linting][] for a GOV.UK application. It is
written with the expectation that you are configuring a
[conventional GOV.UK Rails application][rails] although the approaches
can be applied to non-Rails applications by minor adjustments to the steps.

[linting]: https://en.wikipedia.org/wiki/Lint_(software)
[rails]: /manual/conventions-for-rails-applications.html

## Linting Ruby

We use [rubocop-govuk](https://github.com/alphagov/rubocop-govuk) to lint Ruby
projects.

This is installed by adding `gem "rubocop"` to your Gemfile and then creating a
`.rubocop.yml` file in the root of your project:

```yaml
inherit_gem:
  rubocop-govuk:
    - config/default.yml
    - config/rails.yml
    - config/rake.yml
    - config/rspec.yml

inherit_mode:
  merge:
    - Exclude

# **************************************************************
# TRY NOT TO ADD OVERRIDES IN THIS FILE
#
# This repo is configured to follow the RuboCop GOV.UK styleguide.
# Any rules you override here will cause this repo to diverge from
# the way we write code in all other GOV.UK repos.
#
# See https://github.com/alphagov/rubocop-govuk/blob/main/CONTRIBUTING.md
# **************************************************************
```

After running `bundle install` you can test the linting by running
`bundle exec rubocop`.

## Linting JavaScript and SCSS

We follow the [GDS Way](https://gds-way.digital.cabinet-office.gov.uk/) guidance
on linting [Javascript][gds-way-js] and [CSS][gds-way-css].

To configure this for a Rails application you will need to install
[standardx][] and [stylelint-config-gds][]. To do this you will first need to
[install Yarn][yarn-install] and then you should create a `package.json` file
in your project root. You can use the following template:

```json
{
  "name": "My application",
  "description": "A brief description of the application's purpose",
  "private": true,
  "author": "Government Digital Service",
  "license": "MIT",
  "scripts": {
    "lint": "yarn run lint:js && yarn run lint:scss",
    "lint:js": "standard 'app/assets/javascripts/**/*.js' 'spec/javascripts/**/*.js'",
    "lint:scss": "stylelint app/assets/stylesheets/"
  },
  "standardx": {
    "env": {
      "browser": true
    }
  },
  "eslintConfig": {
    "rules": {
      "no-var": 0
    }
  },
  "stylelint": {
    "extends": "stylelint-config-gds/scss"
  }
}
```

The dependencies can then be installed:

```sh
yarn add --dev standard stylelint stylelint-config-gds
```

You can now test the linting by running `yarn run lint`.

To finish up you should add `node_modules` and `yarn-error.log` to
your `.gitignore` file.

[gds-way-js]: https://gds-way.digital.cabinet-office.gov.uk/manuals/programming-languages/js.html#linting
[gds-way-css]: https://gds-way.digital.cabinet-office.gov.uk/manuals/programming-languages/css.html#linting
[standardx]: https://github.com/standard/standardx
[stylelint-config-gds]: https://github.com/alphagov/stylelint-config-gds
[yarn-install]: https://classic.yarnpkg.com/en/docs/install/

## Configuring Rails

To configure this linting in Rails you should create a [rake][] task for this
in `lib/tasks/lint.rake`:

```rb
desc "Run all linters"
task lint: :environment do
  sh "bundle exec rubocop"
  sh "yarn run lint" # lint JS and SCSS
end
```

You should then configure the default rake task for the application to include
linting. For example to run linting and RSpec as the default task add the
following code to your `Rakefile`:

```rb
# Undo any existing default tasks added by depenencies so we can redefine the task
Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
task default: %i[lint spec]
````

You can confirm this works by running `bundle exec rake` and seeing your
linting run followed by specs.

[rake]: https://github.com/ruby/rake
