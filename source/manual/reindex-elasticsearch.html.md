---
owner_slack: "#2ndline"
title: Reindex an Elasticsearch index
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-01-27
review_in: 3 months
related_applications: [rummager]
---

After updating an Elasticsearch index's schema by [changing the fields or
document types][update-fields-or-doc-types], you need to reindex the affected
index before the new fields and types can be used.

The reindexing process:

0. Locks the Elasticsearch index to prevent writes to the index while data is
being copied
0. Creates a new index using the schema defined in the deployed version of
rummager
0. Copies all the data from the old to the new index
0. Compares the old and new data to check for inconsistencies
0. If everything looks the same, switches the [alias][index-alias] to the new
index

## How to reindex an Elasticsearch index

**Do not reindex on production during working hours except in an emergency.**
Reindexing locks the index for writes, so content is not updated in the search
index. See the [Replay traffic](#replay-traffic) section below if you need to
run a reindexing during working hours.

To reindex, run the `rummager:migrate_schema` rake task:

```
bundle exec rake rummager:migrate_schema CONFIRM_INDEX_MIGRATION_START=1 RUMMAGER_INDEX=name_of_index_to_migrate
```

If you set the last parameter to `RUMMAGER_INDEX=all`, rummager will reindex all
the indices sequentially.

You can run this task from Jenkins, but it will block other rake tasks from
being run for 15 minutes to an hour. You can avoid this by running the command
directly on a `search` machine, but you need to prefix the command with
`govuk_setenv rummager` to make sure the Elasticsearch hostname is set
correctly.

To monitor progress, SSH to an elasticsearch box with port-forwarding:

```
ssh -L9200:localhost:9200 rummager-elasticsearch-1.api.staging
```

Then visit <http://localhost:9200/_plugin/head/> to check how many documents have
been copied to the new index.

### Replay traffic

This step is only necessary if you ran reindexing job during working hours,
which means that content published in whitehall will be missing from search.

See [Replaying traffic to correct an out of sync search index][rummager-traffic-replay.html]
for details.

[update-fields-or-doc-types]: /apis/search/add-new-fields-or-document-types.html
[index-alias]: https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html
