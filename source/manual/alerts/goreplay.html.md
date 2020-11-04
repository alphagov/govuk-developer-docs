---
owner_slack: "#govuk-2ndline"
title: GoReplay
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

[GoReplay][goreplay-gh] (previously ["gor"][rename]) is an open source tool we use
to replay HTTP traffic from production to staging to give us greater confidence that
our deploys are ok.

Alerts for GoReplay might let you know that it's not running, in which case we have
to be much more cautious with our deploys.

Currently the [govuk_env_sync](/manual/govuk-env-sync.html) data sync jobs in AWS
take place between 23:00 and 5:30 and GoReplay is disabled during this time period
to prevent lots of errors while we are dropping databases.

Puppet will [remove these alerts while the data sync runs][govuk-goreplay-data-sync]
but you may see the alerts at the beginning of a data sync, before Puppet has
had time to remove them.

### Data sync process failed

In case the data sync process aborts, GoReplay might not be restarted in a proper
way.

If that's the case, make sure that the following file exists on the host:

```
/etc/govuk/env.d/FACTER_data_sync_in_progress
```

and that it is in a proper state (i.e. empty).

If not, restart the GoReplay processes with the following Fabric command:

```
fab $environment puppet_class:gor sdo:'rm /etc/govuk/env.d/FACTER_data_sync_in_progress' app.start:goreplay
```

This will remove the file and restart GoReplay from all hosts running it.

When Puppet runs again in those hosts, it re-creates the alerts and sees
them back in icinga.

[goreplay-gh]: https://github.com/buger/goreplay/
[govuk-goreplay-data-sync]: https://github.com/alphagov/govuk-puppet/blob/06dd008d09/modules/govuk_gor/manifests/init.pp#L50
[rename]: https://github.com/buger/goreplay/commit/74225ebb2236a46fd18a8fa4fa7de441497c13c4

## `gor running` critical errors in production

When a data sync job is in progress, you may see errors in production with the status of
`PROCS CRITICAL: 0 processes with command name 'gor'`. This is expected. You can check
the [progress of the job in Jenkins](https://deploy.publishing.service.gov.uk/job/Copy_Data_to_Staging).
