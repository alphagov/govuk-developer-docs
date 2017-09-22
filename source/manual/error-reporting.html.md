---
title: Error reporting with Sentry
parent: "/manual.html"
layout: manual_layout
section: Monitoring
owner_slack: "@tijmen"
last_reviewed_on: 2017-09-22
review_in: 2 weeks
---

When exceptions occur in production environments we need to be notified. We currently use [Errbit][] for this but are in the process of migrating to [Sentry][].

## What is Sentry?

Sentry is an open source error tracking tool. There's a company called [Sentry.io][] that provides the application as a SaaS product, which we're using.

## Configuring Sentry

We configure Sentry using [govuk_app_config][]. It reads from the docs and makes sure all the configuration is set up correctly.

[Errbit]: https://errbit.com/docs/master/
[Sentry]: https://sentry.io/govuk
[govuk_app_config]: https://github.com/alphagov/govuk_app_config
[Sentry.io]: https://sentry.io/about
