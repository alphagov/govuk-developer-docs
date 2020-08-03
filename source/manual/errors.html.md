---
owner_slack: "#govuk-developers"
title: How we handle errors
section: Monitoring
layout: manual_layout
parent: "/manual.html"
---

## How we serve errors on GOV.UK

When a request to GOV.UK fails, we need to handle the error in some way, so that GOV.UK does not look completely broken. Rather than embedding this into every app, we have multiple layers of error handling.

> Note that publishing apps do not have these same layers of error handling; they are not behind a CDN. A publishing app is expected to handle all errors itself, according to the policy in the next section.

- **CDN**. There are a few scenarios here:
  - When the origin servers are offline, we:
    - [Skip normal request handling and begin error handling](https://varnish-cache.org/docs/trunk/users-guide/vcl-built-in-subs.html#vcl-backend-error)
    - Try to [serve the page from a sequence of static mirrors](https://github.com/alphagov/govuk-cdn-config/blob/d77313abdb5098e2b350de7a0992375e50ff03a3/vcl_templates/www.vcl.erb#L274)
    - Serve [a basic inline error page](https://github.com/alphagov/govuk-cdn-config/blob/d77313abdb5098e2b350de7a0992375e50ff03a3/vcl_templates/www.vcl.erb#L531) if [all the mirrors fail](https://github.com/alphagov/govuk-cdn-config/blob/d77313abdb5098e2b350de7a0992375e50ff03a3/vcl_templates/www.vcl.erb#L363) (uh oh!)
  - When the origin servers are online but return a 5xx response:
    - For [GET or HEAD requests](https://github.com/alphagov/govuk-cdn-config/blob/d77313abdb5098e2b350de7a0992375e50ff03a3/vcl_templates/www.vcl.erb#L339), we try the mirrors, or else serve an error (as above)
    - For [other requests](https://github.com/alphagov/govuk-cdn-config/blob/d77313abdb5098e2b350de7a0992375e50ff03a3/vcl_templates/www.vcl.erb#L367), we [serve the response as-is from the origin](https://github.com/alphagov/govuk-cdn-config/blob/d77313abdb5098e2b350de7a0992375e50ff03a3/vcl_templates/www.vcl.erb#L374) (see below)
  - When the origin servers return a 4xx response, we:
    - Serve the response as-is from the origin (no special handling)

- **Origin**. When a request fails in an upstream app, we:
  - [Intercept the response in Nginx](https://github.com/alphagov/govuk-puppet/blob/7dafec7cccd8308ec90c28835de70243d79b323b/modules/router/templates/router_include.conf.erb#L81)
  - Replace the response with [a pre-rendered one from Static](https://github.com/alphagov/govuk-puppet/blob/7dafec7cccd8308ec90c28835de70243d79b323b/modules/router/manifests/errorpage.pp#L14)

- **App**. When an app raises an exception:
  - If we have chosen to handle it, we:
    - [Catch it and return a more helpful error response page](https://github.com/alphagov/email-alert-frontend/blob/a2bd35b5b17b7da40cd43df9c2756b564597b66e/app/controllers/application_controller.rb#L10)\*
  - Otherwise, we:
    - Let Rails return a "500 Internal Server Error" (by default)

\* Due to the way errors are handled by the origin servers, it's not currently possible for a frontend app to render a contextual error page for an error response. One option to get around this is to deviate from normal web semantics, and [return a 200 response](https://github.com/alphagov/email-alert-frontend/blob/a2bd35b5b17b7da40cd43df9c2756b564597b66e/app/controllers/email_alert_signups_controller.rb#L10). This should be avoided because such responses are cacheable, indexable (by search engines), and surprising for anyone trying to look for errors in logs.

## How we handle errors in our apps

This policy describes what we should do for different types of errors. It applies to all apps, irrespective of other error handling by downstream servers. This policy was first proposed in [RFC 87](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-087-dealing-with-errors.md).

### High priority errors

1. **When something goes wrong, we should be notified**. Applications should [report exceptions to Sentry](/manual/error-reporting.html). Applications must not swallow errors.

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

