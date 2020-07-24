---
owner_slack: "#govuk-2ndline"
title: Security updates
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
important: true
last_reviewed_on: 2020-07-24
review_in: 6 months
---

Machines are configured to [automatically install security updates](https://help.ubuntu.com/community/AutomaticSecurityUpdates#Using_the_.22unattended-upgrades.22_package) on a daily basis.

- This is triggered by the `/etc/cron.daily/apt` script.
- Relevant config can be found in `/etc/apt/apt.conf.d`.

This alert indicates automatic updates have stopped working. While this is not normally a critical issue, it becomes so if we start missing out on security patches. Some commands to start debugging with:

```bash
# check the output of the last automatic upgrade
less /var/log/unattended-upgrades/unattended-upgrades.log

# try running the upgrade manually
sudo unattended-upgrade -d --dry-run
```
