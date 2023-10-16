---
owner_slack: "#govuk-2ndline-tech"
title: Router error ratio too high
parent: "/manual.html"
layout: manual_layout
section: Pagerduty alerts
---

You can find the router request error rates on this dashboard:

- [5xx Router Requests](https://grafana.eks.production.govuk.digital/d/router-requests/router-request-rates-errors-durations)

You can also view the 500+503 error rates across all applications on this dashboard:

- [5xx app Requests][app-5xx-error-rates-grafana]

## Description

This alert will fire when the ratio of requests in an error state are above the threshold of 1 in 10.
The configuration of the alert can be found [here](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/router.yaml)

## Impact

Router deals with requests to the rails applications which means that both publishers and/or end users could be seeing errors depending on which application is returning errors.
Use [this][app-5xx-error-rates-grafana] dashboard to check which applications have been erroring recently then look in [Kibana][prod-kibana] for more detailed look into the specific log messages.

## Potential resolution steps

- If an application has been recently updated and is returning errors it may require a rollback using the app's deploy github action `https://github.com/alphagov/<appname>/actions/workflows/deploy.yml`
- If your application is currently dealing with a sudden increase in load it could be that you need to scale your application. You can check the following [documentation][scale-app] in order to do this.

[router-5xx-request-rates-grafana]: https://grafana.eks.integration.govuk.digital/d/router-requests/router-request-rates-errors-durations?orgId=1&var-namespace=apps&var-backend_app=All&var-quantile=0.99&var-error_status=500&var-error_status=503&var-error_status=504
[app-5xx-error-rates-grafana]: https://grafana.eks.production.govuk.digital/d/app-requests/app-request-rates-errors-durations?orgId=1&refresh=1m&var-namespace=apps&var-app=All&var-quantile=All&var-error_status=500&var-error_status=503
[prod-kibana]: https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/discover
[scale-app]: /kubernetes/manage-app/scale-app/#scaling-your-app
