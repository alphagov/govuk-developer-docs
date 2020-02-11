---
owner_slack: "#govuk-2ndline"
title: Restrict PaaS applications to GDS office IPs
parent: /manual.html
layout: manual_layout
section: PaaS
last_reviewed_on: 2020-02-06
review_in: 6 months
---
When deploying applications to the PaaS, it is possible to limit access to the application to GDS office IPs only.

You need to create your application on the PaaS and then bind the route to the [GOV.UK PaaS Office IP route service](https://github.com/alphagov/govuk-paas-office-ip-router). The route service safelists GDS office IPs and will pass requests from office IPs through to your application on the PaaS.

To bind the route to your application to the route service, do the following:

```
cf bind-route-service cloudapps.digital govuk-paas-office-ip-route-service --hostname APP_NAME
```

Comprehensive documentation can be found in the [PaaS tech docs](https://docs.cloud.service.gov.uk/deploying_services/route_services/#example-route-service-to-add-ip-address-authentication).
