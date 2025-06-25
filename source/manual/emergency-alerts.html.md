---
owner_slack: "#emergency-alerts"
title: What is GOV.UK Emergency Alerts?
layout: manual_layout
type: learn
parent: "/manual.html"
section: Emergency Alerts
important: true
---

The Cabinet Office [COBR](https://www.instituteforgovernment.org.uk/explainer/cobr-cobra) Unit and the Department for Science, Innovation and Technology have developed an emergency alert system to enable people whose lives are at risk in an emergency to be rapidly contacted via their mobile phone. It is currently in the trial phase following a successful national test message. It was originally developed by the GOV.UK Notify team and is now managed and maintained by the GOV.UK Emergency Alerts team.

As part of this service, GOV.UK delegate serving [www.gov.uk/alerts](https://www.gov.uk/alerts) to the GOV.UK Emergency Alerts team.

## How does www.gov.uk/alerts work?

We have a custom host in Fastly for /alerts which points at an AWS CloudFront CDN which is managed by the GOV.UK Emergency Alerts team. Each GOV.UK environment points at a different custom host:

- [Fastly's Integration configuration](https://manage.fastly.com/configure/services/4mENG6RJL8sxnvgPUMRDz2/versions/275/origins) points at Emergency Alerts Preview environment;
- [Fastly's Staging configuration](https://manage.fastly.com/configure/services/13QQKEZBSrBFyfxYGzjHPZ/versions/854/origins) points at Emergency Alerts Staging environment; and
- [Fastly's Production configuration](https://manage.fastly.com/configure/services/4b340CyOhAgINR9eKMH83h/versions/549/origins) points at Emergency Alerts Production environment.

Requests to /alerts (or to anything beginning with `/alerts/`) hit GOV.UK's CDN (Fastly), but no other bits of GOV.UK's infrastructure.

This is configured in govuk-fastly, by [dynamically selecting the backend](https://github.com/alphagov/govuk-fastly/blob/ffd54b5c495a6daad6f6a774d53296924cb4e784/modules/www/service.tf#L70-L73) from the [list of backends in govuk-fastly-secrets](https://github.com/alphagov/govuk-fastly-secrets/blob/fbf5333dafdca0250d67c043b15750a6b160de6a/secrets.yaml#L58-L61).

We [only have one backend](https://github.com/alphagov/govuk-fastly-secrets/blob/fbf5333dafdca0250d67c043b15750a6b160de6a/secrets.yaml#L58-L61), at the time of writing. Backends have [POP shield enabled by default](https://github.com/alphagov/govuk-fastly/blob/ffd54b5c495a6daad6f6a774d53296924cb4e784/modules/www/service.tf#L83).

In production, Fastly is [configured](https://github.com/alphagov/govuk-fastly-secrets/pull/62) to forward logs for `/alerts` to an S3 bucket owned by the Emergency Alerts team. This is done via an IAM role, so no secrets are maintained by us.

## Fastly automation token for cache purge

The Emergency Alerts team has a Fastly automation token which allows their
application to invalidate objects in the Fastly CDN cache for www.gov.uk.

This purge token should not normally need to be changed. In rare circumstances
the Emergency Alerts team may need us to reissue a token, for example if a
token has been lost or compromised. See [Rotate Fastly automation token for
Emergency Alerts
application](/manual/how-to-rotate-fastly-api-keys-for-emergency-alerts.html).
