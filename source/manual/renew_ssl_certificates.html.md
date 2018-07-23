---
owner_slack: "#govuk-2ndline"
title: Renewing an SSL certificate for GOV.UK
section: Environments
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-04
review_in: 6 months
---

We use SSL on GOV.UK. This documentation covers how to renew wildcard SSL
certificates for `publishing.service.gov.uk` and the `integration` and `staging`
subdomains. It is a task performed by Reliability Engineering.

## Where these are bought from

GOV.UK's SSL certificates are bought from Gandi. There are credentials for the
`govuk` account in the infra password store.

## How to renew

1. Log into Gandi [using the credentials in the infra password
   store](https://github.com/alphagov/govuk-secrets/blob/master/pass/infra/gandi/govuk.gpg).
2. Go to the account dashboard and find the list of SSL certificates on the
   account.
3. Find the certificate you wish to renew and click Renew. You'll want to
   request a wildcard certificate (`*.publishing.service.gov.uk`, for example).
4. Go through the steps on the renewal form until you reach a page requesting a
   Certificate Signing Request.
5. [Generate a Certificate Signing Request
   (CSR)](source/manual/generate-csr.html.md) for a *renewal*.
6. Upload the CSR to Gandi by pasting the contents of the .csr file into the
   text box.
7. Next, choose DNS validation to validate it.
8. Pay for it - we don't have a stored payment method, so find the person with
   the GOV.UK credit card.
