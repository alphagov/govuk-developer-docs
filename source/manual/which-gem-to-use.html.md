---
owner_slack: "#govuk-developers"
title: Which gem to use
section: Patterns & Style Guides
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-10
review_in: 6 months
---

## Testing a Ruby project

- Projects should use [RSpec](https://github.com/rspec/rspec)
- Projects must use [govuk_test](https://github.com/alphagov/govuk_test) for
  test dependencies

Some projects use MiniTest. If you're in the position, you should convert these
tests into RSpec tests, but never mix RSpec and MiniTest in projects.

## Linting Ruby code

- Projects must use [govuk-lint](https://github.com/alphagov/govuk-lint).

See [Lint your Ruby code with govuk-lint](/manual/lint-ruby-code.html) for more
instructions.

## Background processing

- Projects must use [govuk_sidekiq](https://github.com/alphagov/govuk_sidekiq)

## Using RabbitMQ

- Projects must use [govuk_message_queue_consumer](https://github.com/alphagov/govuk_message_queue_consumer)
