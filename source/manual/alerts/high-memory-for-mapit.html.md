---
owner_slack: "#govuk-2ndline"
title: High memory for mapit
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

Mapit has been recently having issues with its processes not restarting properly.
This is most commonly seen in integration but also happens in staging and production.

If you have a high memory alert for the mapit machines it may be that a number of
zombie processes are present, effectively doubling memory usage.

Performing a hard restart on this application will not help as half of the workers
are not under the control of the service manager.

To resolve this, SSH into each mapit machine in turn and do the following:
1. Check to see how many processes are running with `ps aux | grep gunicorn`. As
of time of writing there should be 8 worker processes and one "herder" process.
2. If there are more than 8, identify the oldest worker process either by the
PID or via the date/time that is returned by `ps`.
3. `sudo kill <pid>`.  This should cause all the zombie processes to quit.
4. Check the number of processes again and ensure the service manager is happy
with `sudo service mapit status`.

Hopefully the root cause will be investigated and resolved soon, if you're
reviewing this page please ask #platform-health whether it has been resolved.
