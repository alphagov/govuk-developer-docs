---
owner_slack: "#govuk-searchandnav"
title: Restore Elasticsearch indices from backup
parent: "/manual.html"
layout: manual_layout
section: Backups
---

## Background

AWS Managed Elasticsearch automatically takes hourly snapshots for backup and
disaster recovery purposes. The snapshot data is stored in an Amazon-owned S3
bucket that is not directly available to us via S3 but is configured as an
Elasticsearch snapshot repository called `cs-automated-enc`.

Restores are done via the Elasticsearch API, by making HTTP requests to the
`_snapshot` endpoint.

We also have a `govuk-production` snapshot repository, which is normally only
used for copying indices from production to the non-production environments.

## Restore a specific index from a snapshot

1. List the available backup snapshots in the `cs-automated-enc` snapshot
   respository and identify the snapshot that you want to restore from.

    ```sh
    k exec deploy/search-api -- \
      sh -c 'curl "$ELASTICSEARCH_URI/_snapshot/cs-automated-enc/_all?pretty"'
    ```

    This can take a few seconds.

2. If an index already exists with the same name as the one you want to
   restore, delete the existing index.

    ```sh
    k exec deploy/search-api -- sh -c 'curl -XDELETE "$ELASTICSEARCH_URI/<index-name>"'
    ```

3. Restore the index from the snapshot. Fill in `<snaphot-id>` and
   `<index-name>` as appropriate.

    ```sh
    k exec deploy/search-api -- \
      sh -c 'curl -XPOST -H 'Content-Type: application/json' "$ELASTICSEARCH_URI/_snapshot/cs-automated-enc/<snapshot-id>/_restore" -d "{\"indices\": \"<index-name>\"}"'
    ```

4. The restore can take a few minutes. The `/_cat/recovery` resource gives an
   indication of progress.

    ```sh
    k exec deploy/search-api -- sh -c 'curl "$ELASTICSEARCH_URI/_cat/recovery"'
    ```

5. Once the restore has finished, [reprocess any content
   changes](/manual/fix-out-of-date-search-indices.html) that happened after
   the backup.

   > The reprocessing step is necessary in order to bring the restored index up
   > to date, because GOV.UK's indexing is incremental only. In other words,
   > there is no regular full reindex.

## Restore all indices from a snapshot

Restoring all indices is a similar procedure to restoring a specific index.

1. Identify the snapshot to restore. See step 1 above.

1. Delete all indices.

    ```sh
    k exec deploy/search-api -- sh -c 'curl -XDELETE "$ELASTICSEARCH_URI/_all"'
    ```

1. Restore all indices from the snapshot.

    ```sh
    k exec deploy/search-api -- \
      sh -c 'curl -XPOST "$ELASTICSEARCH_URI/_snapshot/cs-automated-enc/<snapshot-id>/_restore"'
    ```

1. Once the restore has finished, reprocess recent content changes to bring the
   indices up to date. See steps 4 and 5 above.

## Further reading

See [Restoring
snapshots](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-snapshots.html#managedomains-snapshot-restore)
in the AWS Managed Elasticsearch/Opensearch documentation.
