---
owner_slack: "#2ndline"
title: Restart an application
parent: "/manual.html"
layout: manual_layout
section: Deployment
last_reviewed_on: 2017-11-22
review_in: 6 months
---

To restart an application use the [fabric command](https://github.com/alphagov/fabric-scripts) `app.reload`.

For example, to restart the 'manuals-frontend' app on all frontend machines
in staging, do:

```
fab staging class:frontend app.reload:manuals-frontend
```

or to restart Publisher on integration backend-1 only, do:

```
fab integration -H backend-1 app.reload:publisher
```
