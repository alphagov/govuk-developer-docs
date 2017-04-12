---
title: 'Check we are not exceeding our AWS SES email quota'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# Check we are not exceeding our AWS SES email quota

There is not a lot we can do about this. Likely suspects for elevated
email volumes. - Application errors - cron errors - On integration and
staging this can be caused by data syncs - Can also be caused by
deploying lots of applications

Potential impacts include applications that send emails (such as signon)
not being able to do so. This issue should happen less often as we move
apps to Errbit.

