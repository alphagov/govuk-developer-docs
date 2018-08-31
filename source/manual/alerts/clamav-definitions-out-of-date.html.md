---
owner_slack: "#govuk-2ndline"
title: ClamAV definitions out of date
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

This could be because of a number of reasons. Check that the database is
up to date by calling the freshclam command directly with verbose:

    fab $environment -H asset-master-1.backend sdo:'freshclam -v'

If it reports the virus databases are up to date then you may need to
check the [ClamAV virusdb
archive](http://lists.clamav.net/pipermail/clamav-virusdb/) to
investigate.

If it can't seem to download the updated definition files, with errors
such as `Ignoring mirror 130.59.113.36 (due to previous errors)`, it
could be that all the mirrors available have been blacklisted. You
can reset the blacklisted mirrors by deleting the file that stores
them: `sudo rm /var/lib/clamav/mirrors.dat`. After doing this running
`sudo freshclam -v` may well work again.
