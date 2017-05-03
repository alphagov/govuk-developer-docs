---
owner_slack: "#2ndline"
title: 'Elasticsearch: dump and restore indices'
parent: "/manual.html"
layout: manual_layout
section: Backups
last_reviewed_on: 2017-04-06
review_in: 6 months
---

# Elasticsearch: dump and restore indices

## Creating a dump

Sometimes you may need to take a backup of Elasticsearch before a
critical operation and all elasticsearch servers create their own
nightly backups via the following cronjob:

```bash
$ sudo crontab -lu elasticsearch
/usr/bin/es_dump http://localhost:9200 /var/es_dump
```

The first argument is the elasticsearch instance and the second is the
directory in which to store the output. The user running the dump needs
permission to write to this directory.

## Restoring a dump

Restoring to an index which exists is additive - it doesn't replace the
existing data or delete any documents which don't exist in the dump.
This means that:

If you want to replace something, you have to delete it first:

```
$ curl -XDELETE 'http://localhost:9200/indexname/'
```

If the import fails (as it sometimes does), you can simply re-run the command.

Given a dump, which will typically be a zipfile, then it can be restored
into elasticsearch:

```
$ es_dump_restore http://localhost:9200/ <indexname> dumpfile.zip
```

Given a directory of dumps named after their respective indices, you can
use the [elasticsearch-restore.sh](https://github.gds/gds/env-sync-and-backup/blob/master/scripts/elasticsearch-restore.sh)
script to restore them.
