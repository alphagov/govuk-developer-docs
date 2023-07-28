---
owner_slack: "#govuk-2ndline-tech"
title: Renew a TLS certificate for GOV.UK
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

## Renewing the certificate for www.gov.uk

The TLS certificate for www.gov.uk is managed by Fastly. If there is any action
needed by us, for example if the requirement for verifying that we own the
domain have changed, then Fastly will open a support ticket with us. This
ticket will be routed to Technical 2nd-line support, who should coordinate with
Fastly to ensure that the certificate is renewed in good time.

> The www.gov.uk certificate does not appear in manage.fastly.com, even though
> Fastly manages it for us.

Occasionally, Fastly might need us to add or update a DNS record directly
underneath the `gov.uk` domain, in order for their supplier to validate our
ownership of the domain. If this happens, you will need to [open a ticket with
Jisc](/manual/dns.html#dns-for-the-gov-uk-top-level-domain), who manage the
`gov.uk.` DNS zone.

Credentials for the Fastly Zendesk support site are in the [Technical 2nd Line password store](https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/fastly).

## Renewing publishing.service.gov.uk wildcard certificates

Wildcard certificates for `*.publishing.service.gov.uk`, `*.staging.publishing.service.gov.uk`
and `*.integration.publishing.service.gov.uk` are issued by AWS Certificate
Manager (ACM) and should renew automatically.

ACM relies on a validation DNS record being present in order to prove that we
own the domain. If an ACM-managed certificate is nearing its expiry date, check
the status of the certificate under ACM in the AWS web console to see whether
ACM was able to validate the domain.

As long as the validation DNS record remains in place, AWS will renew these
certificates automatically. You shouldn't need to do anything unless something
goes wrong with the validation records.

## Renewing legacy Gandi certificates

You might come across a legacy certificate which is still issued through Gandi
(for example signup.take-part-in-research.service.gov.uk).

If you need to renew one of these, first consider whether you could use
Fastly or AWS to issue the certificate so that future renewals are automatic.
If the service is hosted on either, the answer is probably "yes".

If the service is hosted by an external supplier, that supplier should be
responsible for obtaining a certificate, even if we might have done this for
them in the past. Talk with whoever owns the relationship with the supplier in
order to resolve this. Platform Security and Reliability team can help you with
this if necessary.

⚠️  **Never transfer a private key outside the system it was generated on.**
(This is why CSRs exist, and also why services such as AWS Certificate Manager
won't let you see private keys that they generate for you.) If you're unsure
how to avoid the need to send someone a private key, talk to Platform Security
and Reliability team and they will help you find a secure alternative.

To renew a Gandi certificate, if it's absolutely necessary:

1. [Generate a Certificate Signing Request (CSR)](generate-csr.html) for a
   *renewal*. The private key *must* be generated on the infrastructure which
   will ultimately host the certificate. If the certificate is for a
   third-party supplier, they must generate the CSR and send it to you. The
   private key must never leave the hosting environment.
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
