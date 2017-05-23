---
owner_slack: "#2ndline"
title: 'Rescan an "infected" file in Whitehall'  
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-05-18
review_in: 12 months
---

If you suspect that a file has been incorrectly marked as "infected" in Whitehall,
you can rescan the file.

To verify the file is virus-free:

```bash
ssh asset-master-1.production
cd /mnt/uploads/whitehall
clamscan infected/system/uploads/attachment_data/file/123/example-file.xls
```

To rescan the file, move it to the `/incoming` directory:

```bash
ssh asset-master-1.production
cd /mnt/uploads/whitehall
sudo su assets
mkdir -p incoming/system/uploads/attachment_data/file/123
mv infected/system/uploads/attachment_data/file/123/example-file.xls incoming/system/uploads/attachment_data/file/123/example-file.xls
```
