---
owner_slack: "#govuk-2ndline"
title: "Stop all email subscription sending"
section: Emails
layout: manual_layout
parent: "/manual.html"
---

In an emergency, the following steps will immediately stop all emails being sent
by the GOV.UK email subscription system.

> **WARNING**
>
> This is an emergency stopgap solution that should be reverted as soon as
> possible. All emails (including urgent ones such as travel alerts) will not be
> sent while this is active.
>
> **Note**
>
> Emails already sent to GOV.UK Notify for delivery cannot be stopped by this
> method.

1. Ensure your [fabric scripts][fabric-scripts] are set up.
1. Run `fab $environment class:email_alert_api puppet.disable:"Disabling email
   subscriptions"` to disable puppet (otherwise the next step will be undone the
   next time puppet runs).
1. Run `fab $environment class:email_alert_api app.stop:email-alert-api-procfile-worker`
  to stop the email-alert-api Sidekiq workers.

[fabric-scripts]: https://github.com/alphagov/fabric-scripts/
