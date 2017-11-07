---
owner_slack: "#2ndline"
title: Block apps from being deployed
section: Deployment
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/releasing-software/blocking-apps-from-release.md"
last_reviewed_on: 2017-11-07
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
