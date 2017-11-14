---
owner_slack: "#2ndline"
title: Switch an app off
layout: manual_layout
section: Packaging
parent: "/manual.html"
last_reviewed_on: 2017-06-08
review_in: 6 months
---

In the event of a security incident an app may need to be switched off until it
can be patched.

Stop Puppet from running on the relevant machines:

```
fab $environment node_type:frontend puppet.disable:"Reason for disabling Puppet"
```

Stop the app on the relevant machines:

```
fab $environment node_type:frontend app.stop:designprinciples
```
