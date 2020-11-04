---
owner_slack: "#govuk-2ndline"
title: Established connections exceed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert triggers when the number of established connections to a
port exceeds a certain number. This can be configured for specific
applications, but the default relates to the number of Unicorn worker
processes if this is configured, or 2 if it's not. This is because
Unicorn can only handle as many concurrent connections as it has
workers.

If this alert is firing, it can suggest that requests are coming in to
the application faster than it can handle, and they're beginning to
back up. This is bad, as it means that the requests will be slower, as
the application wasn't able to start processing it immediately.

If you're seeing this alert regularly for an app and the machine it's on has
enough memory to cope with more workers then you can increase this amount via
puppet. An example of increasing the unicorn workers for an app can be
found [here](https://github.com/alphagov/govuk-puppet/pull/9831).
