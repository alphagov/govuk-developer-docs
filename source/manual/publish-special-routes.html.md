---
owner_slack: "#govuk-developers"
title: Publish special routes
section: Deployment
layout: manual_layout
parent: "/manual.html"
old_paths:
 - /manual/publish_special_routes.html
---

The [Special Route Publisher](https://github.com/alphagov/special-route-publisher) is the home for all special routes that are currently published by a variety of apps to the Publishing API.

All new special routes should be created in this tool, and existing special routes should be moved as necessary.

The [Publish special routes Jenkins job](https://deploy.blue.staging.govuk.digital/job/Publish_Special_Routes/) will re-publish all defined special routes to the Publishing API.
