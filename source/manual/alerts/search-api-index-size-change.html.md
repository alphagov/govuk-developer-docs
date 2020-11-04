---
owner_slack: "#govuk-2ndline"
title: Search API index size has significantly increased/decreased
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
related_applications: [search-api]
---

This alert indicates that a large number of documents have been added to or
removed from the [search-api][search-api] search index.

It compares the current size of the index with the size from one week ago, and
triggers the alert if the difference is more than the thresholds [configured in
puppet][thresholds].

## Investigation

The Icinga alert should say which index is affected.

Check the [index size dashboard][index_size_dashboard] to see how many
documents have been affected.

If the dashboard shows that the index is currently empty:

- Check the [cluster health][cluster_health] to make sure that the
  Elasticsearch cluster is available and has the expected number of documents
  (around 300,000 in total across the indices).
- Check that the [search_index_checks Jenkins job][search_index_checks] has
  been run recently. It should run regularly to populate the Graphite data
  which powers the check, but if Jenkins is busy then sometimes it cause
  missing Graphite data which incorrectly triggers the alert.

If the index size has been growing steadily over the course of several hours,
the change may be due to a large number of documents being published. This
means that the index size has genuinely grown, so the alert can be ignored.

If the number of documents has increased very suddenly, this may be because
content has been [accidentally duplicated][duplicate_documents].

If there does appear to be a real problem with search, see the [cluster health
investigation guide][debug_elasticsearch] for help.

[cluster_health]: /manual/alerts/elasticsearch-cluster-health.html
[duplicate_documents]: /manual/incorrect-content-in-search-or-navigation.html#content-is-duplicated-in-search-results
[debug_elasticsearch]: /manual/alerts/elasticsearch-cluster-health.html#investigating-problems
[index_size_dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/search_api_index_size.json
[search-api]: /apps/search-api.html
[search_index_checks]: https://deploy.blue.production.govuk.digital/job/search_api_index_checks/
[thresholds]: https://github.com/alphagov/govuk-puppet/blob/1f482d137f27afbbe4509c19791667f8d74eea11/modules/monitoring/manifests/checks.pp#L120
