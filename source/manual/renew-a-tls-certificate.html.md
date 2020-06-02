---
owner_slack: "#re-govuk"
title: Renew a TLS certificate for GOV.UK
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-06-02
review_in: 6 months
---

This document covers how to renew wildcard TLS certificates for
`*.publishing.service.gov.uk`, `*.staging.publishing.service.gov.uk`
and `*.integration.publishing.service.gov.uk`. It is a task performed
by Reliability Engineering.

Credentials for the Fastly dashboard and Zendesk support sites are in the
[2nd line password store](https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/fastly).

1. Log into Gandi [using the credentials in the infra password
   store](https://github.com/alphagov/govuk-secrets/blob/master/pass/infra/gandi/govuk.gpg).
2. Go to the account dashboard and find the list of TLS certificates on the
   account.
3. Find the certificate you wish to renew and click Renew. You need to
   request a wildcard certificate (for example, `*.publishing.service.gov.uk`).
4. Go through the steps on the renewal form until you reach a page requesting a
   Certificate Signing Request.
5. [Generate a Certificate Signing Request (CSR)](generate-csr.html) for a
   *renewal*.
6. Upload the CSR to Gandi by pasting the contents of the .csr file into the
   text box.
7. Next, choose DNS validation to validate it and follow the instructions to add
   the relevant DNS records.
8. Pay for it - we don't have a stored payment method, so find the person with
   the GDS credit card.
9. Once the certificate has been renewed, paste the contents of the resulting
   .crt file into Puppet hiera data for the relevant environment in the
   [govuk-secrets](https://github.com/alphagov/govuk-secrets) repository.
10. Deploy Puppet to update the certificate in the relevant environment.
11. *For staging and integration only:*
    Go to the Fastly interface and then to Configure -> HTTPS and network.
    Go to TLS certificates and upload your new cert.
12. *For staging and integration only:*
    In TLS domains click on more details and then select your new certificate
    under CERTIFICATE BEING USED.
