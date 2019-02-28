---
owner_slack: "#govuk-2ndline"
title: Root filesystem is readonly
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-02-10
review_in: 6 months
---

When Ubuntu is unable to write to disk, it switches the filesystem to be
read only. This could be caused by a cloud hosting provider having
problems with their Storage Area Network (SAN). It is possible for a machine
to operate in a degraded way with a read only file system so this check serves as an early warning if that happens.

The machine will need to have a filesystem check forced on reboot. To do
this, you will need access to the vCloud Director instance for the
environment. If you do on-call, you should have access to the vCloud Production environment.

In the vCloud Director instance:

- Find the affected machine
- Click on the 'console' image to bring up a web based console
- Click the 'reset' icon in the top bar and then click to focus on the
  console
- Press the 'f' key when prompted (or repeatedly if there's no output)
  to force a filesystem check.
