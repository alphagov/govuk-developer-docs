---
owner_slack: "#2ndline"
title: App isn't running the expected Ruby version
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/alerts/ruby-version.md"
last_reviewed_on: 2016-12-24
review_in: 6 months
---

> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/alerts/ruby-version.md)


When a `.ruby-version` file is updated, a standard app reload won't pick
up the change, and the application will be left running under the old
version of Ruby. A full restart of the application is required to pick
up the new version.

We have checks to ensure that the version of Ruby the app is using is
the same as the version specified in the repo.
