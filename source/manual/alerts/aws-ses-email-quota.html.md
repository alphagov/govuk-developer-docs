---
owner_slack: "#2ndline"
title: AWS SES quota usage higher than expected
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-04-12
review_in: 6 months
---

Likely suspect for elevated email volumes is Errbit emailing too much errors.

Other things that use the same SES account include Whitehall, Publisher, Signon, Licensing and machine email.

Hitting the quota may cause emails to not be delivered.
