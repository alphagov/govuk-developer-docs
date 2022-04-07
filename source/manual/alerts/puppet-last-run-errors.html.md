---
owner_slack: "#govuk-2ndline-tech"
title: Puppet last run errors
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert triggers when there's an error while running Puppet on a machine.

### View the logs

To view the errors in Kibana, first login to [Logit](/manual/logit.html), and then
run the following query (where `$hostname` is the short name of the machine
linked to the alert, for example `ip-10-1-2-3`):

`syslog_program:"puppet-agent" AND host:$hostname`

You may also SSH into the machine and look at `syslog`:

```
tail /var/log/syslog
```

### Re-run Puppet

You can also try running Puppet again and check the output:

```
govuk_puppet --test
```

If you see `Skipping because of failed dependencies` in the output, and the error `dpkg was interrupted`, then it is likely the [new instance failed to provision](/manual/new-instances-fail-to-provision.html).

### Check the puppet lock

Sometimes this alert means that there is a puppet lock on the machine, so puppet won't be run. You can list current locks by running:

```
govuk_puppet -l
```

### Could not parse puppet summary file

This usually means the Puppet client is unable to retrieve the catalogue from the master.

The file that the check uses is `/var/lib/puppet/state/last_run_summary.yaml`. If it is only a few lines long, check logs for the error as above.
