---
owner_slack: "#govuk-platform-engineering-team"
title: Rotate Fastly automation token for Emergency Alerts application
section: Emergency Alerts
layout: manual_layout
parent: "/manual.html"
---

> 🚧 This process should not be necessary unless a token has been compromised or lost.

GOV.UK Emergency Alerts has a Fastly account token for evicting objects from
the CDN cache. The token should not normally need to be changed. Under
exceptional circumstances it may be necessary to change the token, for example if
the token has been compromised.

Changing a Fastly automation tokens requires `superuser` access. Ask someone
from [govuk-platform-engineering@] or [govuk-senior-tech-members@] to do this for
you.

[govuk-platform-engineering@]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-platform-engineering/members
[govuk-senior-tech-members@]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-senior-tech-members/members

> It doesn't matter who creates the token, as long as they have superuser
> access. Any superuser can delete or rotate any API token in the GOV.UK Fastly
> account.

Follow these steps to revoke old tokens and issue new one.

> The new token will allow purge requests to the 3 Emergency Alerts services on
> Fastly and nothing else.
>
> Please do not create multiple tokens, even though this was done in the past.
> Having 3 separate tokens does not improve security in this case; it only
> creates toil.

1. Log into <https://manage.fastly.com/>.
1. Go to [Account tokens](https://manage.fastly.com/account/tokens).
1. Filter by the string "Emergency Alerts" to narrow down the list.
1. Delete any lost or compromised tokens by pressing the trash bin icon in the
   rightmost column.
1. Go to [API tokens](https://manage.fastly.com/account/personal/tokens).
1. Choose __Create Token__, near the top-right of the page. The UI may prompt
   you for your account password.
1. Under Type, choose __Automation token__. Do not create a User token.
1. Name the token `GOV.UK Emergency Alerts`.
1. Under Scope, tick the two Purge boxes: `purge_all` and `purge_select`.
   Ensure nothing else is ticked under the Scope heading.
1. Under Access, choose __One or more services__ and select `Production
   GOV.UK`, `Staging GOV.UK` and `Integration GOV.UK`, then choose Apply.
1. Under Expiration, choose __Never expire__. Do not set an expiry date.
1. Choose __Create Token__.
1. Copy the token and securely transfer it to the person from Emergency Alerts
   team who is requesting it. For example, calling the person via Google Meet
   and pasting it into the chat would be acceptable. Avoid sending the token by
   email or any communication tool that might leave lasting copies.

The person from Emergency Alerts team will then update the configuration in
their 3 AWS accounts: preview, staging and production. For each account, they
will need to:

1. Update `fastly-api-key` in SSM Parameter Store.
1. Find the `eas-app-govuk-alerts` service in `eas-app-cluster` in ECS.
1. Stop the running task within the `eas-app-govuk-alerts` dwiserviceapp. ECS
   will automatically start a new task with the new credentials.
1. Check that the key works by rebuilding the public alerts site for that
   environment. It will automatically rebuild after the container app restarts.
