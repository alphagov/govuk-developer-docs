---
owner_slack: "#govuk-2ndline"
title: Backup and restore Elasticsearch indices
parent: "/manual.html"
layout: manual_layout
section: Backups
last_reviewed_on: 2018-07-31
review_in: 2 months
---
The Elasticsearch indexes used for search are backed up to disk using
[es_dump_restore](https://github.com/patientslikeme/es_dump_restore).

**Note: this will change to S3 snapshots when production is moved to AWS**

## Creating a backup

Sometimes you may need to take a backup before a critical operation. To do
this, SSH to a `rummager-elasticsearch` box and run:

```bash
$ es_dump http://localhost:9200 /var/es_dump
```

The first argument is the Elasticsearch instance and the second is the
directory in which to store the output. The user running the dump needs
permission to write to this directory.

## Restoring a backup

Before restoring a backup, make sure you are
[monitoring the cluster](/manual/alerts/elasticsearch-cluster-health.html).

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

### Replaying rummager traffic

By restoring an older backup, you will lose any documents that have been
updated since the backup was taken.

After restoring a backup, follow
[Replaying traffic to correct an out of sync search index](/manual/rummager-traffic-replay.html)
to bring the search index back in sync with the publishing apps.
