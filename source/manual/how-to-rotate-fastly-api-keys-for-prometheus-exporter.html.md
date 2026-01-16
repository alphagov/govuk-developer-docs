---
owner_slack: "#govuk-platform-engineering-team"
title: Rotate Fastly automation token for Prometheus exporter
section: Monitoring and alerting
layout: manual_layout
parent: "/manual.html"
---

GOV.UK platform engineering has a Fastly account token for exporting Fastly metrics to Prometheus. The token is currently set to expire after a year.

Changing a Fastly automation tokens requires `superuser` access. Ask someone
from [govuk-platform-engineering@] or [govuk-senior-tech-members@] to do this for
you.

[govuk-platform-engineering@]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-platform-engineering/members
[govuk-senior-tech-members@]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-senior-tech-members/members

> It doesn't matter who creates the token, as long as they have superuser
> access. Any superuser can delete or rotate any API token in the GOV.UK Fastly
> account.

Follow these steps to revoke old tokens and issue new one.

> 3 new tokens will be created to allow access to metrics for Integration, Staging and Production.
>
> For the Integration environment follow these steps:

1. Log into <https://manage.fastly.com/>.
1. Go to [Account tokens](https://manage.fastly.com/account/tokens).
1. Filter by the string "prometheus-fastly-exporter token for Integration" to narrow down the list.
1. Delete the expiring tokens by pressing the trash bin icon in the
   rightmost column.
1. Go to [API tokens](https://manage.fastly.com/account/personal/tokens).
1. Choose __Create Token__, near the top-right of the page. The UI may prompt
   you for your account password.
1. Under Type, choose __Automation token__. Do not create a User token.
1. Name the token `GOV.UK prometheus-fastly-exporter token for Integration`.
1. Leave the default Scope as `global:read`.
   Ensure nothing else is ticked under the Scope heading.
1. Under Access, choose __One or more services__ and select all Services under the filter `Integration`.
1. Under Expiration, select 1 year after the current date.
1. Choose __Create Token__.
1. Copy the token and update the secret `govuk/fastly/api` in AWS secrets manager for the Integration environment.
1. In Argo CD select the `monitoring-config` application and click `Refresh` on the external secret for `fastly-exporter` to pick up the updated token.
1. Then select the `fastly-exporter` application and delete the running `fastly-exporter-prometheus` pod to trigger a deployment of a new `fastly-exporter-prometheus` to use the new token.
1. Check that the token is being used by clicking on `Logs` for the `fastly-exporter-prometheus` pod.
   If there are errors reported in the `Logs` it might be that the token hasn't been picked up properly so the external secret will need to be refreshed again and the `fastly-exporter-prometheus` pod re-deployed.
1. Finally, wait for a couple of minutes and then check that metrics from Fastly are being exported to Prometheus by browsing to [prometheus on Integration](https://prometheus.eks.integration.govuk.digital/query?g0.expr=fastly_rt_edge_total&g0.show_tree=0&g0.tab=table&g0.range_input=5m&g0.res_type=auto&g0.res_density=high&g0.display_mode=lines&g0.show_exemplars=0).
1. Repeat these steps for Staging and Production.
