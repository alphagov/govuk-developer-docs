---
owner_slack: "#govuk-2ndline"
title: reboot required by apt
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

This check indicates that some new packages have been installed but require
rebooting the machines to become active.

The check contains a list of hosts that require a reboot. Click into the warning
for the list.

Under normal circumstances most machines reboot automatically and the list
shows those that need to be [rebooted manually][reboot-machines], such as
database clusters. If the list does not correlate with this there may be a
[problem with the locking mechanism](#checking-locking-status)

## When on 2nd Line

This alert is a common occurrence in production and staging environments.
It's unlikely to occur in integration because the machines are powered on
each day.

Typically you can manage this alert with the following steps:

### In staging

It is acceptable for most, if not all, machines to be rebooted in staging during the
working day. However, data loss can occur so apply caution.

Work through the documentation on [rebooting machines][reboot-machines], following
the procedures particular to each machine.

### In production

In production environment, you are normally dealing with variety of hosts.
Some machines, like MongoDB and Elasticsearch, can be rebooted with caution.
Others, like MySQL and PostgreSQL, require out-of-hours reboots by Platform
Health.

Work through the guide on [rebooting machines][reboot-machines] to
safely reboot the machines that can be, and kindly ask Platform Health to
schedule out-of-hours reboots for the other machines.

## Checking locking status

[locksmith](https://github.com/coreos/locksmith) manages unattended
reboots to ensure that systems are available. It is possible that a problem
could occur where they can't reboot automatically.

```command-line
$ fab <environment> all locksmith.status
```

If a lock is in place, it will detail which machine holds the lock.

You can remove it with:

```command-line
$ fab <environment> -H <machine-name> locksmith.unlock:"<machine-name>"
```

Machines that are safe to reboot should then do so at the scheduled
time.

[reboot-machines]: /manual/rebooting-machines.html
