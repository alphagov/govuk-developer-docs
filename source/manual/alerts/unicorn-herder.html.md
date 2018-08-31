---
owner_slack: "#govuk-2ndline"
title: Unicorn Herder
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
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

Then run the `vm.bodge_unicorn` task for the affected machine and application,
e.g.

    fab $environment -H whitehall-backend-1.backend vm.bodge_unicorn:whitehall

Job done. The Nagios alert should clear within a few minutes.
