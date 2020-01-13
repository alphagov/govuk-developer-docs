---
owner_slack: "#govuk-2ndline"
title: Restart an application
parent: "/manual.html"
layout: manual_layout
section: Deployment
last_reviewed_on: 2020-01-13
review_in: 12 months
---

To restart an application go to the Deploy app jenkins job in [Carrenza](https://deploy.publishing.service.gov.uk/job/Deploy_App/build) or [AWS](https://deploy.blue.production.govuk.digital/job/Deploy_App/build), choose your app, the **current release** and select `app:hard_restart`.

For avoidance of doubt, the current release is usually simply called "**release**".
