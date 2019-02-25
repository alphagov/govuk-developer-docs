---
owner_slack: "#govuk-2ndline"
title: Backup and restore Elasticsearch indices
parent: "/manual.html"
layout: manual_layout
section: Backups
last_reviewed_on: 2019-02-25
review_in: 4 weeks
---
There are currently two types of Elasticsearch cluster running on
GOV.UK:

* Non-managed Elasticsearch on Carrenza: Elasticsearch 2.x, being
used by `rummager` in staging and production
* AWS Managed Elasticsearch: Elasticsearch 5.x, used by `search-api`
in integration only (staging and production will use this in the near
future).

There are different routes to restoring backups for each of the types
of deployment.  Regardless of the type of cluster, traffic will need
to be [replayed](/manual/rummager-traffic-replay.html) following the
restore, since the index will be out-of-sync with the publishing apps.

## Non-managed Elasticsearch on Carrenza

The Elasticsearch indexes used for search are backed up to disk using
[es_dump_restore](https://github.com/patientslikeme/es_dump_restore).

> **Note**
>
> This will change to S3 snapshots when production is moved to AWS

### Creating a backup

Sometimes you may need to take a backup before a critical operation. To do
this, SSH to a `rummager-elasticsearch` box and run:

```bash
$ es_dump http://localhost:9200 /var/es_dump
```

The first argument is the Elasticsearch instance and the second is the
directory in which to store the output. The user running the dump needs
permission to write to this directory.

The [env-sync-and-backup job](https://github.com/alphagov/env-sync-and-backup/blob/master/jobs/elasticsearch-rummager.sh)
creates daily copies of the Elasticsearch snapshots and stores them in S3 for 5 days.

### Restoring a backup

Before restoring a backup, make sure you are
[monitoring the cluster](/manual/alerts/elasticsearch-cluster-health.html).

To view the current status of the indices from inside the Elasticsearch instance:

    curl http://localhost:9200/_cat/indices

Restoring to an index which exists is additive - it doesn't replace the
existing data or delete any documents which don't exist in the dump.
This means that if the import fails (as it sometimes does), you can simply
re-run the command.

Given a directory of dumps named after their respective indices, you can
restore them using the same steps as the environment data sync script,
[elasticsearch-restore.sh](https://github.com/alphagov/env-sync-and-backup/blob/master/scripts/elasticsearch-restore.sh).

```
backupfile="government.zip"
alias_name=$(basename $backupfile .zip)
iso_date="$(date --iso-8601=seconds|cut --byte=-19|tr [:upper:] [:lower:])z"
real_name="$alias_name-$(date --iso-8601=seconds|cut --byte=-19|tr [:upper:] [:lower:])z-00000000-0000-0000-0000-000000000000"

es_dump_restore restore_alias "http://localhost:9200/" "$alias_name" "$real_name" "$backupfile" '{}' $BATCH_SIZE
```

This will restore each backup into a new index, and then move the alias to point to it.

If you need to change the alias back for any reason, you can run the rummager
rake task `rummager:switch_to_named_index[foo-2017-01-01...]`, where
`foo-2017-01-01...` is the name of the index you want to point the alias to.
The task will automatically determine the correct alias name from the index
name.

Once backups have been restored it is necessary to manually delete the old
indices as otherwise Elasticsearch will eventually run out of disk space and
memory. It's OK to keep an old index around for a few days in case you need to
roll back. You can delete all the unaliased indices by running the rummager
task: `rummager:clean`.

## AWS Managed Elasticsearch 5.x

Daily snapshots of the Elasticsearch indices are taken automatically by AWS
as part of the managed service.  These are stored in a S3 bucket that is
not made available to us.  Restoration is done by making HTTP requests to
the `_snapshot` endpoint.

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
