---
owner_slack: "#govuk-2ndline-tech"
title: Check the TLS certificate is valid and not due to expire
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

These checks look at the validity of the TLS certificates for:

* www.gov.uk at the edge (Fastly)
* www.gov.uk at the origin (our servers)
* www.staging.publishing.service.gov.uk at the edge (Fastly)
* www.integration.publishing.service.gov.uk at the edge (Fastly)
* \*.publishing.service.gov.uk, \*.staging.publishing.service.gov.uk and \*.integration.publishing.service.gov.uk at the origin (our servers), depending on the environment Icinga is running in

The alert fires 30 days before certificate expiry.

See [renew a TLS certificate for GOV.UK](/manual/renew-a-tls-certificate.html).

## Production www.gov.uk certificate

The TLS certificate for www.gov.uk is managed by Fastly. If any additional
verification of domain ownership is needed for renewal (for example if Fastly
chooses a different outsourcing partner for its certification authority),
Fastly will open a support ticket with us. This ticket will go to 2nd-line Tech
Support, who should co-ordinate with Fastly to ensure that the certificate is
renewed.

## Production, staging and integration wildcard certificates

The wildcard TLS certificates for production, staging and integration are
automatically renewed by AWS. Renewal should require no human intervention
provided the DNS validation records remain in place.

## Staging and integration www certificates

The certificates for www.staging.publishing.service.gov.uk and
www.integration.publishing.service.gov.uk are automatically issued by Fastly.
Renewal should require no human intervention provided the DNS validation
records remain in place.
