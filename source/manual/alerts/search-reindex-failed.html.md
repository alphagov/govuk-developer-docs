---
owner_slack: "#govuk-2ndline"
title: Search reindex failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-05-01
review_in: 6 months
---

The reindex task is run weekly on a Monday at 12pm on integration. It
[reindexes][reindexing] every Elasticsearch index used by [search-api][]. This is
to ensure the process works as expected when we need to run it in production.
This task is manually run in production by the development team after they have
made and changes to the Elasticsearch schema.

If this process fails then please escalate to Platform Health for further investigation.

This task can be manually run with the following command:

```
bundle exec rake search:migrate_schema CONFIRM_INDEX_MIGRATION_START=true SEARCH_INDEX=<index_alias_name>
```

[reindexing]: /manual/reindex-elasticsearch.html
[search-api]: /apps/search-api.html
