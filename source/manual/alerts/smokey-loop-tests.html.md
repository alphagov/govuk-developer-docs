---
owner_slack: "#govuk-2ndline"
title: Smokey loop tests
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-06-15
review_in: 6 months
---

[Smokey][smokey] runs in a continuous loop in each environment.
and dumps the output of each run into a `tmp/smokey.json` file.
We have [Icinga checks] for [most Smokey features], so that
we are alerted when some aspect of GOV.UK may be in trouble.

When a test fails, you should see a "Smokey loop for \<feature\>"
alert. The alert description should contain the reason for the
failure, so you can diagnose the problem.

> **NOTE**: we have [a separate "Smokey" alert] for manual runs
> of the Smokey job in Jenkins. This alert covers all Smokey
> features, while "Smokey loop" alerts are more granular.

## Nginx

If many of the tests are failing in an AWS environment, it may be because the Nginx services haven't registered new
boxes coming online or old ones going offline. You can try to restart the following services:

```bash
$ fab $environment class:cache app.reload:nginx
$ fab $environment class:draft_cache app.reload:nginx
$ fab $environment class:monitoring app.reload:nginx
$ fab $environment class:monitoring app.restart:smokey-loop
```

### `Traceback (most recent call last):` or `/tmp/smokey.json is older than 30m`

If you see this error in Icinga, it may mean that the `smokey-loop` process has died. You can try looking through the
logs or restarting the process.

```shell
$ ssh monitoring-1.production
> sudo less /var/log/upstart/smokey-loop.log
```

### `HTTP status code 550 (RestClient::RequestFailed)`

This usually means that the BrowserMob Proxy java process is running as part of a previously aborted
smokey-loop and the new smoke tests cannot start a new proxy. It's necessary to kill the existing
java process and restart smokey-loop.

Replace process numbers as appropriate:

```shell
$ gds govuk connect -e production ssh aws/monitoring
> sudo service smokey-loop stop
$ ps -ef | grep java
> smokey    6385  6380 26 14:58 ?        00:00:54 java -Dapp.name=browsermob-proxy -Dbasedir=/opt/smokey -jar /opt/smokey/lib/browsermob-dist-2.1.4.jar --port 3222
$ sudo kill -9 6385
$ sudo service smokey-loop start
```

## Smokey user

These tests rely on a user in [GOV.UK Signon][signon]. All Signon users have
their passphrase expire periodically. This will cause the tests to fail.

You should change the passphrase of the account and rotate it in encrypted
hieradata. Here's an [example PR in govuk-secrets](https://github.com/alphagov/govuk-secrets/pull/307).

Alternatively, you can fake a passphrase change in the Signon Rails console,
though this will only fix the alert temporarily.

```
$ govuk_app_console signon
irb(main):001:0> smokey = User.find_by(name: "Smokey (test user)")
irb(main):002:0> smokey.update_attribute(:password_changed_at, Time.now)
```

[signon]: https://github.com/alphagov/signon
[smokey]: https://github.com/alphagov/smokey
[most Smokey features]: https://github.com/alphagov/smokey/blob/master/docs/writing-tests.md#alerting-in-icinga
[Icinga checks]: https://github.com/alphagov/govuk-puppet/blob/master/modules/monitoring/manifests/checks/smokey.pp
[a separate "Smokey" alert]: https://github.com/alphagov/govuk-puppet/blob/master/modules/icinga/manifests/config/smokey.pp
