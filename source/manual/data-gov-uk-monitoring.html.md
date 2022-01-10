---
owner_slack: "#govuk-datagovuk"
title: Monitor data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---
[publish]: repos/datagovuk_publish
[operating-dgu]: /manual/data-gov-uk-operations.html
[find]: repos/datagovuk_find
[sentry]: https://sentry.io/govuk/
[logit-paas]: https://docs.cloud.service.gov.uk/#set-up-the-logit-io-log-management-service
[logit]: https://logit.io/a/1c6b2316-16e2-4ca5-a3df-ff18631b0e74
[google-analytics]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/information-management/use-online-tools-in-gds/use-google-analytics
[pagerduty]: https://govuk.pagerduty.com/
[Pingdom]: /manual/pingdom.html
[ckan]: repos/ckanext-datagovuk

## Pingdom

[Pingdom] monitors `https://data.gov.uk` uptime and alerts [PagerDuty] when downtime is detected. Maintenace of this service forms part of `#govuk-2nd-line`.

## Sentry

[Sentry] monitors application errors. The Sentry pages for each app can be found on the [Find] and [Publish] app pages.

## Log.it

Each application sends logs to [Logit]. [Publish] and [Find] use the corresponding [PaaS Service][logit-paas]. Example query: `source_host: "gds-data-gov-uk.data-gov-uk.find-data-beta" && access.response_code: 500`.

## Sidekiq ([Publish])

You can monitor the number of jobs in each queue using the following.

First, follow the instructions on [logging into the paas][operating-dgu]

```
cf ssh publish-data-beta-production-worker
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
>>> Sidekiq::Queue.new.each_with_object(Hash.new(0)) {|j, h| h[j.klass] += 1 }
```

## Analytics

[Google Analytics][google-analytics] records traffic for [Find]. Ask for 'read' access to all 'properties' in your request.
