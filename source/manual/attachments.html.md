---
owner_slack: "#2ndline"
title: Attachment backups
section: Backups
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/backups/attachments.md"
last_reviewed_on: 2017-07-11
review_in: 6 months
---

We sync all the data to two [S3] buckets:

- from asset-slave-1.backend using [Duplicity]
- from asset-slave-2.backend using [s3cmd]

See the [offsite backups alert page] for information on how to check the status
of the backups and rerun the backup job.

Data can also be [restored from backups] using Duplicity.

[Duplicity]: http://duplicity.nongnu.org 'Bandwidth-efficient encrypted backup'
[S3]: https://aws.amazon.com/s3/ 'Amazon Simple Storage Service (S3)'
[s3cmd]: http://s3tools.org/s3cmd 'Command-line tool for the Amazon S3 service'
[offsite backups alert page]: /manual/alerts/offsite-backups.html
[restored from backups]: /manual/restore-from-offsite-backups.html
