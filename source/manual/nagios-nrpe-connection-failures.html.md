---
owner_slack: "#2ndline"
title: Nagios NRPE connection failures
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-02-12
review_in: 6 months
---

Nagios uses a protocol called NRPE (Nagios Remote Plugin Executor) to perform
checks on remote machines. Monitored machines run an 'NRPE agent' which
listens for requests to execute monitoring checks.

Occasionally the nagios server is unable to connect to an NRPE agent on one of
the monitored machines. In this case you will see an alert with a message such
as 'connection to NRPE could not be established'.

In some cases this may be a false alarm due to load on the monitored machine.
In this case the NRPE errors usually disappear of their own accord when Nagios
tries the check again (within a minute or two). If the errors persist for
longer than a few minutes there may be a genuine issue and you should
investigate.

First verify that NRPE is running on the monitored machine:

```
$ ssh broken-machine-1.broken.integration
$ nc -v localhost 5666
Connection to localhost 5666 port [tcp/nrpe] succeeded!
```

If the connection succeeds then the NRPE agent is running on that machine.

A failure indicates that the agent is not running, and you should
investigate. Try running `govuk_puppet --test` on the machine, which should
restart the service. If it fails check the output for errors.

If the agent is running ok, next check that you can connect from the
monitoring server:

```
$ ssh ssh monitoring-1.management.environment
$ nc -v broken-machine-1.broken 5666
Connection to localhost 5666 port [tcp/nrpe] succeeded!
```

A failure indicates a networking issue between the monitoring server and the
monitored machine.

Note that the NRPE port is firewalled and only accessible from the
monitoring machine and the box itself.
