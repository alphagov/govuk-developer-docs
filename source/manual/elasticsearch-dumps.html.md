---
owner_slack: "#search-team"
title: 'Backup and restore Elasticsearch indices'
parent: "/manual.html"
layout: manual_layout
section: Backups
last_reviewed_on: 2017-09-12
review_in: 2 months
---

## Creating a backup

Sometimes you may need to take a backup of Elasticsearch before a
critical operation. You can use [es_dump_restore](https://github.com/patientslikeme/es_dump_restore) for this.

All Elasticsearch servers create their own
nightly backups using a cronjob, which shows how to run it:

```bash
$ sudo crontab -lu elasticsearch
/usr/bin/es_dump http://localhost:9200 /var/es_dump
```

The first argument is the Elasticsearch instance and the second is the
directory in which to store the output. The user running the dump needs permission to write to this directory.

## Restoring a backup

Before restoring a backup, make sure you are [monitoring the cluster](/manual/alerts/elasticsearch-cluster-health.html).

Restoring to an index which exists is additive - it doesn't replace the
existing data or delete any documents which don't exist in the dump.
This means that if the import fails (as it sometimes does), you can simply re-run the command.

### Restoring GOV.UK search indexes (with aliases)

Given a directory of dumps named after their respective indices, you can restore them using the same steps as the environment data sync script, [elasticsearch-restore.sh](https://github.com/alphagov/env-sync-and-backup/blob/master/scripts/elasticsearch-restore.sh).

```
backupfile="government.zip"
alias_name=$(basename $backupfile .zip)
iso_date="$(date --iso-8601=seconds|cut --byte=-19|tr [:upper:] [:lower:])z"
real_name="$alias_name-$(date --iso-8601=seconds|cut --byte=-19|tr [:upper:] [:lower:])z-00000000-0000-0000-0000-000000000000"

es_dump_restore restore_alias "http://localhost:9200/" "$alias_name" "$real_name" "$backupfile" '{}' $BATCH_SIZE
```

This will restore each backup into a new index, and then move the alias to point to it.

If you need to change the alias back for any reason, you can run the rummager rake task `rummager:switch_to_named_index[foo-2017-01-01...]`, where `foo-2017-01-01...` is the name of the index you want to point the alias to. The task will automatically determine the correct alias name from the index name.

The [search analytics jenkins job](https://deploy.publishing.service.gov.uk/job/search-fetch-analytics-data/) runs overnight and will automatically clean up search indexes that no longer have an alias pointing to them. It looks for indices with any of these names:

- mainstream-$timestamp
- detailed-$timestamp
- government-$timestamp
- page-traffic-$timestamp
- metasearch-$timestamp

After restoring a backup, consider [replaying traffic](/manual/rummager-traffic-replay.html)
to bring the search index back in sync with the publishing apps.

### Replaying rummager traffic

Once an index is restored we need to re-run all traffic that occurred after the snapshot was taken for the 'government', 'detailed' and
'mainstream' indices. We have setup `GOR` logging for `POST` and `GET` requests so that we can replay this traffic, this way we don't need
to resend the traffic from individual publishing application.

> The `govuk` index can be restored by resending data directly from the publishing API as it is not updated directly from the publishing applications.

The logs are stored on the rummager servers (1 file per server) location at:

```
/var/logs/gor_dump
```

A copy of the file should be taken for the restore, as the restore requests will be logged to the file. The following command can be used to run the restore:

```
sudo gor --input-file "20171031.log|6000%" --stats --output-http-stats --output-http "http://localhost:3009/|6000%" -verbose
```

This runs the restore at 60x the speed it was saved so each hour of logs takes 1min to process.

> This processed failed when running on the rummager server, but was successful when run locally with port forwarding.
> This may be an issue with the `GOR` version on the server.

### Restoring other indexes (without aliases)

If you want to replace something, you have to delete it first.

```
$ curl -XDELETE 'http://localhost:9200/indexname/'
```

Given a dump, which will typically be a zipfile, then it can be restored
into Elasticsearch:

```
$ es_dump_restore http://localhost:9200/ <indexname> dumpfile.zip
```
