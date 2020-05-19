---
owner_slack: "#govuk-developers"
title: Triage and handle errors
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-05-18
review_in: 6 months
---

Sometimes applications will encounter exceptions. This policy describes what we should do for different types of errors. It was first proposed in [RFC 87](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-087-dealing-with-errors.md).

## Principles

### 1. When something goes wrong, we should be notified

Applications should report exceptions to Sentry. Applications must not swallow errors.

### 2. Notifications should be actionable

Sentry notifications should be something that requires a developer of the app to do something about it. Not just a piece of information.

### 3. Applications should not error

The goal of GOV.UK is that applications should not error. When something goes wrong it should be fixed.

## Classifying errors

### Bug

A code change makes the application crash.

Desired behaviour: error is sent to Sentry, developers are notified and fix the error. Developers mark the error in Sentry as `Resolved`. This means a recurrence of the error will alert developers again.

### Intermittent errors without user impact

Frontend applications often see timeouts when talking to the content-store.

There's no or little user impact because the request will be answered by the caching layer.

Example: <https://sentry.io/govuk/app-finder-frontend/issues/352985400>

Desired behaviour: error is not sent to Sentry. Instead, we rely on Smokey and Icinga checks to make sure we the site functions.

### Intermittent errors with user impact

Publishing applications sometimes see timeouts when talking to publishing-api. This results in the publisher seeing an error page and possibly losing data.

Example: <https://sentry.io/govuk/app-content-tagger/issues/367277928>

Desired behaviour: apps handle these errors better, for example by offloading the work to a Sidekiq worker. Since these errors aren't actionable, they should not be reported to Sentry. They should be tracked in Graphite.

### Intermittent retryable errors

Sidekiq worker sends something to the publishing-api, which times out. Sidekiq retries, the next time it works.

Desired behaviour: errors are not reported to Sentry until retries are exhausted. See [this PR for an example](https://github.com/alphagov/content-data-api/pull/353).

Relevant: https://github.com/getsentry/raven-ruby/pull/784

### Expected environment-based errors

MySQL errors on staging while data sync happens.

Example: <https://sentry.io/govuk/app-whitehall/issues/343619055>

Desired behaviour: our environment is set up such that these errors do not occur.

### Bad request errors

User makes a request the application can't handle ([example][bad-request]).

Often happens in [security checks](https://sentry.io/govuk/app-frontend/issues/400074979).

Example: <https://sentry.io/govuk/app-frontend/issues/400074979>

Desired behaviour: user gets feedback, error is not reported to Sentry

[bad-request]: https://sentry.io/govuk/app-service-manual-frontend/issues/400074003

### Incorrect bubbling up of errors

Search API crashes on date parsing, returns `422`, which raises an error in finder-frontend.

Example: <https://sentry.io/govuk/app-finder-frontend/issues/400074507>

Desired behaviour: a 4XX reponse is returned to the browser, including an error message. Nothing is ever sent to Sentry.

### Manually logged errors

Something goes wrong and we need to let developers know.

Example: [Slimmer's old behaviour](https://github.com/alphagov/slimmer/pull/203/files#diff-e5615a250f587cf4e2147f6163616a1a)

Desired behaviour: developers do not use Sentry for logging. The app either raises the actual error (which causes the user to see the error) or logs the error to Kibana.

### IP spoof errors

Rails reports `ActionDispatch::RemoteIp::IpSpoofAttackError`.

Example: <https://sentry.io/govuk/app-service-manual-frontend/issues/365951370>

Desired behaviour: HTTP 400 is returned, error is not reported to Sentry.

### Database entry not found

Often a controller will do something like `Thing.find(params[:id])` and rely on Rails to show a 404 page for the `ActiveRecord::RecordNotFound` it raises ([context](https://stackoverflow.com/questions/27925282/activerecordrecordnotfound-raises-404-instead-of-500)).

Desired behaviour: errors are not reported to Sentry
