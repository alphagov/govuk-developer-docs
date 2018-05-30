---
owner_slack: "#govuk-2ndline"
title: Run high priority tests
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-05-30
review_in: 6 months
---

The high priority tests [come from Smokey][smokey] and [the Icinga check is defined in Puppet][icinga].

### Tests failing

If many of the tests are failing in an AWS environment, it may be because the Nginx services haven't registered new
boxes coming online or old ones going offline. You can try to restart the following services:

```bash
$ fab $environment class:cache app.reload:nginx
$ fab $environment class:draft_cache app.reload:nginx
$ fab $environment class:monitoring app.reload:nginx
$ fab $environment class:monitoring app.restart:smokey-loop
```

### `Traceback (most recent call last):`

If you see this error in Icinga, it may mean that the `smokey-loop` process has died. You can try looking through the
logs or restarting the process.

```shell
$ ssh monitoring-1.production
> sudo less /var/log/upstart/smokey-loop.log
```

```shell
$ ssh monitoring-1.production
> sudo service smokey-loop restart
```

[smokey]: https://github.com/alphagov/smokey
[icinga]: https://github.com/alphagov/govuk-puppet/blob/master/modules/monitoring/manifests/checks/smokey.pp
