---
owner_slack: "#2ndline"
title: Puppet last run errors
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-05-18
review_in: 6 months
---

This alert triggers when there's an error while running Puppet on a machine.

To investigate, SSH into the machine and look at `syslog`:

```
tail /var/log/syslog
```

You can also try running Puppet again and check the output:

```
govuk_puppet --test
```
