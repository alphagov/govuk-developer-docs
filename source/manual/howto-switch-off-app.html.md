---
owner_slack: "#govuk-2ndline"
title: Switch an app off temporarily
layout: manual_layout
section: Deployment
parent: "/manual.html"
last_reviewed_on: 2018-07-03
review_in: 12 months
---

In the event of a security incident an app may need to be switched off until it
can be patched.

Stop Puppet from running on the relevant machines:

```
fab $environment node_type:frontend puppet.disable:"Reason for disabling Puppet"
```

Stop the app on the relevant machines:

```
fab $environment node_type:frontend app.stop:frontend
```
