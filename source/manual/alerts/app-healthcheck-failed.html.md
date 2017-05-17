---
owner_slack: "#2ndline"
title: App healthcheck failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-05-17
review_in: 12 months
---

Every application on GOV.UK has a healthcheck endpoint. This is `/healthcheck` by default but can be overridden.

Icinga regularly checks the endpoint by making a GET request. If the
endpoint doesn't respond successfully, it triggers this alert.

To solve this issue, look at the logs of the application to see what
is wrong.
