---
owner_slack: "@tijmen"
title: Monitor docs traffic
section: Manual
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-10-02
review_in: 6 months
---

This site is served by S3 via a [proxy defined in govuk-puppet][proxy].

You can inspect the traffic forwarded in [Kibana][kibana]. The data goes back a few weeks.

## All traffic

```rb
access.host:"docs.publishing.service.gov.uk"
```

## All 404s

```rb
access.host:"docs.publishing.service.gov.uk" AND access.status:404
```

## Particular page

```rb
access.host:"docs.publishing.service.gov.uk" AND access.request:"/manual/emergency-publishing.html"
```

[proxy]: https://github.com/alphagov/govuk-puppet/blob/d9f32be24890a47e0ed7368efccec7fb70ecab50/modules/govuk/manifests/node/s_backend_lb.pp#L132-L139
[kibana]: https://kibana.publishing.service.gov.uk/
