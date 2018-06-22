---
owner_slack: "#govuk-datagovuk"
title: Architecture of data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-06-22
review_in: 6 months
---
[publish]: apps/datagovuk_publish
[find]: apps/datagovuk_find
[ckan]: apps/ckanext-datagovuk
[paas]: https://docs.cloud.service.gov.uk/#technical-documentation-for-gov-uk-paas
[terraform]: https://github.com/alphagov/datagovuk_infrastructure
[signon]: manual/manage-sign-on-accounts
[deployment]: manual/data-gov-uk-deployment
[monitoring]: manual/data-gov-uk-monitoring
[signon-adr]: https://github.com/alphagov/datagovuk_publish/blob/master/doc/adr/0002-signon.md

The `data.gov.uk` platform is used to publish and view datasets. A dataset is a document about a collection of links to documentation or data hosted somewhere on the Internet. The platform has the following software.

  * [CKAN] is the legacy publishing and finder app for datasets ('packages'). It also runs Nginx to support [Find].
  * [Find] is the public frontend for searching datasets using Elasticsearch. It replaces CKAN for certain routes.
  * [Publish] is the prototype publishing app for datasets. It currently syncs with CKAN to populate Elasitcsearch.
  * *TODO: Other services (contract-finder-archive)*
  * *TODO: Other services ([crime,education,finance,services,source,transport,weather,reference,guidance].data.gov.uk)*

## [Publish] and [Find]

[Publish] and [Find] are provisioned on [GOV.UK Paas][paas] using [Terraform]. The [deployment] and [monitoring] pages explain this in more detail, but you can use the following commands to get an overview.

```
cf apps
cf services
cf routes
cf env publish-data-beta-production
```

We use [GOV.UK Signon][signon] for user authentication in [Publish Data][publish], with the app in each environment linked to the corresponding instance of [GOV.UK Signon][signon]. See the Publish ADR for more info.

## [CKAN]

TODO
