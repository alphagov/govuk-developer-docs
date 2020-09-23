---
owner_slack: "#govuk-2ndline"
title: Smokey loop tests
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
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

## Try kicking the Nginx machines

If many of the tests are failing in an AWS environment, it may be because the Nginx services haven't registered new
boxes coming online or old ones going offline. You can try to restart the following services using the [fabric scripts](https://github.com/alphagov/fabric-scripts):

```bash
$ fab $environment class:cache app.reload:nginx
$ fab $environment class:draft_cache app.reload:nginx
$ fab $environment class:monitoring app.reload:nginx
$ fab $environment class:monitoring app.restart:smokey-loop
```

## Try removing stuck processes

Sometimes the processes can get stuck e.g. waiting on a network connection, but this should be rare.

```shell
sudo service smokey-loop stop

sudo pkill -f -9 smoke
sudo pkill -f -9 chrome

sudo service smokey-loop start
```

After running the above commands, you should soon see the `/tmp/smokey.json` file has been modified.

## Try a manual run of the loop

The Smokey Loop is just [a repeat run of Cucumber](https://github.com/alphagov/smokey/blob/master/tests_json_output.sh#L27), which you can do yourself.

```shell
sudo su - smokey
cd /opt/smokey

govuk_setenv smokey bundle exec cucumber ENVIRONMENT=integration --profile integration
```

You should then see the Cucumber output, with all the tests passing.

> **Beware the proxy.** If you quit the process before it completes, then it won't clean up properly. You'll need to manually find it (`ps -ef | grep browserup`) and kill it.

## Check the Smokey credentials

These tests rely on a user in [GOV.UK Signon][signon]. All Signon users have
their passphrase expire periodically. This will cause the tests to fail.

You should change the passphrase of the account and rotate it in encrypted
hieradata. Here's an [example PR in govuk-secrets](https://github.com/alphagov/govuk-secrets/pull/307).

[signon]: https://github.com/alphagov/signon
[smokey]: https://github.com/alphagov/smokey
[most Smokey features]: https://github.com/alphagov/smokey/blob/master/docs/writing-tests.md#alerting-in-icinga
[Icinga checks]: https://github.com/alphagov/govuk-puppet/blob/master/modules/monitoring/manifests/checks/smokey.pp
[a separate "Smokey" alert]: https://github.com/alphagov/govuk-puppet/blob/master/modules/icinga/manifests/config/smokey.pp
