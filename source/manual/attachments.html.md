---
owner_slack: '#2ndline'
review_by: 2017-07-08
title: Attachment backups
section: Backups
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/backups/attachments.md"
---

# Attachment backups

We sync all the data to both an Amazon S3 bucket (using [Duplicity], from
asset-slave-1.backend) and [S3] (using [s3cmd], from asset-slave-2.backend).

To restore from these locations you would need to pull the files and copy to the master.
Due to the size of the dataset this could potentially take a very long time.

[Duplicity]: http://duplicity.nongnu.org 'Bandwidth-efficient encrypted backup'
[S3]: https://aws.amazon.com/s3/ 'Amazon Simple Storage Service (S3)'
[s3cmd]: http://s3tools.org/s3cmd 'Command-line tool for the Amazon S3 service'
