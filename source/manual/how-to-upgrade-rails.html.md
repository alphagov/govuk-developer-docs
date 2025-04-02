---
owner_slack: "#govuk-developers"
title: How to upgrade Rails
section: Dependencies
type: learn
layout: manual_layout
parent: "/manual.html"
---

[Official guidance][official Rails guidance] is available on how to upgrade
Rails apps. The process this describes should be followed when moving between
both minor and major versions. This GOV.UK guide provides a single list of
actions to take when upgrading Rails, as well as more detailed and
GOV.UK-specific guidance on each step, particularly changes to configuration
files.

[official Rails guidance]:
  https://guides.rubyonrails.org/upgrading_ruby_on_rails.html

## The upgrade process

In general, you'll want to carry out the following steps in _roughly_ this
order.

- Update the Rails version in the Gemfile.
- Fix any initial test errors.
- Update configuration using the Rails update task.
- Switch to the new version defaults.
- Update the Rails database schema.
- Check the app runs locally.

More detail on each of these steps is provided below.

### Update the Rails version in the Gemfile

In GOV.UK apps, [Dependabot][] will typically open a pull request with this
change. If not, update the version in the Gemfile and run the following command.

```sh
bundle install
```

[Dependabot]: /manual/manage-dependencies.html

### Fix any initial test errors

All being well, upgrading Rails shouldn't cause any tests to fail. However,
occasionally an app might, for instance:

- depend on another package which is incompatible with the new version of Rails;
  or
- still use [previously-deprecated now-unsupported Rails
  syntax][unresolved-deprecation].

Review the results of the test suite run via continuous integration and/or
locally, and if possible, address any failing tests. If a fix is not currently
possible, make a note (via a Trello card, for example) to come back to the
upgrade at a later date.

[unresolved-deprecation]:
  https://github.com/alphagov/publishing-api/commit/3ea313845fb5e8882eec966eee0a5185381e72f6

### Update configuration using the Rails update task

This will likely be the most complex part of the upgrade process. A lot of the
default Rails configuration is written into your app's codebase. With every
minor and major Rails upgrade, this is subject to change. You'll need to make
decisions about which of these changes to accept.

Guidance on specific configuration files and settings is provided in the
subsections that follow, including on specific version upgrades. However, the
decisions you make will need to take into account your own app's needs, use
cases, and context.

The exact process for this step might vary by app, developer, and team, but an
example process is provided below. The first step is the key entry point.

1. Run the following command to start the interactive update process.

    ```sh
    bundle exec rails app:update
    ```

1. Accept all the changes with `a`.
   > You can alternatively review each individual change via the interactive
   > update process if you're comfortable reviewing and making decisions on
   > diffs in the command line. It's a similar interface to `git add --patch`.

1. Run Rubocop to bring the code changes in line with our formatting/linting
   standards (and remove superficial changes from the diff).

    ```sh
    bundle exec rubocop --autocorrect
    ```

1. Review the diff and decide which changes to accept and commit.
   > The changes that get suggested by the update task will vary between apps.
   > They are based on a few settings, including which railties and engines are
   > enabled in `config/application.rb` and whether `config.api_only` is set to
   > `true`.

1. Document any new decisions you've had to make both in this guide (or an
   appropriate version-specific guide) and in the commit message, following the
   [GDS guidance on commit messages][].

    Even if your decision is to accept a default, it's useful to know whether
    you're just opting into a new default in the absence of a strong opinion, or
    if you think the new setting is important and should be retained in future
    upgrades. Documenting this will make decisions easier when performing future
    upgrades.

[GDS guidance on commit messages]:
  https://gds-way.digital.cabinet-office.gov.uk/standards/source-code/working-with-git.html#commit-messages

#### Guidance for all upgrades

The following guidance should be considered secondary to the [version-specific
guidance][] that follows.

- Accept changes to comments that come from Rails.
- `config/puma.rb` will often be set up to use [`GovukPuma`][govuk-puma] rather
  than Rails defaults. Ignore changes in this case.
- For changes to settings in `config/environment`, work out if we were using a
  previous Rails default.

    If we weren't using a previous Rails default, look for an explanation in the
    app's git history.

    If we were using a previous Rails default, consult the following to inform
    your decision on whether to move to the new default:
    - [GOV.UK Helm Charts][] - does the config change affect an environment
    variable that we've set for the app?
    - The app’s git history
    - [Rails version-specific guidance][official Rails guidance]
    - [Rails source code][] and git history related to the change
    - [Rails change log][] for the given release
    - [Rails configuration documentation][]

- For changes in `public/*`, in general you can leave out HTML and image files
  (and consider removing any existing ones). We serve our own error pages and
  don't use Rails default app icons.
- It's useful to commit the `config/initializers/new_framework_defaults_*.rb`
  file. These are new settings that will be used when you [update the version
  defaults setting][]. With this file committed, if there are any issues after
  switching to the new defaults, you can try reverting to an earlier version's
  defaults and turning on these settings one by one.

If you're still unsure about a change:

- document your uncertainty in the commit message;
- flag the change when opening a pull request;
- ask your team or other Ruby colleagues for help.

[govuk-puma]:
  https://github.com/alphagov/publishing-api/blob/9b38ea8df732273fb99244a9366f41096474e714/config/puma.rb
[GOV.UK Helm Charts]: https://github.com/alphagov/govuk-helm-charts
[Rails change log]: https://github.com/rails/rails/releases
[Rails configuration documentation]:
  https://guides.rubyonrails.org/configuring.html
[Rails source code]: https://github.com/rails/rails
[update the version defaults setting]: #switch-to-the-new-version-defaults
[version-specific guidance]: #guidance-for-upgrades-to-specific-versions

#### Guidance for upgrades to specific versions

Version-specific guidance is available, starting from Rails 8.0:

- [8.0][]

[8.0]: /manual/guidance-for-upgrades-to-rails-8-0

### Switch to the new version defaults

1. Update the version number provided to the `config.load_defaults` setting in
   `config/application.rb`.
1. Delete the `config/new_framework_defaults_*.rb` file.

### Update the Rails database schema

If the app has a Rails database schema, which should be located at
`db/schema.rb`, run the following command.

```sh
bundle exec rake db:schema:dump
```

### Check the app runs locally

It's worth running the app locally (with GOV.UK Docker where possible) and
confirming that it continues to behave as expected, especially if changes have
been made in the development environment configuration file.
