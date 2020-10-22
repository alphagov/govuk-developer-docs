---
owner_slack: "#govuk-developers"
title: Configure linting
section: Applications
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-10-22
review_in: 12 months
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
```

After running `bundle install` you can test the linting by running
`bundle exec rubocop`.

## Linting JavaScript and SCSS

We use [StandardJS](https://standardjs.com/) for JavaScript linting and
[Stylelint](https://stylelint.io/) for SCSS linting, using the
[stylelint-config-gds][] configuration.

To enable these in a Rails application you will first need to
[install Yarn][yarn-install]. Then you should create a `package.json` file in
your project root. You can use the following template:

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

[stylelint-config-gds]: https://github.com/alphagov/stylelint-config-gds
[yarn-install]: https://classic.yarnpkg.com/en/docs/install/

## Configuring Rails

To configure this linting in Rails you should create a [rake][] task for this
in `lib/tasks/lint.rake`:

```rb
desc "Lint files"
task "lint" do
  sh "bundle exec rubocop"
  sh "yarn run lint" # lint JS and SCSS
end
```

You should then configure the default rake task for the application to include
linting. For example to run linting and RSpec as the default task add the
following code to your `Rakefile`:

```rb
# undo any existing default tasks added by depenencies so we have control
Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
task default: %i[lint spec]
````

You can confirm this works by running `bundle exec rake` and seeing your
linting run followed by specs.

[rake]: https://github.com/ruby/rake
