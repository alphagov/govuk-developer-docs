---
title: Domain Name System (DNS) records
section: infrastructure
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/dns.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/dns.md)


# Domain Name System (DNS) records

The GOV.UK Infrastructure team is responsible for managing lots of DNS records.

All DNS is managed in DynDNS using the `Cabinet-Office` account.

## Records for GOV.UK systems

There are a few domains that we use:

- `alphagov.co.uk` is the old domain name that GOV.UK publishing used to live on.
  We maintain records that point to Bouncer so that these URLs redirect.
- `publishing.service.gov.uk` and `govuk.service.gov.uk` are where GOV.UK lives. We
  should probably only have one of those.

## DNS for the `gov.uk` top level domain

[Jisc](https://www.jisc.ac.uk/) is a non-profit which provides networking to
UK education and government. They control the `gov.uk.` top-level domain.

Requests to modify the DNS records for `gov.uk.` should be sent by email
to `naming@ja.net`.

- `gov.uk.` is a top-level domain so it cannot contain a CNAME record
  (see [RFC 1912 section 2.4](https://tools.ietf.org/html/rfc1912#section-2.4) and the
  page on the [GOV.UK bare redirect](govuk_bare_redirect.html)).
  Instead, it contains A records that point to anycast IP addresses for our CDN provider.
- `www.gov.uk.` is a CNAME to `www-cdn.production.govuk.service.gov.uk.`, which means that we
  do not need to make a request to Jisc if we want to change CDN providers. Just change where
  the CNAME points to.

Generally, members of the infrastructure team have authority to email Jisc.

## Delegating `service.gov.uk` domains

At the moment we're also responsible for delegating DNS to other government services.

The request will arrive by email or Zendesk from a member of the GOV.UK Proposition
team.
The request will contain the service domain name that needs to be delegated and
more than one nameserver hostname (usually `ns0.example.com`, `ns1.example.com`).

In Dyn, create a new node for the service domain underneath `service.gov.uk`
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
