---
owner_slack: "#govuk-2ndline-tech"
title: GoReplay (Traffic replay)
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

[GoReplay][goreplay-gh] (previously ["gor"][rename]) is an open source tool we use
to replay HTTP traffic from production to staging to give us greater confidence that
our deploys are ok.

When users make [`GET`, `HEAD`, or `OPTIONS`][request-types] requests on production,
the request automatically gets played out on staging in real time. This '[shadowing][]'
technique acts as a load test, as well as presenting our applications with real user
queries we may not have tested for. Any errors should manifest themselves in Sentry or
as 5xx in Grafana. We check for these errors before deploying to production, as per
[our deploy process][deploy-process].

Read the blog post [Putting the Router through its paces][govuk-blog] for a history of
GoReplay on GOV.UK.

## GoReplay during the data sync

When the [data sync](/manual/govuk-env-sync.html) is in progress,
[GoReplay is temporarily disabled][goreplay-disabled] to prevent lots of errors
while we are dropping databases.

Puppet will [remove GoReplay alerts while the data sync runs][govuk-goreplay-data-sync],
but you may see the alerts at the beginning of a data sync, before Puppet has
had time to remove them.

If you see errors in production with the status of
`PROCS CRITICAL: 0 processes with command name 'gor'`, this is expected until the
data sync is complete.

## Data sync process failed

In case the data sync process aborts, GoReplay might not be restarted in a proper
way.

If that's the case, make sure that the following file exists on the host:

```
/etc/govuk/env.d/FACTER_data_sync_in_progress
```

and that it is in a proper state (i.e. empty).

If not, restart the GoReplay processes:

```sh
sudo rm /etc/govuk/env.d/FACTER_data_sync_in_progress
sudo service goreplay start
```

This will remove the file and restart GoReplay from all hosts running it.

When Puppet runs again in those hosts, it re-creates the alerts and sees
them back in icinga.

[deploy-process]: /manual/development-pipeline.html#manually-deploy-to-staging-then-production
[goreplay-disabled]: https://github.com/alphagov/govuk-puppet/blob/c7775111c98c9424644eb2d84cee8249d35d1d7b/modules/govuk_gor/manifests/init.pp#L48-L51
[goreplay-gh]: https://github.com/buger/goreplay/
[govuk-blog]: https://technology.blog.gov.uk/2013/12/13/putting-the-router-through-its-paces/#replay-production-traffic
[govuk-goreplay-data-sync]: https://github.com/alphagov/govuk-puppet/blob/06dd008d09/modules/govuk_gor/manifests/init.pp#L50-L58
[rename]: https://github.com/buger/goreplay/commit/74225ebb2236a46fd18a8fa4fa7de441497c13c4
[request-types]: https://github.com/alphagov/govuk-puppet/blob/master/modules/router/manifests/gor.pp#L55
[shadowing]: https://goreplay.org/shadowing.html
