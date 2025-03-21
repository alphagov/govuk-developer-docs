---
owner_slack: "#govuk-developers"
title: Guidance for upgrades to Rails 8.0
section: Dependencies
type: learn
layout: manual_layout
parent: "/manual.html"
---

This guide is intended as a supplement to our [How to upgrade Rails][] guide,
providing version-specific guidance not covered there.

[How to upgrade Rails]: /manual/how-to-upgrade-rails

## `bin/dev`

In most apps, this file didn't exist before 8.0. In these cases, accept the new
addition. In apps that already had a custom `bin/dev` file, keep the custom
version. This file is conditionally used in `bin/setup`.

## `config/application.rb`

In most apps, there should be no changes here. In some apps, there will be
changes to which railties and engines are enabled. This list affects which
changes are suggested elsewhere, so pay close attention.

## `config/environment/development.rb`

- In general, we use Rails defaults for cache settings in this file. Accept
  changes if they've never been customised.
- Accept the change to enable query log tags. This seems useful and harmless.
- If the disallowed depecation warnings array is empty, accept the change to
  remove two related settings. This setting does not affect whether deprecation
  warnings are logged.

## `config/environment/production.rb`

- In general, we don't use Rails' public file server, so this should be/remain
  disabled and its headers setting commented out.
- SSL settings should be commented out. These settings have caused issues in the
  past due to SSL being terminated before requests reach apps. We're unsure if
  these issues remain, but SSL enforcement remains redundant.
- In most apps, logging settings are not customised. Accept changes in these
  cases, but ensure the log level doesn't change.
- Leave the silencing of the healthcheck path commented out. We have a custom
  healthcheck path, and don't use this feature.
- Accept the change to attributes used for inspection. This appears not to
  affect `inspect` when in a console.

## `config/environment/test.rb`

In most apps, you can accept all changes here.

## `config/initializers/filter_parameter_logging.rb`

In most apps, you can accept all changes here.
