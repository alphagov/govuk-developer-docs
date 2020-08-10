---
owner_slack: "#govuk-searchandnav"
title: Backup and restore Elasticsearch indices
parent: "/manual.html"
layout: manual_layout
section: Backups
---

GOV.UK uses AWS Managed Elasticsearch which takes daily snapshots of
the cluster as part of the managed service.  These are stored in a S3
bucket that is not made available to us.  Restoration is done by
making HTTP requests to the `_snapshot` endpoint.

To restore a snapshot, follow these steps:

0. SSH to a `search` box:

    ```
    gds govuk connect ssh -e integration search
    ```

0. Query the `_snapshot` endpoint of Elasticsearch to get the snapshot
   repository name:

    ```
    govuk_setenv search-api \
    bash -c 'curl "$ELASTICSEARCH_URI/_snapshot?pretty"'
    ```

0. Query the `_all` endpoint to identify the available snapshots in
   the named repository:

    ```
    govuk_setenv search-api \
    bash -c 'curl "$ELASTICSEARCH_URI/_snapshot/<repository-name>/_all?pretty"'
    ```

0. If an index already exists with the same name as the one being
   restored, delete the existing index:

    ```
    govuk_setenv search-api \
    bash -c 'curl -XDELETE "$ELASTICSEARCH_URI/<index-name>"'
    ```

0. Restore the index from the snapshot:

    ```
    govuk_setenv search-api \
    bash -c 'curl -XPOST -H 'Content-Type: application/json' "$ELASTICSEARCH_URI/_snapshot/<repository-name>/<snapshot-id>/_restore"  -d "{\"indices\": \"<index-name>\"}"'
    ```

> Further information about Elasticsearch snapshots can be found in the [AWS documentation](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains-snapshots.html)

After a restore has taken place, you will need to [fix the out-of-date search indices](/manual/fix-out-of-date-search-indices.html)
following the restore, since any changes made in publishing apps since the backup was taken will be missing.
