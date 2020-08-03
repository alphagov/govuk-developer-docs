---
owner_slack: "#govuk-2ndline"
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

You'll start seeing an alert 30 days before the relevant certificate is due to
expire.

See [renew a TLS certificate for GOV.UK](/manual/renew-a-tls-certificate.html)
for details of how to renew the relevant certificate. This is normally done by
Reliability Engineering.

## Production www.gov.uk certificate

The TLS certificate for www.gov.uk is managed by Fastly. They will open a support
ticket when the certificate is due for renewal. This ticket will be picked up by
Reliability Engineering, who will co-ordinate with Fastly to renew the
certificate.

## Production, staging and integration wildcard certificates

The wildcard TLS certificates for production, staging and integration are
managed by Reliability Engineering. Once the alert appears, they will work to
renew the relevant certificate and make it live. For staging and integration,
the certificates are also provided to Fastly to enable TLS for our staging and
integration CDN environments.
