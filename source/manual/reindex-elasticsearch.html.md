---
owner_slack: "#govuk-2ndline"
title: Reindex an Elasticsearch index
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-03-03
review_in: 6 months
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

**Note:** If you have changed the govuk_document_types gem, you do not need
to migrate the schema for your changes to be applied to documents in
elasticsearch. Instead, you can run the rake task `rummager:update_supertypes`
to update documents inplace without locks. This can be done during working hours.

## How to reindex an Elasticsearch index

**Do not reindex on production during working hours except in an emergency.**
Reindexing locks the index for writes, so content is not updated in the search
index. See the [Replay traffic](#replay-traffic) section below if you need to
run a reindexing during working hours. Reindexing takes around 40 minutes to
an hour to complete.

To reindex, run the `rummager:migrate_schema` rake task:

```
bundle exec rake rummager:migrate_schema CONFIRM_INDEX_MIGRATION_START=1 RUMMAGER_INDEX=alias_of_index_to_migrate
```

If you set the last parameter to `RUMMAGER_INDEX=all`, rummager will reindex all
the indices sequentially.

You can run this task from Jenkins, but it will block other rake tasks from
being run for 15 minutes to an hour. You can avoid this by running the command
directly on a `search` machine, but you need to prefix the command with
`govuk_setenv rummager` to make sure the Elasticsearch hostname is set
correctly.

To monitor progress, SSH to an Elasticsearch box with port-forwarding:

```
ssh rummager-elasticsearch-1.api.staging -CNL 9200:127.0.0.1:9200
```

#### On AWS

```
ssh $(ssh integration "govuk_node_list --single-node -c rummager_elasticsearch").integration -CNL 9200:127.0.0.1:9200
```

Then visit <http://localhost:9200/_plugin/head/> to check how many documents have
been copied to the new index.

Alternatively, to view a summary of the indices from inside the Elasticsearch instance:

    curl http://localhost:9200/_cat/indices

### Replay traffic

This step is only necessary if you ran reindexing job during working hours,
which means that content published in whitehall will be missing from search.

See [Replaying traffic to correct an out of sync search index][traffic-replay]
for details.

### Cleanup

Reindexing does not delete the old index. This lets us switch back to the old
index if there is a serious problem with the new one.

Once you're confident that the reindexing was successful, delete the old
(unaliased) index using the rummager rake task:

```
rake rummager:clean RUMMAGER_INDEX=alias_of_index_to_clean_up
```

Avoid leaving old indices around for more than a few days. Rummager performance
starts to degrade once there are more than three or four old indices in the
cluster.

### Troubleshooting

#### To stop the reindexing job

If you need to cancel the reindexing while it's in progress:

0. Stop the reindexing rake task
0. Unlock the old index by running the rummager rake task:
    ```
    rake rummager:unlock RUMMAGER_INDEX=alias_of_index_to_unlock
    ```

This doesn't actually stop the reindexing, because reindexing is an internal
Elasticsearch progress triggered by the rake task. It will stop the rake task
from switching the alias over to the new index once it has copied all the data,
which is normally good enough.

If you need to stop the reindexing process itself, for example because
Elasticsearch is about to run out of disk space, port-forward to the
rummager-elasticsearch box (see above) then use <http://localhost:9200/_plugin/head/>
to send these requests to Elasticsearch:

0. Find the ID of the reindexing task:

    ```
    GET /_tasks?actions=%2Areindex
    ```

0. Stop the task:

    ```
    POST /_tasks/{task_id}/_cancel
    ```

#### To switch back to the old index

If you discover a problem after reindexing and need to switch back to the old
index, run this rummager rake task:

```
rake rummager:switch_to_named_index[full_index_name] RUMMAGER_INDEX=index_alias
```

where `full_index_name` is the full name of the new index, including the date
and UUID, e.g. `govuk-2018-01-29t17:08:21z-31f39bdb-c62b-4607-8081-19ea87fb1498`.

Switching back to an old index means that you'll **lose any content updates**
that were published while the new index was live. To fix this, [replay the
traffic][traffic-replay] from both publishing-api and Whitehall.

[update-fields-or-doc-types]: /apis/search/add-new-fields-or-document-types.html
[index-alias]: https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html
[traffic-replay]: rummager-traffic-replay.html
