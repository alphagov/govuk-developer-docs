---
title: 'reboot required by apt'
parent: /manual.html
layout: manual_layout
section: Alerts
---

# 'reboot required by apt'

This check indicates that some packages have been installed but cannot
be activated without rebooting the machines.

See the [rebooting machines](rebooting-machines.html) for what to do.

If there are a high number of machines requiring a reboot, including
ones that are not part of database clusters (such as Mongo and MySQL
machines) there may be a problem with the locking mechanism.

Check if this is the case using fabric:

    fab <environment> locksmith.status

If there is a lock in place it will detail which machine holds the lock.
You can remove it with:

    fab <environment> locksmith.unlock:"<machine-name>"

Machines which are safe to reboot should then do so at the scheduled
time.

