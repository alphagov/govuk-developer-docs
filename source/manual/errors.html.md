---
owner_slack: "#govuk-developers"
title: How we handle errors
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-05-18
review_in: 6 months
---

## How we categorise errors

Sometimes applications will encounter exceptions. This policy describes what we should do for different types of errors. It was first proposed in [RFC 87](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-087-dealing-with-errors.md).

### High priority errors

1. **When something goes wrong, we should be notified**. Applications should report exceptions to Sentry. Applications must not swallow errors.

1. **Notifications should be actionable**. Sentry notifications should be something that requires a developer of the app to do something about it. Not just a piece of information.

1. **Applications should not continue to have these errors**. The goal of GOV.UK is that applications should not error. When something goes wrong it should be fixed.

Example of high-priority errors:

- **Bugs**, where the application crashes unexpectedly

- **Sidekiq non-retryable errors** (or retries exhausted)

### Low priority errors

1. **When something goes wrong, the error should be recorded in Kibana logs and/or application metrics.** A team can then monitor these errors over time, and prioritise ones to fix.

Examples of low-priority errors:

- **Intermittent errors without user impact** e.g. user sees a cached version of a page, due to an upstream API timeout, such as a request to the Content Store.

- **Intermittent errors with user impact** e.g. an API request timeout occurs when a publisher tries to publish a document in one of our publishing apps.

  - When such errors are expected, we should show the user an error page that gives instructions for how to correct the issue, whether by taking action themselves, or submitting a request for support.

- **User input errors** e.g. user submits a form with invalid data.

  - For all 422 "unprocessable entity" errors, we should show the user an error page that gives instructions for how to correct the issue, whether by taking action themselves, or submitting a request for support.

  - For all 404 "not found" errors, we should show the user an error page that gives instructions for how to proceed. Note that 404 responses are returned by default if using [Rails' ActiveRecord #find or similar](https://stackoverflow.com/questions/27925282/activerecordrecordnotfound-raises-404-instead-of-500).

- **IP spoof errors (HTTP 400)**. Rails reports `ActionDispatch::RemoteIp::IpSpoofAttackError`.

- **Environmental errors** e.g. errors due to data sync.

