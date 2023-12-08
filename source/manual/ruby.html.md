---
owner_slack: "#govuk-developers"
title: Add a new Ruby version
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

The [Ruby language](https://www.ruby-lang.org/en/) is a core part of GOV.UK - most of our applications are written in it.

## Managing different versions of Ruby

Each app can use whatever version of Ruby it wants. For development purposes we manage this locally with
[rbenv](https://github.com/rbenv/rbenv), and when apps are deployed they are built with a container that uses the requested version.

## Setting up rbenv

We set up rbenv differently depending on what's going on:

- Interactive login shells: `/etc/profile.d/rbenv.sh` sets up rbenv
- Applications: `govuk_setenv` and a `.ruby-version` in the app directory set up rbenv

### Updating the Ruby version in apps

#### Automatically raising PRs

We use [bulk-changer][] to automatically raise pull requests in GOV.UK repositories to update Ruby applications. Please note, we manage the [Ruby version in gems](/manual/publishing-a-ruby-gem.html#ruby-version-compatibility) differently to applications.

For applications, you will usually need to change the ruby version in two places - in .ruby-version (which is used by rbenv), and in Dockerfile (which is used during deployment)

#### Manually raising a PR

You can also create your own branch, update the two files as above, and raise a PR.

#### Updating individual applications

For each application a PR is raised for (either manually or via bulk-changer), you should test the changes before merge, as follows:

1. Most apps will run a test suite through CI. You should check the output of this for any Ruby deprecation warnings. If there are any warnings, they should be fixed.
1. Next, you should deploy the updated branch of the app to Integration, and manually test its features to ensure that the new Ruby version hasn't broken the app.
1. It's worth [checking the logs][] for deprecation warnings at this point (and fixing them), in case there are warnings that weren't flagged by the test suite run.
1. Next, check our monitoring tools
    1. Grafana: Visit [Grafana Integration][], Select `General/App: request rates, errors, durations`, then choose your app from the apps dropdown.
    1. Sentry: Visit [Sentry Projects][], choose your app, then use the All Envs drop down to select Integration EKS
1. The PR should be safe to merge.

[bulk-changer]: https://github.com/alphagov/bulk-changer
[checking the logs]: /kubernetes/manage-app/get-app-info/#view-app-logs
[Grafana Integration]: https://grafana.eks.integration.govuk.digital/?orgId=1&search=open&q=app+request+rates
[Sentry Projects]: https://govuk.sentry.io/projects/
