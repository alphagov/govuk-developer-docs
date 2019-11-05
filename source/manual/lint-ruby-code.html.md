---
owner_slack: "#govuk-developers"
title: Lint your Ruby code
section: Patterns & Style Guides
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-02
review_in: 6 months
---

To lint Ruby code we recommend using [Rubocop](https://github.com/bbatsov/rubocop).
It is an open-source gem that performs static analysis of Ruby code according to
rules that can be granularly configured. Each validation, or rule, is called a "cop".
Some of those cops come with the ability to auto-correct issues.

The [rubocop-govuk](https://github.com/alphagov/rubocop-govuk) gem is a set of Rubocop
style rules to enforce consistency with the GOV.UK style guide. See the readme for
details on installation and usage.

## Jenkins builds

The default Jenkins build script will detect if you are using `rubocop` and
will run it automatically.
