---
owner_slack: "#govuk-2ndline"
title: Unable to SSH into a machine
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

If you are on the VPN and you are unable to connect to an instance (it hangs and then
eventually fails with `kex_exchange_identification: Connection closed by remote host`),
then the instance is unhealthy. There are probably a number of alerts associated with
the instance too.

You'll need to sign into AWS and [reprovision the instance](/manual/reprovision.html).
You may want to click the "Report instance status" button while you're there, to inform
AWS that the instance is unresponsive - this should help AWS to improve their automated
checks in the future.
