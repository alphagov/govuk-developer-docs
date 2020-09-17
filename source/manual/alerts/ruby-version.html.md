---
owner_slack: "#govuk-2ndline"
title: App isn't running the expected Ruby version
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

We have checks to ensure that the version of Ruby the application is using is
the same as the version specified in its `.ruby-version` file.

The standard reload that happens when an application is deployed is not enough
to move between Ruby versions, so the application will continue to run under
the old version.

A hard restart of the application is required before the application will run
under the new version. You can do this by running the `app:hard_restart` deploy
task within the 'Deploy App' job in Jenkins.
