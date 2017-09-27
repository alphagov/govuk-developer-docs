---
title: Error reporting with Sentry
parent: "/manual.html"
layout: manual_layout
section: Monitoring
owner_slack: "#2ndline"
last_reviewed_on: 2017-09-27
review_in: 6 months
---

When exceptions occur in production environments we need to be notified. We use [Sentry][] for this. Sentry is an open source error tracking tool. There's a company called [Sentry.io][] that provides the application as a SaaS product, which we're using.

<https://sentry.io/govuk>

## Configuring Sentry

We configure Sentry using [govuk-sentry-config][]. It reads from the docs and makes sure all the configuration is set up correctly.

[Errbit]: https://errbit.com/docs/master/
[Sentry]: https://sentry.io/govuk
[govuk-sentry-config]: https://github.com/alphagov/govuk-sentry-config
[Sentry.io]: https://sentry.io/about
