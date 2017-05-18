---
owner_slack: "#2ndline"
title: Restart an application
parent: "/manual.html"
layout: manual_layout
section: Deployment
last_reviewed_on: 2017-05-17
review_in: 6 months
---

To restart an application use this fabric script:

```
fab $environment class:frontend app.reload:manuals-frontend
```
