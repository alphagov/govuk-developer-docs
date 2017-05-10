---
owner_slack: "#2ndline"
title: ClamAV definitions out of date
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-03-26
review_in: 6 months
---

This could be because of a number of reasons. Check that the database is
up to date by calling the freshclam command directly with verbose:

    fab $environment -H asset-master-1.backend sdo:'freshclam -v'

If it reports the virus databases are up to date then you may need to
check the [ClamAV virusdb
archive](http://lists.clamav.net/pipermail/clamav-virusdb/) to
investigate.

