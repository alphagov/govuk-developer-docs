---
title: Attachment backups
section: Backups
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/backups/attachments.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/backups/attachments.md)


# Attachment backups

We sync all the data to both an offsite backup machine (using Duplicity, from
asset-slave-1.backend) and S3 (using s3cmd, from asset-slave-2.backend).

To restore from these locations you would need to pull the files and copy to the master.
Due to the size of the dataset this could potentially take a very long time.
