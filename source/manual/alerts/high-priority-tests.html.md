---
owner_slack: "#govuk-2ndline"
title: Run high priority tests
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-04-17
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

If you see recent log entries like `HTTP status code 550 (RestClient::RequestFailed)` this usually means that
the BrowserMob Proxy java process is running as part of a previously aborted smokey-loop and the new smoke tests
cannot start a new proxy. It's necessary to kill the existing java process.

```shell
$ ps -ef | grep java
> smokey    6385  6380 26 14:58 ?        00:00:54 java -Dapp.name=browsermob-proxy -Dbasedir=/opt/smokey -jar /opt/smokey/lib/browsermob-dist-2.1.4.jar --port 3222
$ sudo kill -9 6385
```
(replacing process numbers as appropriate).

It's also useful to ensure no java proxy processes are left running when restarting smokey-loop.

```shell
$ ssh monitoring-1.production
> sudo service smokey-loop stop
$ ps -ef | grep java
> smokey    6385  6380 26 14:58 ?        00:00:54 java -Dapp.name=browsermob-proxy -Dbasedir=/opt/smokey -jar /opt/smokey/lib/browsermob-dist-2.1.4.jar --port 3222
$ sudo kill -9 6385
$ sudo service smokey-loop start
```

### Integration with Signon

These tests rely on a user in [GOV.UK Signon][signon]. All Signon users have their passphrase expire periodically. This will cause the tests to fail.

You can either change the passphrase of the account and rotate it in encrypted
hieradata, or you can fake a passphrase change in the Signon Rails console:

```
$ govuk_app_console signon
irb(main):001:0> smokey = User.find_by(name: "Smokey (test user)")
irb(main):002:0> smokey.update_attribute(:password_changed_at, Time.now)
```

[signon]: https://github.com/alphagov/signon
[smokey]: https://github.com/alphagov/smokey
[icinga]: https://github.com/alphagov/govuk-puppet/blob/master/modules/monitoring/manifests/checks/smokey.pp
