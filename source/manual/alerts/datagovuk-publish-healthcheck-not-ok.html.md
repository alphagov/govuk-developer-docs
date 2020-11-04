---
owner_slack: "#govuk-2ndline"
title: datagovuk_publish app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

[datagovuk_publish](https://github.com/alphagov/datagovuk_publish)
has a healthcheck that monitors two Sidekiq jobs,
[`ckan_v26_package_sync`](https://github.com/alphagov/datagovuk_publish/blob/master/app/workers/ckan/v26/package_sync_worker.rb)
and [`ckan_v26_ckan_org_sync`](https://github.com/alphagov/datagovuk_publish/blob/master/app/workers/ckan/v26/ckan_org_sync_worker.rb).

The healthcheck alert notifies us if one or both of these jobs are not running in
the expected timeframe set. This means latest [dataset](https://ckan.publishing.service.gov.uk/dataset)
or [publisher](https://ckan.publishing.service.gov.uk/publisher) updates are
not appearing on data.gov.uk - see [Datasets published in CKAN are not appearing on Find](/manual/data-gov-uk-2nd-line.html#datasets-published-in-ckan-are-not-appearing-on-find)

You can monitor the number of jobs in the Sidekiq queue
via [the DGU dashboard](https://grafana-paas.cloudapps.digital/d/rk9fSapik/data-gov-uk-2nd-line?orgId=1)
("Sign in with Google").
