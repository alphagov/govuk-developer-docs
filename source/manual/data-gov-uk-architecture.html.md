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
[signon]: manual/manage-sign-on-accounts
[deployment]: manual/data-gov-uk-deployment
[monitoring]: manual/data-gov-uk-monitoring
[signon-adr]: https://github.com/alphagov/datagovuk_publish/blob/master/doc/adr/0002-signon.md
[statistics]: http://statistics.data.gov.uk
[land-registry]: http://landregistry.data.gov.uk
[csw]: http://csw.data.gov.uk/geonetwork/srv/en/main.home
[location-mde]: http://locationmde.data.gov.uk
[guidance]: http://guidance.data.gov.uk
[business]: http://business.data.gov.uk/id/company/09747720
[location]: http://location.data.gov.uk/registry/
[environment]: http://environment.data.gov.uk/index.html
[guidance-github]: https://github.com/datagovuk/guidance
[open-data-policy]: https://www.gov.uk/government/publications/open-data-white-paper-unleashing-the-potential
[inspire]: http://inspire.ec.europa.eu/about-inspire
[uk-location-programme]: https://inspire.ec.europa.eu/events/conferences/inspire_2010/presentations/258_pdf_presentation.pdf
[contract-finder]: https://data.gov.uk/data/contracts-finder-archive/
[contract-finder-new]: https://www.contractsfinder.service.gov.uk/Search
[land-registry-birth]: https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/246732/0247.pdf
[reference]: http://reference.data.gov.uk
[time-interval-service]: https://github.com/epimorphics/IntervalServer
[heroku]: https://docs.publishing.service.gov.uk/manual/review-apps.html#use-the-shared-heroku-account

The `data.gov.uk` platform is used to publish and view datasets. A dataset is a document about a collection of links to documentation or data hosted somewhere on the Internet.

Services owned by data.gov.uk
  * [CKAN] is the legacy publishing and finder app for datasets ('packages'). It also runs Nginx to support [Find].
  * [Find] is the public frontend for searching datasets using Elasticsearch. It replaces CKAN for certain routes.
  * [Publish] is the prototype publishing app for datasets. It currently syncs with CKAN to populate Elasticsearch.
  * [Publish] is the prototype publishing app for datasets. It currently syncs with CKAN to populate Elasitcsearch.
  * [Reference][reference] is a legacy service that attempts to provide a [nomenclature of time intervals][time-interval-service], hosted on [Heroku][heroku].

Services with data.gov.uk sub-domains, but owned by other departments
  * [Statistics] is owned by the Office for National Statistics and was established as part of the [Open Data Policy][open-data-policy].
  * [Environment][environment] is owned by DEFRA and was created with the [Location] service as part of the [Open Data Policy][open-data-policy].
  * [Land Registry][land-registry] is owned by the same and [was created][land-registry-birth] to publish linked data as part of the [Open Data Policy][open-data-policy].
  * [Catalog Service for the Web][csw] is owned by Ordnance Survey and serves [INSPIRE] datasets to the EU Geoportal.
  * [Location Metadata Editor][location-mde] is owned by DEFRA and publishes [INSPIRE] metadata, which is used to enrich datasets.
  * [Location] came before [Location Metadata Editor][location-mde] and was established as part of the [UK Location Programme][uk-location-programme].
  * [Guidance] is a set of manual pages hosted in [GitHub][guidance-github], which ought to be migrated into normal GOV.UK docs.
  * [Contract Finder][contract-finder] is now provided by [Crown Commercial Service][contract-finder-new], which ought to have pre-2015 stuff merged in.
  * [Business] is a legacy redirect to Companies House.

## [Publish] and [Find]

[Publish] and [Find] are provisioned on [GOV.UK Paas][paas]. The [deployment] and [monitoring] pages explain this in more detail, but you can use the following commands to get an overview.

```
cf apps
cf services
cf routes
cf env publish-data-beta-production
```

We use [GOV.UK Signon][signon] for user authentication in [Publish Data][publish], with the app in each environment linked to the corresponding instance of [GOV.UK Signon][signon]. See the Publish ADR for more info.

## [CKAN]

TODO
