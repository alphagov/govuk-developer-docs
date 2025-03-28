---
owner_slack: "#govuk-whitehall-experience-tech"
title: Whitehall error ratio too high
parent: "/manual.html"
layout: manual_layout
section: Monitoring and alerting
---

You can find the whitehall request rates, error rates, and durations on this dashboard:

- [Whitehall request rates, errors, durations][whitehall-grafana-red]

## Description

This alert will fire when the ratio of requests in an error state are above the threshold of 1 in 10.
The configuration of the alert can be found [here][whitehall-alert-config]

## Impact

Whitehall is used by civil servants in various departments. A high error rate usually indicates that
there's a problem affecting these users. For example, they may be unable to publish content or create drafts.

## Potential resolution steps

You may be able to see error reports in [Sentry][whitehall-sentry],
but occasionally errors are not captured there. In this case you might find more information in the logs
in [Kibana][whitehall-5xx-kibana].

- If whitehall has been recently deployed and is returning errors it may require a rollback using the [deploy github action][whitehall-deploy-gha].
- If whitehall is dealing with an increase in load it could be that you need to [scale up][scale-app].
- If the errors are due to API failures, it may be that one of whitehall's dependencies (e.g. publishing-api) is the root cause.

[whitehall-sentry]: https://govuk.sentry.io/projects/app-whitehall/?project=202259
[whitehall-5xx-kibana]: https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/data-explorer/discover?security_tenant=global#/view/5e567f40-0986-11f0-9c0a-936f45848bc3?_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow-6h%2Cto%3Anow))
[whitehall-deploy-gha]: https://github.com/alphagov/whitehall/actions/workflows/deploy.yml
[whitehall-grafana-red]: https://grafana.eks.production.govuk.digital/d/app-requests/app3a-request-rates-errors-durations?orgId=1&from=now-6h&to=now&timezone=browser&var-namespace=apps&var-app=whitehall-admin&var-error_status=$__all&refresh=1m
[whitehall-alert-config]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/whitehall.yaml
[scale-app]: /kubernetes/manage-app/scale-app/#scaling-your-app
