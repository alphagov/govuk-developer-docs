---
owner_slack: "#govuk-2ndline"
title: Domain Name System (DNS) records
section: DNS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-05-13
review_in: 6 months
---

The Reliability Engineering team is responsible for managing several DNS zones.

By default, zones are managed using DynDNS.

The following zones use both DynDNS and Amazon Route 53 as dual providers:

- digital.cabinet-office.gov.uk.
- govuk.service.gov.uk.
- performance.service.gov.uk.
- service.gov.uk.

The following use Route 53 and Google Cloud DNS:

- publishing.service.gov.uk

**If zones are managed with two providers, then both sets of records must be updated
in both providers**

## DynDNS

Use the `Cabinet-Office` account. Once you have a Dyn ID, you can login [here](https://manage.dynect.net/login/).

## Amazon Route 53

Use the "production" account. Speak to Infrastructure if you require access.

## Google Cloud DNS

Use the "production" account. Speak to Infrastructure if you require access.

## Records for GOV.UK systems

There are a few domains that we use:

- `alphagov.co.uk` is the old domain name that GOV.UK publishing used to live on.
  We maintain records that point to Bouncer so that these URLs redirect.
- `publishing.service.gov.uk` and `govuk.service.gov.uk` are where GOV.UK lives.

## Making changes to publishing.service.gov.uk

We use a Jenkins job that publishes changes to publishing.service.gov.uk. The
job uses [Terraform](https://www.terraform.io/) and pushes changes to the
selected provider.

To make a change to this zone, begin by adding the records to the yaml file for
the zone held in the [DNS config repo](https://github.com/alphagov/govuk-dns-config).

When this has been reviewed and merged, you can deploy the changes using [the
"Deploy DNS "Jenkins job](https://deploy.publishing.service.gov.uk/job/Deploy_DNS/).

Changes should be deployed for each provider separately, and you should first
run a "plan", and when you're happy with the changes, run "apply".

Please note that due to the Terraform state being held in an S3 bucket, you
will require access to the GOVUK AWS "production" account to roll changes for
both Amazon and Google.

You will not require credentials for Google Cloud. These credentials are stored
in Jenkins itself.

## DNS for the `gov.uk` top level domain

[Jisc](https://www.jisc.ac.uk/) is a non-profit which provides networking to
UK education and government. They control the `gov.uk.` top-level domain.

Requests to modify the DNS records for `gov.uk.` should be sent by email to
`naming@ja.net` from someone on Jisc's approved contacts list. Speak to a
senior technologist member of GOV.UK or Reliability Engineering if you need to
make a change and don't have access.

2nd line should be notified of any planned changes via email.

- `gov.uk.` is a top-level domain so it cannot contain a CNAME record
  (see [RFC 1912 section 2.4](https://tools.ietf.org/html/rfc1912#section-2.4) and the
  page on the [GOV.UK bare redirect](govuk_bare_redirect.html)).
  Instead, it contains A records that point to anycast IP addresses for our CDN provider.
- `www.gov.uk.` is a CNAME to `www-cdn.production.govuk.service.gov.uk.`, which means that we
  do not need to make a request to Jisc if we want to change CDN providers. Just change where
  the CNAME points to.

## Delegating `service.gov.uk` domains

At the moment Reliability Engineering are also responsible for delegating DNS
to other government services.

The request will arrive by email or Zendesk from a member of the GOV.UK Proposition
team.
The request will contain the service domain name that needs to be delegated and
more than one nameserver hostname (usually `ns0.example.com`, `ns1.example.com`).

In both Dyn and Route 53, create a new node for the service domain underneath `service.gov.uk`
and add `NS` records for that node.

We __do not__ manage DNS for service domains. If you get a request asking you to add
anything other than `NS` records, it should be rejected. This is so that we're not
the single point of DNS for government.

There are ongoing plans to move this responsibility to a different part of GDS.

### Delegating DNS to other Dyn customers

Dyn support say this about delegating DNS to other Dyn customers:

> In order to delegate a subdomain to another Dyn Customer, you will also need
> to create the subdomain as a Child Zone within your account. Once this is created,
> we can then transfer the Child Zone into the Ministry of Magic account.

> If the Ministry of Magic had attempted to create this zone within their
> account manually, it will give them an error stating that the
> 'Parent Zone exists within another account'.

Follow these steps:

- Open a ticket with Dyn support with the name of the domain to transfer
- Create a new zone in our Dyn account for the subdomain
- Create a TXT record on the zone: `Case 000001234 with Dyn support - delegate to Ministry of Magic`

In order to revoke a domain that's been delegated in this way, open a ticket
with Dyn. As we have control over the parent domain they should be happy to
reverse the delegation.

## Other weird bits of DNS

If you receive a request to change any other DNS that hasn't come from the GOV.UK
Proposition team, send it to them using the Zendesk group "3rd Line--GOV.UK Proposition".
