---
owner_slack: "#2ndline"
title: reboot required by apt
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-09-01
review_in: 6 months
---

This check indicates that some packages have been installed but cannot
be activated without rebooting the machines.

The check contains a list of hosts that require a reboot (click into the warning
for the list).

Under normal circumstances most machines will reboot automatically and the list
will be populated with those that need to be
[rebooted manually][reboot-machines], such as database clusters. If the list
does not correlate with this there may be a
[problem with the locking mechanism](#checking-locking-status)

## When on 2nd Line

It's common to see this alert when on GOV.UK 2nd line support in the production
and staging environment (it's unlikely to see it in integration as the machines
are powered on each day). Typically you can manage it with the following steps:

### In staging

Most, if not all, machines are acceptable to be rebooted in staging during the
working day - however there may be some data loss so caution should be applied.

You should work through the documentation on
[rebooting machines][reboot-machines] following the particular procedures for
each machine.

### In production

In the production environment you are normally dealing with a selection of
hosts where some can be rebooted with caution (such as MongoDB
and Elasticsearch machines) and others (such as MySQL and PostgreSQL machines)
require out-of-hours reboots by infrastructure.

You should work through the guide on [rebooting machines][reboot-machines] to
reboot the ones that are safe to do so and then communicate with the
infrastructure team to arrange for them to reboot the others.

## Checking locking status

Reboots for machines are managed by a tool,
[locksmith](https://github.com/coreos/locksmith), that manages unattended
reboots to ensure that systems are available. It is possible that a problem
could occur where they can't reboot automatically.

```command-line
$ fab <environment> all locksmith.status
```

If there is a lock in place it will detail which machine holds the lock.
You can remove it with:

```command-line
$ fab <environment> -H <machine-name> locksmith.unlock:"<machine-name>"
```

Machines which are safe to reboot should then do so at the scheduled
time.

[reboot-machines]: /manual/rebooting-machines.html
