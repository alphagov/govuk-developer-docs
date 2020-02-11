---
owner_slack: "#govuk-2ndline"
title: smokey.json older than 30m
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-12
review_in: 6 months
---

There can be the rare case wherein Smokey has failed to correctly run. While the
causes can be various and ultimately unknown, the symptoms include a large number
of Unknown errors in Icinga on the `monitoring` box.

The easiest way to clear these issues is ensure all relevant Smokey tasks are
killed:

```shell
$ sudo killall chromedriver
$ sudo killall chrome
$ sudo killall java
```

Alternatively if `killall` doesn't work, attempt to kill the processes directly
either through use of `htop` or with the `kill` command:

```shell
# Repeat until all chromedriver processes that do not mention 'grep' are gone
# Then repeat for chrome and java

$ ps -ef | grep chromedriver # To find the process ID to kill
$ sudo kill -15 $processID # Use the first number from the top line of grep
```


With `ps -ef | grep smokey` you should only see a running series of Postgres
services. These are not actually Smokey tasks, but Docker tasks that are being
misreported in the process list and it is advised to leave them running.

After the above, restart the service with `sudo service smokey-loop start` and
you should see it clear up.

#### If the error is still hanging around

In the very rare occurrence that the smokey.json 30m error returns half an hour
after the above steps are followed, retry the steps and then run
`sudo govuk_puppet --test` after starting the service. This is ultimately a
solution with very little testing, as we only saw this happen once, but it worked
in that case and may work again.
