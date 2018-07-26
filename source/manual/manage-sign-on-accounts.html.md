---
owner_slack: "#govuk-2ndline"
title: Manage Signon accounts
section: Support
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-26
review_in: 6 months
---

[Signon](https://github.com/alphagov/signon) is the Single sign-on service for our admin applications.

## Production, Staging, Integration

User accounts from production are synced to staging every morning, so any
changes made in production will be reflected in staging the next day.

User accounts in integration are completely separate.

## Creating accounts

User accounts should normally be created by the tech lead on the user's team -
in usual circumstances 2nd line should not have to do this.

However, if the tech lead does not have admin access either, you can change this
through the users section in the signon app:

- [integration signon](https://signon.integration.publishing.service.gov.uk/users)
- [staging signon](https://signon.staging.publishing.service.gov.uk/users)
- [production signon](https://signon.publishing.service.gov.uk/users)
