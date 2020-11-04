---
owner_slack: "#govuk-2ndline"
title: Outstanding security updates
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
important: true
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

If the unattended upgrades log looks okay, check which security updates are outstanding:

```bash
apt-get upgrade -s | grep -i security
```

You may find that the upgrades are on a [deny list in govuk-puppet](https://github.com/alphagov/govuk-puppet/commit/a0872cb1c9e6e7981863660b1500f3a2ede631fe)
(for example, `mysql-server-5.5` which [needs upgrading manually](/manual/upgrading-mysql.html)).
