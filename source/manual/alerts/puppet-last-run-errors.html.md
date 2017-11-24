---
owner_slack: "#2ndline"
title: Puppet last run errors
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-08-31
review_in: 6 months
---

This alert triggers when there's an error while running Puppet on a machine.

To view the errors in Kibana, first login to [Logit](/manual/logit.html), and then
run the following query (where `$hostname` is the hostname linked to the alert):

`syslog_program:'puppet-agent' AND host:$hostname`

You may also SSH into the machine and look at `syslog`:

```
tail /var/log/syslog
```

You can also try running Puppet again and check the output:

```
govuk_puppet --test
```

Sometimes this alert means that there is a puppet lock on the machine, so puppet won't be run. You can list current locks by running:

```
govuk_puppet -l
```

### Could not parse puppet summary file

This usually means the Puppet client is unable to retrieve the catalogue from the master.

The file that the check uses is `/var/lib/puppet/state/last_run_summary.yaml`. If it is only a few lines long, check logs for the error as above.
