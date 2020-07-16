---
owner_slack: "#govuk-2ndline"
title: ClamAV definitions out of date
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This could be because of a number of reasons. Check that the database is up to
date by [logging into a backend machine][] and calling the freshclam command directly with verbose:

```bash
$ gds govuk connect ssh -e production backend
$ freshclam -v
```

If it reports the virus databases are up to date then you may need to check the
[ClamAV virusdb archive][clamav-virusdb-archive] to investigate.

If it can't seem to download the updated definition files, with errors such as
`Ignoring mirror 130.59.113.36 (due to previous errors)`, it could be that all
the mirrors available have been blacklisted. You can reset the blacklisted
mirrors by deleting the file that stores them:

```bash
$ sudo rm /var/lib/clamav/mirrors.dat
```

After doing this, running `freshclam -v` as above may well work again.

[logging into a backend machine]: /manual/howto-ssh-to-machines.html
[clamav-virusdb-archive]: http://lists.clamav.net/pipermail/clamav-virusdb/
