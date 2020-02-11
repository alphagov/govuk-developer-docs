---
owner_slack: "#govuk-developers"
title: Add sidekiq-monitoring to your application
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-10
review_in: 6 months
---

[Sidekiq monitoring
applications](https://github.com/mperham/sidekiq/wiki/Monitoring) are
Sinatra applications that ship with the [Sidekiq
gem](http://sidekiq.org/). We have configured these to run as
[standalone](https://github.com/mperham/sidekiq/wiki/Monitoring#standalone)
apps on our backend machines.

## Prerequisites

- Identify a port you want to allocate to the sidekiq-monitoring
  instance for your application and reserve it in
  [development-vm/Procfile](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/Procfile).

## Adding configuration for your application in sidekiq-monitoring repository

- Add a line to the Procfile with the port you reserved earlier in the
  [sidekiq-monitoring
  repository](https://github.com/alphagov/sidekiq-monitoring)
  maintaining the alphabetical order of the processes.
- Update
  [index.html](https://github.com/alphagov/sidekiq-monitoring/blob/master/public/index.html#L26-L29)
  to include a link to your application's sidekiq-monitoring maintaining the
  alphabetical order of the applications. This path is configured as a location
  under the sidekiq-monitoring vhost.
- Run `bundle exec foreman start` and test that your Rack and Redis config work
  as expected.

## Configuring infrastructure

Add your application to the
[`govuk::apps::sidekiq_monitoring module`](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/apps/sidekiq_monitoring.pp)
in Puppet, cross-referencing the
[Redis configuration](https://github.com/alphagov/govuk-puppet/commit/9ffa90f571a43cba1e341c359111bf18db9cde1a).

## Configuring a path under the sidekiq-monitoring vhost

The sidekiq-monitoring vhost in nginx has one location for every
sidekiq-monitoring application. Add one for your application in
[this puppet template](https://github.com/alphagov/govuk-puppet/blob/70a10190b/modules/govuk/templates/sidekiq_monitoring_nginx_config.conf.erb#L21-L23).

## Test that the configuration works on Integration

Once changes are merged and deployed to Integration, you can
access your [sidekiq monitoring](monitor-sidekiq-workers.html) instance running
on Integration, and check that it works as expected.
