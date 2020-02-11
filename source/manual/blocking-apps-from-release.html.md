---
owner_slack: "#govuk-developers"
title: Block apps from being deployed
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-06-27
review_in: 6 months
related_applications: [release]
---

Generally our apps and deploy pipeline should always be in a state where `master` is deployable.

If a release doesn't work on integration or staging, consider reverting the commits if you're unable to resolve the problem straight away.

In exceptional circumstances, we may wish to block deployment for a short period of time.

In this case, add a note to the application in the release app.

This should explain:

- Why the app is not deployable at the moment
- Who to contact about deploying the app
- When you expect the app to be deployable again
