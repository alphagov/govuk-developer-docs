---
owner_slack: "#govuk-2ndline"
title: Fix stuck virus scanning
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-31
review_in: 6 months
related_applications: [whitehall]
---

Documents uploaded to asset-master are scanned asynchronously through
a virus scanner, as explained below.

If the number of documents is too high, users can experience long waiting times
until they see the documents available. There is a Grafana [dashboard](https://grafana.publishing.service.gov.uk/dashboard/file/asset_master_virus_scan_speed.json)
that helps to visualise the number of documents that have been processed and the
waiting time since the file has been placed on disk until it is scanned.

## Virus scanning process

### Incoming files

All files uploaded through Whitehall (including both attachment documents and
images) are asynchronously run through a virus scanner (ClamAV) before being
made available to view.  This process runs on the asset master
(`asset-master-1`).

The AV scan process is as follows:

1. Publisher uploads file, which gets written to a sub-directory within
   `/mnt/uploads/whitehall/incoming/`, with the full path based on the
   type of the upload and the ID of the edition being edited.
2. Every minute, a cron job runs as the `assets` user and triggers the
   [process-uploaded-attachments.sh](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/templates/node/s_asset_base/process-uploaded-attachments.sh.erb)
   script.
3. Each file currently found within the `incoming` directory is
   scanned using ClamAV via the
   [virus-scan-file.sh](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/files/node/s_asset_base/virus-scan-file.sh)
   script.
4. If the file is clean, it is moved to the `/mnt/uploads/whitehall/clean/`
   directory, and is then available for users to view. It also writes the file
   name to a list, which gets put into a temporary directory. If the file is
   found to have an infection, it is moved to the
   `/mnt/uploads/whitehall/infected` directory.
5. Independent to this process, another cronjob runs every minute and triggers
   the
   [copy-attachments-to-slaves](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/templates/node/s_asset_base/copy-attachments-to-slaves.sh.erb)
   script. This script copies each file found in the list (produced by the
   previous task) to each asset slave and an Amazon S3 bucket.

All scripts write to syslog, so you can check on the current processing as
follows:

    $ tail -f /var/log/syslog | grep "process_uploaded_attachment\|virus_scan\|copy_attachment"

### Detecting new viruses

A [separate script](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/files/node/s_asset_base/virus_scan.sh)
regularly rescans *all* the previously uploaded files in both clean and
draft-clean to catch any newly-released virus signatures.

The script is configured in cron to run every hour, but actually takes over 2
days to complete. It starts under a lock so that only one scan runs at a time.

## Quickly process a backlog of files awaiting AV scan

The AV scan process is currently quite slow (usually taking between 10-12
seconds per file), and we get a lot of files to check.  If there's a large
backlog, publishers can be waiting for hours for their files to be scanned.
You can scan everything in the backlog in one go as follows:

    $ find /mnt/uploads/whitehall/incoming -type f | xargs clamscan

This shouldn't take more than a minute, unless there's a huge (>500 files)
backlog.  The reason this is so much quicker than the per-file scan is that
we're only starting `clamscan` once, rather than once per file.

The output of that scan will tell you how many files are infected.  Assuming
they are all clean (`Infected files: 0`), you can make all these available
immediately by running:

    $ sudo -u assets rsync -rav /mnt/uploads/whitehall/incoming/* /mnt/uploads/whitehall/clean/

Note that this doesn't actually clear the queue: it simply shortcuts it.  Each
file will still be scanned individually, and then copied to the asset slaves
appropriately.  This means that any new uploads will still be at the back of
the queue.

In order to clear the queue, you can copy the files to a temporary directory:

    $ sudo -u assets rsync -rav /mnt/uploads/whitehall/incoming/* /mnt/uploads/whitehall/temp/

and then remove the files from `/mnt/uploads/whitehall/incoming/`, so that there's
a clean distinction between the files that have been copied and those that are
newly uploaded.  Next, scan the copied files manually:

    $ find /mnt/uploads/whitehall/temp -type f | xargs clamscan

Then, if they are all clean, copy to `/mnt/uploads/whitehall/clean/`:

    $ sudo -u assets rsync -rav /mnt/uploads/whitehall/temp/* /mnt/uploads/whitehall/clean/

Finally, remember to delete your temporary directory!

## Troubleshooting clamdscan

A good place to check for current clamav issues is the clamav [mailing list](http://lists.clamav.net/cgi-bin/mailman/listinfo). The [clamav users archive](http://lists.clamav.net/pipermail/clamav-users/) is probably going to be your first port of call.

We use clamdscan in [virus-scan-file.sh](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/files/node/s_asset_base/virus-scan-file.sh). This is a daemonised version of clamscan which helps speed up individual file scanning. You can run clamdscan against a single file:

```
clamdscan /path/to/file
```

### Lots of false positives

We have had an instance where clamdscan was erroring because of a bad signature. This ultimately caused [virus-scan-file.sh](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/files/node/s_asset_base/virus-scan-file.sh) script to exit with a non-null return value which meant we reported false positives.

### Checking the signature files

Clamav has a utility called freshclam that we use to download new virus signatures on a daily basis. The files are stored in `/var/lib/clamav`.

You can check the current version by doing the following:

```
cd /var/lib/clamav
sigtool --info daily.cld
```

### Whitelist

There is a "whitelist" file which contains signatures that should not be run by clamav. This file can be found at `/var/lib/clamav/whitelist.ign2`.

### Restarting clamav-daemon

The `clamav-daemon` should be running - you can find out by listing the services:

```
sudo service --status-all
```

If it is not running, you can start it with

```
sudo service clamav-daemon start
```
