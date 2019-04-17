---
owner_slack: "#govuk-2ndline"
title: Outstanding security updates
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-04-17
review_in: 1 months
---

Most security updates should be automagically applied overnight by
[unattended-upgrades](https://help.ubuntu.com/community/AutomaticSecurityUpdates#Using_the_.22unattended-upgrades.22_package)
and our Nagios check accounts for that by delaying alerts for up to
24hrs.

> *Please note:*
> At the moment, an issue with load balancer health checks in AWS prevents automatic reboots.
> RE are working on this. In the mean time, manual intervention is required. Please refer to [RE docs](https://docs.google.com/document/d/1QhB9QIpePAoaQTrK-6d0dSMN0pK0wMUH8_KtZ8tAns8/edit?usp=sharing)
> and contact #re-govuk on Slack if you require assistance.

To see which packages are outstanding you can use the following fabric task:

    fab $environment -H frontend-lb-1.frontend apt.security_updates

Before running an unattended upgrade manually it's worth checking why it
failed to run. Logs of the previous runs can be found in
`/var/log/unattended-upgrades`. The most recent run log can be found at
`unattended-upgrades.log`, whereas older logs can be found tarballed by
date in the same directory.

Perform an unattended upgrade manually with the `apt.unattended_upgrade`
Fabric task.

It has been known to alert about packages that were not currently
installed and thus not picked up by unattended-upgrades, such as
`libunwind7` and `dh-apparmor`. Such examples of new packages can be
taken care of by manually installing them with `apt-get install`.

We explicitly exclude or 'blacklist' some security updates from being
applied by unattended-upgrades. This currently includes MySQL Server,
which would represent a single point of failure if upgraded
automatically; in such cases a manual upgrade during office hours is
preferable.

Please see the `apt::unattended_upgrades::blacklist:` node in Hiera for
details of the exact packages that are blacklisted.

You should only consider running `apt-get dist-upgrade` as a last
resort, because it will aggressively upgrade, downgrade, and even
_remove_ packages as it deems necessary. Run it with `--dry-run` in
Integration first and review the output very carefully. If in doubt
about any of this output ask the Reliability Engineering team for
assistance.

You may see an alert telling you that a connection to NRPE could not be
established. See [Nagios NRPE connection
failures](alerts/nagios-nrpe-connection-failures.html) for more
information.

### 'Problem with MergeList' error

`apt-get` is known to fail occasionally on machines running Ubuntu
Trusty with an error similar to:

```
Exception: invalid literal for int() with base 10:
'E: Error: Opening the cache (E:Encountered a section with no Package: header,
E:Problem with MergeList /var/lib/apt/lists/mirrors.ubuntu.com_mirrors.txt_dists_trusty_restricted_i18n_Translation-en%5fU'
```

As a temporary work-around, run these commands on the machine to fix:

```bash
sudo rm -r /var/lib/apt/lists/*
sudo apt-get update
```
