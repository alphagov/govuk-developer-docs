---
owner_slack: "#govuk-notify-emergency-alerts"
title: What is GOV.UK Notify Emergency Alerts?
layout: manual_layout
type: learn
parent: "/manual.html"
section: Notify Emergency Alerts
important: true
---

# What is GOV.UK Notify Emergency Alerts?

The Cabinet Office and the Department for Digital, Culture, Media & Sport are developing a ‘cell broadcast’ alert system to enable people whose lives are at risk in an emergency to be rapidly contacted via their mobile phone. They are currently at the testing phase and subject to successful progress, hope to launch the service soon.

As part of this service, GOV.UK delegate serving [www.gov.uk/alerts](https://www.gov.uk/alerts) to the GOV.UK Notify team.

How does www.gov.uk/alerts work?
--------------------------------

We have a custom host in Fastly for /alerts which points at an AWS CloudFront CDN which is managed by the GOV.UK Notify team. Each GOV.UK environment points at a different custom host:

- [Fastly's Integration configuration](https://manage.fastly.com/configure/services/4mENG6RJL8sxnvgPUMRDz2/versions/275/origins) points at Notify's Preview environment;
- [Fastly's Staging configuration](https://manage.fastly.com/configure/services/13QQKEZBSrBFyfxYGzjHPZ/versions/854/origins) points at Notify's Staging environment; and
- [Fastly's Production configuration](https://manage.fastly.com/configure/services/4b340CyOhAgINR9eKMH83h/versions/549/origins) points at Notify's Production environment.

Requests to /alerts (or to anything beginning with `/alerts/`) hit GOV.UK's CDN (Fastly), but no other bits of GOV.UK's infrastructure.

This custom host is set up to use [Fastly Shielding](https://docs.fastly.com/en/guides/shielding), which helps to
protect the Notify's origin servers from traffic spikes.

The setup of the custom host in Fastly is currently done by hand by the GOV.UK team.
Whilst VCL is usually overwritten when deploying govuk-cdn-config, these particular changes are
[automatically merged with the govuk-cdn-config VCL](https://github.com/alphagov/govuk-cdn-config/pull/321) so that they persist.

API Keys
--------

Notify have three Fastly API keys with [`purge_select` scope](https://developer.fastly.com/reference/api/auth/#scopes), one for
integration, staging and production. These allow them to purge individual pages or surrogate keys from the cache. Note that the scope
of these keys is not restricted to `/alerts` - in principle they could be used to purge any page from the cache. We trust Notify to take
appropriate care with these credentials.

The API keys are not configured to expire, but it is good practice to rotate them regularly. The Notify team will instigate API key rotations,
see [Rotate Fastly API Keys for Notify Emergency Alerts](/manual/how-to-rotate-fastly-api-keys-for-notify-emergency-alerts.html).
