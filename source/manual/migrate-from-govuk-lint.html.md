---
owner_slack: "#govuk-developers"
title: Migrate from govuk-lint
section: Team tools
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-02
review_in: 6 months
---
This is a guide to help you migrate from [govuk-lint][govuk-lint],
which has been deprecated in favour of [rubocop-govuk][rubocop-govuk] and
[scss-lint-govuk][scss-lint-govuk].

## Ruby Projects

Previously, `govuk-lint` provided a set of RuboCop style rules and a
CLI wrapper for RuboCop called `govuk-lint-ruby`.

We now recommend using [RuboCop][rubocop] directly, instead of the CLI wrapper. The style rules
previously in `govuk-lint` have moved to `rubocop-govuk` and can be imported when using
RuboCop.

Changes you may have to make to your project include:

- Replace the `govuk-lint` gem with the `rubocop-govuk` gem in your Gemfile:

```diff
# Gemfile
- gem 'govuk-lint'
+ gem "rubocop-govuk"
```

- Add the following lines to your project's `.rubocop.yml` config file (you may need to create this):

```yaml
# .rubocop.yml
inherit_gem:
  rubocop-govuk:
    - config/default.yml
    - config/rails.yml # add this line for Rails projects

# If RuboCop finds any more Excludes: directives in rails.yml or in
# the app's `.rubocop.yml`, merge them with the original ones instead of
# overwriting.
inherit_mode:
  merge:
    - Exclude
```

- Replace usage of `govuk-lint-ruby` with `rubocop` in your project.
  All flags and options should be supported, except the `--diff` flag which should be
  removed.

## SASS Projects

Previously, `govuk-lint` provided a set of scss-lint style rules and a
CLI wrapper for scss-lint called `govuk-lint-scss`.

We now recommend using [scss-lint][scss-lint] directly, instead of the CLI wrapper. The style rules
previously in `govuk-lint` have moved to `scss-lint-govuk` and can be imported when using
`scss-lint`.

Changes you may have to make to your project include:

- Replace the `govuk-lint` gem with the `scss_lint-govuk` gem in your Gemfile:

```diff
# Gemfile
- gem 'govuk-lint'
+ gem "scss_lint-govuk"
```

- Add the following lines to your project's `.scss-lint.yml` config file (you may need to create this):

```yaml
# .scss-lint.yml
plugin_gems: ['scss_lint-govuk']
```

- Replace usage of `govuk-lint-scss` with `scss-lint` in your project.

[govuk-lint]: https://github.com/alphagov/govuk-lint
[rubocop]: https://github.com/bbatsov/rubocop
[rubocop-govuk]: https://github.com/alphagov/rubocop-govuk
[scss-lint]: https://github.com/sds/scss-lint
[scss-lint-govuk]: https://github.com/alphagov/scss-lint-govuk
