---
owner_slack: "#govuk-notify-emergency-alerts"
title: What is GOV.UK Notify Emergency Alerts?
layout: manual_layout
type: learn
parent: "/manual.html"
section: Notify Emergency Alerts
important: true
---

The Cabinet Office and the Department for Digital, Culture, Media & Sport are developing a ‘cell broadcast’ alert system to enable people whose lives are at risk in an emergency to be rapidly contacted via their mobile phone. They are currently at the testing phase and subject to successful progress, hope to launch the service soon.

As part of this service, GOV.UK delegate serving [www.gov.uk/alerts](https://www.gov.uk/alerts) to the GOV.UK Notify team.

How does www.gov.uk/alerts work?
--------------------------------

We have a custom host in Fastly for /alerts which points at an AWS CloudFront CDN which is managed by the GOV.UK Notify team.

Requests to /alerts hit GOV.UK's CDN (Fastly), but no other bits of GOV.UK's infrastructure.

This custom host is set up to use [Fastly Shielding](https://docs.fastly.com/en/guides/shielding), which helps to
protect the Notify's origin servers from traffic spikes.

The setup of the custom host in Fastly is currently done by hand by the GOV.UK team.

API Keys
--------

Notify have three Fastly API keys with [`purge_select` scope](https://developer.fastly.com/reference/api/auth/#scopes), one for
integration, staging and production. These allow them to purge individual pages or surrogate keys from the cache. Note that the scope
of these keys is not restricted to `/alerts` - in principle they could be used to purge any page from the cache. We trust Notify to take
appropriate care with these credentials.

The API keys are not configured to expire, but it is good practice to rotate them regularly. The Notify team will instigate API key rotations,
see [Rotate Fastly API Keys for Notify Emergency Alerts](/manual/how-to-rotate-fastly-api-keys-for-notify-emergency-alerts.html).
