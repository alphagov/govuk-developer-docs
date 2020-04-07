---
owner_slack: "#govuk-2ndline"
title: Troubleshoot CI Jenkins Performance
parent: "/manual.html"
layout: manual_layout
section: Testing
---

There are many reasons Jenkins could perform poorly, this document attempts to
outline some common approaches to diagnosing/monitoring and outlines steps to
resolve common issues.

A useful link is [/monitoring][monitoring] which shows a variety of diagnostic
information. This can be used to identify which aspects of Jenkins
performance/usage have changed over periods of time.

## There are resources Jenkins was not able to dispose automatically

This is an error that can be seen on the [/manage][manage] page in Jenkins and
indicates that the jenkins user does not have sufficient permissions to delete
items it is trying to. When lots of these build up the load can
increase enormously and make Jenkins near unusuable.

A common culprit in this problem is builds that make use of Docker. As Docker
runs as a root user any files Docker creates on volumes that are mounted have
a root owner. Jenkins then cannot delete these files as part of a workspace
cleanup.

To remove these manually you can log into each of the agent machines and
perform the following commands:

`sudo find /var/lib/jenkins/workspace/*ws-cleanup*/ -user root` will show a
list of files that will be deleted, you should scan these to check there is
nothing surprising.

Then `sudo find /var/lib/jenkins/workspace/*ws-cleanup*/ -user root -delete`
can be run to delete everything that was found.

You should then look to ensure that the build which is leaving these files is
not doing it in the course of a regular build. However even if a job does
clean up after itself some of these may still exist if a job is aborted
prematurely.

[monitoring]: https://ci.integration.publishing.service.gov.uk/monitoring
[manage]: https://ci.integration.publishing.service.gov.uk/manage
