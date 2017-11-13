---
owner_slack: "#2ndline"
title: Gor
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-09-13
review_in: 6 months
---

[Gor][gor-gh] is an open source tool for replaying HTTP traffic. We use it to
replay traffic from production to staging to give us greater confidence that
our deploys are ok.

Alerts for Gor might let you know that it's not running, which means we have
to be much more cautious with deploys.

The nightly data sync stops Gor while data is syncing, so that we don't get
lots of errors in staging while we're dropping databases.

Puppet will [remove these alerts while the data sync runs][govuk-gor-data-sync]
but you may see the alerts at the beginning of a data sync, before Puppet has
had time to remove them.

### Data sync process failed

In case the data sync process aborts, gor might not be restarted in a proper
way. If that's the case, make sure that the following file exists on the host:

```
/etc/govuk/env.d/FACTER_data_sync_in_progress
```

And that it is in a proper state (i.e. empty). If not, you can restart the gor
processes with the following Fabric command:

```
fab $environment puppet_class:gor sdo:'rm /etc/govuk/env.d/FACTER_data_sync_in_progress' app.start:gor
```

This will remove the file and restart gor from all hosts running it.

When Puppet runs again in those hosts, it will re-create the alerts and we will be
able to see them back in icinga.

[gor-gh]: https://github.com/buger/gor/
[govuk-gor-data-sync]: https://github.com/alphagov/govuk-puppet/blob/06dd008d09/modules/govuk_gor/manifests/init.pp#L50

## `gor running` critical errors in production
When a data sync job is in progress, you may see errors in production with the status of `PROCS CRITICAL: 0 processes with command name 'gor'`, this is expected and you can check the [progress the job in jenkins](https://deploy.publishing.service.gov.uk/job/Copy_Data_to_Staging).
