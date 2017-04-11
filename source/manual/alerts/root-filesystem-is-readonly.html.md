---
title: 'root filesystem is readonly'
parent: /manual.html
layout: manual_layout
section: Alerts
---

# root filesystem is readonly

When Ubuntu is unable to write to disk it switches the filesystem to be
read only. This could be caused by a cloud hosting provider having
problems with their Storage Area Network (SAN).

The machine will need to have a filesystem check forced on reboot. To do
this log into the vCloud Director instance for the environment, find the
affected machine and click on the 'console' image to bring up a web
based console. Click the 'reset' icon in the top bar and then click to
focus on the console. Press the 'f' key when prompted (or repeatedly if
there's no output) to force a filesystem check.

