---
owner_slack: "#govuk-developers"
title: Guidance for upgrades to Rails 8.1
section: Dependencies
type: learn
layout: manual_layout
parent: "/manual.html"
---

This guide is intended as a supplement to our [How to upgrade Rails][] guide,
providing version-specific guidance not covered there.

[How to upgrade Rails]: /manual/how-to-upgrade-rails

## `bin/ci` and `config/ci.rb`

These are in support of Rails' new 'local CI' concept. Adapting this approach is
likely to require some consideration around things like keeping this in sync
with GitHub Actions, so it's recommended to pursue this separately to upgrading
Rails (if at all).

## `config/environments/production.rb`

- Retain `config.assets.compile = false` if using Sprockets (via a gem).
