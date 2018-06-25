---
owner_slack: "#govuk-2ndline"
title: AWS SES quota usage higher than expected
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-06-25
review_in: 6 months
---

Applications using this SES account include:

* [Whitehall][] and [Publisher][]: publish notifications to editors, and
  fact-check requests.
* [Signon][]: account suspension and 2FA setup notifications.

Hitting the quota may cause emails to not be delivered.

[Whitehall]: /apps/whitehall.html
[Publisher]: /apps/publisher.html
[Signon]: /apps/signon.html
