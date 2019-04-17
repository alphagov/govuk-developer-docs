---
owner_slack: "#govuk-2ndline"
title: Jenkins agent not connected to master
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-04-15
review_in: 6 months
---

If the Jenkins agent is not connect to the master you can have a look at the [Jenkins Nodes UI][jenkins-nodes] and see
if it's possible to diagnose and solve the problem from there.

[jenkins-nodes]: https://ci.integration.publishing.service.gov.uk/computer/

If there doesn't seem to be way to solve the problem it may be necessary to restart either the agent or master process:

```
$ ssh ci-agent-<n>.ci
$ sudo service jenkins-agent restart
```

```
$ ssh ci-master-1.ci
$ sudo service jenkins restart
```

Caution that restarting the master process will cause all CI jobs to be temporarily suspended and all agents will need
to reconnect.
