---
owner_slack: "#govuk-searchandnav"
title: Reindex an Elasticsearch index
section: Publishing
layout: manual_layout
parent: "/manual.html"
related_applications: [search-api]
---

After updating an Elasticsearch index's schema by [changing the fields or
document types][update-fields-or-doc-types], you need to reindex the affected
index before the new fields and types can be used.

The reindexing process:

0. Locks the Elasticsearch index to prevent writes to the index while data is
   being copied
0. Creates a new index using the schema defined in the deployed version of
   search-api
0. Copies all the data from the old to the new index
0. Compares the old and new data to check for inconsistencies
0. If everything looks the same, switches the [alias][index-alias] to the new
   index

**You don't need to do this if you have changed the
govuk_document_types gem,** instead run the rake task
`search:update_supertypes` to update documents in-place.  This can be
done during working hours.

## How to reindex an Elasticsearch index

**Do not reindex on production during working hours except in an
emergency.** Reindexing locks the index for writes, so content is not
updated in the search index. See the [out-of-date search
indices](#out-of-date-search-indices) section below if you need to run
a reindexing during working hours. Reindexing takes around 2 hours to
complete.

To reindex, run the `search:migrate_schema` rake task:

```
govuk_setenv search-api bundle exec \
rake search:migrate_schema SEARCH_INDEX=alias_of_index_to_migrate
```

If you set the last parameter to `SEARCH_INDEX=all`, search-api will reindex all
the indices sequentially.

You can also run this task from Jenkins.

To monitor progress, SSH to a search box and check how many documents
have been copied to the new index:

```bash
gds govuk connect ssh -e integration search
govuk_setenv search-api \
bash -c 'curl "$ELASTICSEARCH_URI/_cat/indices?v"'
```

### Out-of-date search indices

This step is only necessary if you ran reindexing job during working hours,
which means that content updated in whitehall will be missing from search.

See [Fix out-of-date search indices][fix-out-of-date-search-indices]
for details.

### Cleanup

Reindexing does not delete the old index. This lets us switch back to the old
index if there is a serious problem with the new one.

Once you're confident that the reindexing was successful, delete the old
(unaliased) index using the search-api rake task:

```
govuk_setenv search-api bundle exec \
rake search:clean SEARCH_INDEX=alias_of_index_to_clean_up
```

You can also run this task from Jenkins.

Avoid leaving old indices around for more than a few days. If enough
old indices hang around, we may hit space limitations and be unable to
index new documents.

#### Automatic Cleanup

However,
in the case wherein we end up with multiple copies of the same index left behind,
we have an automated clean up task that removes any extra indexes over a given
age:

```
rake search:timed_clean MAX_INDEX_AGE=number_of_days SEARCH_INDEX=alias_of_index_to_clean_up
```

This is running in a Jenkins job that clears any index over 7 days old, and will always leave at least one inactive index available (typically the
  newest one created) alongside the active index for backup purposes.

### Troubleshooting

#### To stop the reindexing job

If you need to cancel the reindexing while it's in progress:

0. Stop the reindexing rake task
0. Unlock the old index by running the search-api rake task:

    ```
    govuk_setenv search-api bundle exec \
    rake search:unlock SEARCH_INDEX=alias_of_index_to_unlock
    ```

    You can also run this task from Jenkins.

This doesn't actually stop the reindexing, because reindexing is an internal
Elasticsearch progress triggered by the rake task. It will stop the rake task
from switching the alias over to the new index once it has copied all the data,
which is normally good enough.

If you need to stop the reindexing process itself, for example because
Elasticsearch is about to run out of disk space, connect to the
search box (see above) then:

0. Find the ID of the reindexing task:

    ```
    govuk_setenv search-api \
    bash -c 'curl "$ELASTICSEARCH_URI/_tasks?actions=%2Areindex&pretty"'
    ```

0. Stop the task:

    ```
    govuk_setenv search-api \
    bash -c 'curl -XPOST "$ELASTICSEARCH_URI/_tasks/<task_id>/_cancel"'
    ```

#### To switch back to the old index

If you discover a problem after reindexing and need to switch back to the old
index, run this search-api rake task:

```
govuk_setenv search-api bundle exec \
rake search:switch_to_named_index[full_index_name] SEARCH_INDEX=index_alias
```

You can also run this task on Jenkins.

where `full_index_name` is the full name of the new index, including the date
and UUID, e.g. `govuk-2018-01-29t17:08:21z-31f39bdb-c62b-4607-8081-19ea87fb1498`.

Switching back to an old index means that you'll **lose any content updates**
that were published while the new index was live. To fix this, [replay traffic][fix-out-of-date-search-indices] from both publishing-api and Whitehall.

[update-fields-or-doc-types]: /apis/search/add-new-fields-or-document-types.html
[index-alias]: https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html
[fix-out-of-date-search-indices]: fix-out-of-date-search-indices.html
