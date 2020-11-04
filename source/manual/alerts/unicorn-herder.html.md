---
owner_slack: "#govuk-2ndline"
title: Unicorn Herder
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

### 'app unicornherder running'

This alert means the Unicorn Herder process has disappeared for the
named app, so the app is still running but we don't know about it and
can't control it.

At the moment, the fix is to run the [Fabric](/manual/tools.html#fabric-scripts)
task `vm.bodge_unicorn` for that app. (The name of the task should give a clue
as to why I say "At the moment".)

Configure and activate your fabric environment as described in the
[fabric-scripts README](https://github.com/alphagov/fabric-scripts/blob/master/README.md).

Then run the `vm.bodge_unicorn` task for the affected machine and application:

```bash
# Replace the machine_ip with the host IP of the machine that is showing the
# error in Icinga - e.g. ip-10-1-4-159.eu-west-1.compute.internal

# Replace the app_name with the relevant app  - e.g whitehall
fab $environment -H $machine_ip vm.bodge_unicorn:$app_name
```

Job done. The Nagios alert should clear within a few minutes.
