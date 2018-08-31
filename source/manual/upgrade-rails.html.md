---
owner_slack: '#govuk-2ndline'
last_reviewed_on: 2018-07-31
review_in: 6 months
title: Upgrade Rails to a new version
section: Dependencies
layout: manual_layout
parent: "/manual.html"
---

When upgrading our apps between Rails major and minor versions, follow the [official Rails guides][guide].

## Rails configs

We are trying to standardise our Rails config files. The guidelines
for these are as follows:

- If `load_defaults` is used, it should be top of the config
- Config options should be alphabetised
- Group together options that relate to the same option
  - E.g. `config.assets.enabled` and `config.assets.prefix` should be grouped together
- Remove any default/unnecessary comments

## Gotchas for upgrading to Rails 5.1

### Schema dumper changes

The schema dumper has been refactored in Rails 5.1 so the first migration after upgrading
will generate a lot of differences in `db/schema.rb`.
Notably whitespace and `using :btree` index modifiers.
See [this commit](https://github.com/rails/rails/commit/df84e9867219e9311aef6f4efd5dd9ec675bee5c?short_path=1ed2907#diff-e0d63791fb8e00fc467e7c47b74fb6d6)
and also [this commit](https://github.com/rails/rails/commit/6d37cd918dba5b492194afbc1094a6503c88f379) for details of the changes.

As part of the upgrade, regenerating the schema with `rake db:migrate` and including the updated `db/schema.rb` file will mean
the next migration doesn't generate this noise.
