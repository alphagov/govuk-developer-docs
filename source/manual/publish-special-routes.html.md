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

There are two Jenkins jobs to publish special routes:

- Publish a single special route: [Integration](https://deploy.integration.publishing.service.gov.uk/job/Publish_Single_Special_Route/), [Staging](https://deploy.blue.staging.govuk.digital/job/Publish_Single_Special_Route/) and [Production](https://deploy.blue.production.govuk.digital/job/Publish_Single_Special_Route/).
- Publish all special routes: [Integration](https://deploy.integration.publishing.service.gov.uk/job/Publish_Special_Routes/), [Staging](https://deploy.blue.staging.govuk.digital/job/Publish_Special_Routes/) and [Production](https://deploy.blue.production.govuk.digital/job/Publish_Special_Routes/).
