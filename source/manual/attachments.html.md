---
owner_slack: "#govuk-platform-health"
title: Attachment backups
section: Backups
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-31
review_in: 2 months
next_review_notes: |
  This will probably be irrelevant soon once all attachments are moved to S3
related_applications: [asset-manager, whitehall]
---

We sync all the data to two [S3] buckets:

- from `asset-slave-1.backend` using [Duplicity]
- from `asset-slave-2.backend` using [s3cmd]

See the [offsite backups alert page] for information on how to check the status
of the backups and rerun the backup job.

Data can also be [restored from backups] using Duplicity.

Note: Asset Manager now also stores the asset files as objects in an S3 bucket
(i.e. `govuk-assets-production` in production) and instructs Nginx to proxy
requests to them. Thus the Asset Manager portion of the NFS mount is now largely
redundant and the files on it will shortly be removed. Versioning is enabled on
the S3 bucket and it is replicated to another versioned S3 bucket
(i.e. `govuk-assets-backup-production` in production) in another AWS region.

[Duplicity]: http://duplicity.nongnu.org 'Bandwidth-efficient encrypted backup'
[S3]: https://aws.amazon.com/s3/ 'Amazon Simple Storage Service (S3)'
[s3cmd]: http://s3tools.org/s3cmd 'Command-line tool for the Amazon S3 service'
[offsite backups alert page]: /manual/alerts/offsite-backups.html
[restored from backups]: /manual/restore-from-offsite-backups.html
