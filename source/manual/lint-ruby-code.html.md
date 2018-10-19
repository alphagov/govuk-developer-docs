---
owner_slack: "#govuk-developers"
title: Lint your Ruby code with govuk-lint
section: Patterns & Style Guides
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-19
review_in: 6 months
---

The [govuk-lint](https://github.com/alphagov/govuk-lint) gem uses Rubocop to enforce consistency with the GOV.UK style guide.

[Rubocop](https://github.com/bbatsov/rubocop) is an open-source gem that performs static analysis of Ruby code according to rules that can be granularly configured. Each validation, or rule, is called a "cop". Some of those cops come with the ability to auto-correct issues.

Using govuk-lint is not compulsory. However, it is highly recommended to enforce at least consistent use of whitespace and indentation.

## How to use govuk-lint

- Add `govuk-lint` to your Gemfile
- Run `govuk-lint-ruby` in your project root folder

## Existing projects

If you have an existing Ruby project that has a number of violations of the GOV.UK style guide, a way of addressing those issues is:

1. Run `govuk-lint-ruby --auto-correct` in your project root folder, check that you are happy with those changes and commit.
2. For the remainder of the violations, manually fix the issues before committing the code containing those fixes.

## Jenkins builds

The default Jenkins build script will detect if you are using `govuk-lint` and will run it automatically.
