---
owner_slack: "#datagovuk-tech"
title: Incidents
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-30
review_in: 3 months
---

## Data loss

If data is lost in the various services, here’s what can be done:

**Postgres**

Restore the data from the [PaaS nightly backups](https://docs.cloud.service.gov.uk/#restoring-a-postgresql-service-snapshot) or contact [PaaS Support](https://docs.cloud.service.gov.uk/#postgresql-service-backup).

**Elasticsearch**

Contact [PaaS Support](https://www.cloud.service.gov.uk/support). Alternatively, while Legacy is still used the Elasticsearch index can be repopulated from the [legacy CKAN nightly dumps](/manual/data-gov-uk-common-tasks.html#import-data-from-legacy).
