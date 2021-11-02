---
owner_slack: "#govuk-2ndline"
title: Renew a TLS certificate for GOV.UK
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

## Renewing the certificate for www.gov.uk

The TLS certificate for www.gov.uk is managed by Fastly. Fastly will open a support
ticket when the certificate is due for renewal. This ticket will be picked up by
GOV.UK Replatforming, who will co-ordinate with Fastly to renew the
certificate.

Note that the www.gov.uk certificate is not visible anywhere in the Fastly user
interface. It is managed entirely through Fastly support.

Renewing the certificate may require a TXT record on the `gov.uk` top level
domain. This is because the certificate contains a Subject Alternate Name (SAN)
of `DNS: gov.uk`. This TXT record needs to be requested through JISC following
the process for [DNS for the gov.uk top level domain](/manual/dns.html#dns-for-the-gov-uk-top-level-domain).

Credentials for the Fastly Zendesk support site are in the [2nd line password store](https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/fastly).

## Renewing wildcard certificates

Wilcard certificates for `*.publishing.service.gov.uk`, `*.staging.publishing.service.gov.uk`
and `*.integration.publishing.service.gov.uk` are managed by AWS ACM.

For AWS ACM to issue a certificate, you must prove ownership of the domain using DNS.
DNS for publishing.service.gov.uk is managed through [govuk-dns](https://github.com/alphagov/govuk-dns).

AWS ACM will provide a CNAME record for you to set, which you must add to [govuk-dns-config](https://github.com/alphagov/govuk-dns-config).
See [govuk-dns-config#398](https://github.com/alphagov/govuk-dns-config/pull/398) for an example.

Once you have deployed this DNS record, AWS should issue the certificate.

So long as the DNS record remains in place AWS can renew these certificates
automatically. You shouldn't need to do anything unless something goes wrong.

## Renewing Gandi certificates for third party services

Some certificates are still issued through Gandi (for example
signup.take-part-in-research.service.gov.uk).

If you need to renew one of these, first consider whether it could be issued
automatically using Fastly or AWS ACM (if the service is hosted on either, the
answer is probably "yes").

If you decide that renewing the certificate is the best available option, follow
this process:

1. [Generate a Certificate Signing Request (CSR)](generate-csr.html) for a
   *renewal*.
2. Log into Gandi [using the credentials in the infra password
   store](https://github.com/alphagov/govuk-secrets/blob/master/pass/infra/gandi/govuk.gpg).
3. Go to the account dashboard and find the list of TLS certificates on the
   account.
4. Find the certificate you wish to renew and click Renew.
5. Go through the steps on the renewal form until you reach a page requesting a
   Certificate Signing Request.
6. Upload the CSR to Gandi by pasting the contents of the .csr file into the
   text box.
7. Next, choose DNS validation to validate it and follow the instructions to add
   the relevant DNS records.
8. Pay for it - we don't have a stored payment method, so find the person with
   the GDS credit card. Or raise a request for temporary credit card details from
   PMO by sending an email to pmo@digital.cabinet-office.gov.uk.
9. Add the Certificate, Private Key, Certificate Signing Request and Intermediate Certificate
   to the [`2ndline` pass store](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline)
   under the `certificates` directory.
10. Import the certificate to the relevant infrastructure
