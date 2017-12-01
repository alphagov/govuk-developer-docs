---
owner_slack: "#2ndline"
title: root filesystem is readonly
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-12-01
review_in: 1 month
---

When Ubuntu is unable to write to disk it switches the filesystem to be
read only. This could be caused by a cloud hosting provider having
problems with their Storage Area Network (SAN).

The machine will need to have a filesystem check forced on reboot. To do
this you will need access to the vCloud Director instance for the
environment, this access is typically only available to members
of the GOV.UK Infrastructure team. However, if you do on-call, you should have access
to the vCloud Production environment.

In the vCloud Director instance:

- Find the affected machine
- Click on the 'console' image to bring up a web based console
- Click the 'reset' icon in the top bar and then click to focus on the
  console
- Press the 'f' key when prompted (or repeatedly if there's no output)
  to force a filesystem check.
