---
owner_slack: "#2ndline"
title: Switch an app off
layout: manual_layout
section: Packaging
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/howto-switch-off-app.md"
last_reviewed_on: 2016-12-06
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.com/alphagov/govuk-legacy-opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/2nd-line/howto-switch-off-app.md)


In the event of a security incident an app may need to be switched off until it
can be patched.

Stop puppet from running on the relevant machines

```
fab $environment node_type:frontend puppet.disable
```

Stop the app on the relevant machines::

```
fab $environment node_type:frontend app.stop:designprinciples
```
