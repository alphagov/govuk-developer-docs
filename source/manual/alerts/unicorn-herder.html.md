---
owner_slack: "#govuk-2ndline-tech"
title: Unicorn Herder
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# Unicorn Herder

### 'app unicornherder running'

This alert means the Unicorn Herder process has disappeared for the
named app, so the app is still running but we don't know about it and
can't control it.

To fix this, manually kill off the unicorn workers for the app and
restart the herder process.

SSH into the affected machine and get the process ID of the unicorn
master:

```bash
ps aux | grep "unicorn master" | grep "<app name>" | awk '{ print $2 }'
```

If there is no `unicorn master` process for the app, then it has
crashed.

Kill the process:

```bash
sudo kill -9 <pid>
```

Then start the app again:

```bash
sudo service <app-name> start
```
