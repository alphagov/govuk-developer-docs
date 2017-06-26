---
owner_slack: "#2ndline"
title: App isn't running the expected Ruby version
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/alerts/ruby-version.md"
last_reviewed_on: 2017-06-26
review_in: 6 months
---

We have checks to ensure that the version of Ruby the application is using is
the same as the version specified in its `.ruby-version` file.

The standard reload that happens when an application is deployed is not enough
to move between Ruby versions, so the application will continue to run under the
old version.

A hard restart of the application is required before the application will run
under the new version. You can do this by running the `app:hard_restart` deploy
task within the 'Deploy App' job in Jenkins.
