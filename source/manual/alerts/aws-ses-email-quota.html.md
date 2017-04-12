---
owner_slack: '#2ndline'
review_by: 2017-06-13
title: 'AWS SES quota usage higher than expected'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# AWS SES quota usage higher than expected

Likely suspect for elevated email volumes is Errbit emailing too much errors.

Other things that use the same SES account include Whitehall, Publisher, Signon, Licensing and machine email.

Hitting the quota may cause emails to not be delivered.
