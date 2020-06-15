---
owner_slack: "#govuk-developers"
title: Deploy Static
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

[Static](https://github.com/alphagov/static) requires extra care when deploying.
You must wait for at least 30 minutes between environment deploys. This is
because Static is consumed directly by GOV.UK applications at runtime - not a
gem version like a normal dependency - and responses from Static are cached for
half an hour, so problems may not be visible until after this period.

There are instructions in the release app UI to remind you.
