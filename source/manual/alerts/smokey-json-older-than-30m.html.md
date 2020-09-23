---
owner_slack: "#govuk-2ndline"
title: smokey.json older than 30m
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-04-07
review_in: 6 months
---

## Try removing any stuck processes

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
