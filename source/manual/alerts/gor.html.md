---
owner_slack: "#govuk-2ndline"
title: Gor
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-12
review_in: 6 months
---

[Gor][gor-gh] is an open source tool we use to replay HTTP traffic from
production to staging to give us greater confidence that our deploys are ok.

Alerts for Gor might let you know that it's not running, in which case we have
to be much more cautious with our deploys.

The nightly data sync stops Gor while data is syncing, so that we don't get
lots of errors in staging while we're dropping databases.

Puppet will [remove these alerts while the data sync runs][govuk-gor-data-sync]
but you may see the alerts at the beginning of a data sync, before Puppet has
had time to remove them.

### Data sync process failed

In case the data sync process aborts, Gor might not be restarted in a proper
way.

If that's the case, make sure that the following file exists on the host:

```
/etc/govuk/env.d/FACTER_data_sync_in_progress
```

and that it is in a proper state (i.e. empty).

If not, restart the Gor processes with the following Fabric command:

```
fab $environment puppet_class:gor sdo:'rm /etc/govuk/env.d/FACTER_data_sync_in_progress' app.start:goreplay
```

This will remove the file and restart Gor from all hosts running it.

When Puppet runs again in those hosts, it re-creates the alerts and sees
them back in icinga.

[gor-gh]: https://github.com/buger/goreplay/
[govuk-gor-data-sync]: https://github.com/alphagov/govuk-puppet/blob/06dd008d09/modules/govuk_gor/manifests/init.pp#L50

## `gor running` critical errors in production

When a data sync job is in progress, you may see errors in production with the status of
`PROCS CRITICAL: 0 processes with command name 'gor'`. This is expected. You can check
the [progress of the job in Jenkins](https://deploy.publishing.service.gov.uk/job/Copy_Data_to_Staging).
