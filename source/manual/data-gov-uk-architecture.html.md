---
owner_slack: "#datagovuk-technical"
title: Architecture of data.gov.uk
section: data.gov.uk
layout: manual_layout
type: learn
parent: "/manual.html"
---
[business]: http://business.data.gov.uk/id/company/09747720
[ckan]: repos/ckanext-datagovuk
[environment]: https://environment.data.gov.uk
[find]: repos/datagovuk_find
[guidance]: https://guidance.data.gov.uk/
[guidance-github]: https://github.com/datagovuk/guidance
[open-data-policy]: https://www.gov.uk/government/publications/open-data-white-paper-unleashing-the-potential
[statistics]: https://statistics.data.gov.uk

The `data.gov.uk` (DGU) platform is used to publish and view datasets. A dataset contains the metadata for a collection of links to data hosted somewhere on the internet.

## Architectural overview of data.gov.uk

![](/manual/images/2025-dgu-eks-architecture.png)

The original for this diagram is available in [Google Drive](https://drive.google.com/open?id=1xnwgUBrwnQI2aIfZ0FT8nBQ-pERNRo2r) and can be edited with draw.io.

## data.gov.uk Services

Services owned by data.gov.uk:

* [CKAN] is the publishing app for datasets ('packages').
* [Find] is the public frontend for viewing and searching for datasets (using Solr).

Services on data.gov.uk sub-domains, but owned by other departments:

* [Statistics][statistics] is owned by the Office for National Statistics and was established as part of the [Open Data Policy][open-data-policy].
* [Environment][environment] is owned by DEFRA and was created as part of the [Open Data Policy][open-data-policy]. Users with issues or questions should contact the [maintainers](https://environment.data.gov.uk/support)
* [Guidance] is a set of manual pages hosted in [GitHub][guidance-github].
* [Business] is a legacy redirect to Companies House.

## [CKAN] and [Find]

[CKAN] and [Find] are hosted on AWS EKS and are maintained/deployed in the same way as most other GOV.UK applications.
