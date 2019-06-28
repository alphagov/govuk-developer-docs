---
owner_slack: "#govuk-2ndline"
title: Backup and restore Elasticsearch indices
parent: "/manual.html"
layout: manual_layout
section: Backups
last_reviewed_on: 2019-04-26
review_in: 3 months
---

GOV.UK uses AWS Managed Elasticsearch which takes daily snapshots of
the cluster as part of the managed service.  These are stored in a S3
bucket that is not made available to us.  Restoration is done by
making HTTP requests to the `_snapshot` endpoint.

To restore a snapshot, follow these steps:

1. Log into a `search` machine

    ```
    govukcli set-context <environment>
    govukcli ssh search
    ```

2. Query the `_snapshot` endpoint of Elasticsearch to get the snapshot repository
name:

    ```
    curl http://elasticsearch5/_snapshot?pretty
    ```

3. Query the `_all` endpoint to identify the available snapshots in the named
repository:

    ```
    curl http://elasticsearch5/_snapshot/<repository-name>/_all?pretty
    ```

4. If an index already exists with the same name as the one being restored,
delete the existing index:

    ```
    curl -XDELETE http://elasticsearch5/<index-name>
    ```

5. Restore the index from the snapshot:

    ```
    curl -XPOST 'http://elasticsearch5/_snapshot/<repository-name>/<snapshot-id>/_restore' -d '{"indices": "<index-name>"}' -H 'Content-Type: application/json'
    ```

> Further information about Elasticsearch snapshots can be found in the [AWS documentation](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains-snapshots.html)

After a restore has taken place, traffic will need to be [replayed](/manual/search-api-traffic-replay.html)
following the restore, since the index will be out-of-sync with the
publishing apps.
