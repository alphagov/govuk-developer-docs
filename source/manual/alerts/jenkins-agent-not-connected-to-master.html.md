---
owner_slack: "#govuk-2ndline-tech"
title: Jenkins agent not connected to master
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

If the Jenkins agent is not connect to the master you can have a look at the [Jenkins Nodes UI][jenkins-nodes] and see
if it's possible to diagnose and solve the problem from there.

[jenkins-nodes]: https://ci.integration.publishing.service.gov.uk/computer/

View the log for the relevant agent, for example by clicking on the hostname of the agent and then choosing Log from the menu on the left-hand side.

Logs can also be found on the agent machine under `/var/lib/jenkins/remoting/logs`.

## Agent process failing to start

If the agent process is repeatedly starting up and failing with messages like:

```
deleting obsolete workspace /var/lib/jenkins/workspace/ishing-e2e-tests_govuk-test-TBY2AGKJXBE42MNITWCQM63I6R6XJSSGHBHBPH6P4IOBGXQK5OMA
...
Unexpected termination of the channel
```

then try clearing out the workspace directory on the agent:

```
$ gds govuk connect ssh -e ci ci_agent:0
$ sudo rm -r /var/lib/jenkins/workspace/*
```

## Agent SSH host key changed

If the master is failing to SSH into the agent with a message like "Host key verification failed", then delete the relevant entry from the known hosts file on the master:

```
$ gds govuk connect ssh -e integration ci_master
$ sudo -u jenkins ssh ci-agent-<n>.blue.integration.govuk-internal.digital
```

where \<n\> is the number assigned to the node.
You should receive a message from ssh telling you what line to get rid of in known_hosts.
Then you can edit the known_hosts acccordingly.

```
$ sudo nano /var/lib/jenkins/.ssh/known_hosts
```

Then restart the master process.

This problem should only occur if the agent machine gets recreated, which will change its SSH host key.

## Restarting the master process

If there doesn't seem to be way to solve the problem it may be necessary to restart the master process:

```
$ gds govuk connect ssh -e integration ci_master
$ sudo service jenkins restart
```

Restarting the master process will temporarily suspend all CI jobs while the master reconnects to the agents, but it should not cause any jobs to fail.
