---
owner_slack: "#govuk-2ndline-tech"
title: Domain Name System (DNS) records
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

> For **Technical 2nd Line documentation** on when and how to respond to DNS delegation and domain verification requests, read the [DNS change request and hostmaster Google doc](https://drive.google.com/drive/search?q=-%20type:document%20title:%22Tech%202nd%20Line%20-%20Handle%20Tickets%20on%20DNS%20Change%20request%20hostmaster%40%22).

GOV.UK is responsible for managing several DNS zones, spanning a number of `*.gov.uk` domains. As of February 2024, there are 45 hosted zones, configuring many hundreds of domains. A list of hosted zones is retrievable from a terminal using:

```sh
gds aws govuk-production-poweruser -- aws route53 list-hosted-zones | grep Name
```

## Overview of GOV.UK domains

GOV.UK is responsible for more than just the `www.gov.uk` domain.
The [GOV.UK proposition](https://www.gov.uk/government/publications/govuk-proposition/govuk-proposition#what-the-govuk-proposition-covers) lists the domains we're responsible for. These are:

- www.gov.uk
- service.gov.uk
- data.gov.uk
- blog.gov.uk
- campaign.gov.uk
- independent.gov.uk
- api.gov.uk

There are lots of other `*.gov.uk` domains, such as `cityoflondon.gov.uk`, which are managed by Cabinet Office.

In theory, the GOV.UK proposition domains should all be managed by GDS (who use [Jisc](https://www.jisc.ac.uk/): a non-profit that provides networking to UK education and government). In practice, a couple of GOV.UK proposition domains are managed by Cabinet Office, and a couple of non-proposition domains are in the Government Digital Service Jisc account. [This is being looked at](https://trello.com/c/qNpyVaC5/3228-consolidate-co-vs-non-co-domains-in-govuks-jisc-account) by Platform Security & Reliability.

In most cases, DNS zones are hosted by both AWS (Route 53) and Google Cloud Platform (Cloud DNS). See [Amazon Route53 vs Google Cloud in the govuk-dns-tf README](https://github.com/alphagov/govuk-dns-tf#amazon-route53-vs-google-cloud)

### The `gov.uk` domain

This domain is currently administered by Cabinet Office. `gov.uk.` is an apex domain so it [cannot have a CNAME record](https://tools.ietf.org/html/rfc1912#section-2.4). Instead, it has A records that point directly to Fastly virtual IP addresses, resolving to the [Production TLD Redirect](https://manage.fastly.com/configure/services/7IaQm6UK3NiQu0v0E83YKn) Fastly service, which performs a redirect to `www.gov.uk`.

### The `www.gov.uk` domain

This domain is currently administered by Cabinet Office.

`www.gov.uk.` is a CNAME to `www-cdn.production.govuk.service.gov.uk.`, which ultimately points to `www-gov-uk.map.fastly.net.` (configured [via govuk-dns-tf](https://github.com/alphagov/govuk-dns-tf/blob/8fa490bce3d9272e6df69f4dbcb1c1be1b3f07c2/zones/govuk.service.gov.uk.yaml#L45-L48)). This resolves to the [Production GOV.UK](https://manage.fastly.com/configure/services/4b340CyOhAgINR9eKMH83h/versions/549/origins) Fastly service.

### The `service.gov.uk` domain

This is managed in the Government Digital Service Jisc account.

The `service.gov.uk` domain has [A records](https://github.com/alphagov/govuk-dns-tf/blob/e00ae516f9ae6265ca186581a1e74319372d2677/zones/service.gov.uk.yaml#L3-L10) pointing to Fastly's virtual IP addresses.

We've configured [several hundred subdomains of the `service.gov.uk` domain](https://github.com/alphagov/govuk-dns-tf/blob/e00ae516f9ae6265ca186581a1e74319372d2677/zones/service.gov.uk.yaml).

An important one we've configured is `publishing.service.gov.uk`, which is [delegated to a set of NS records](https://github.com/alphagov/govuk-dns-tf/blob/e00ae516f9ae6265ca186581a1e74319372d2677/zones/service.gov.uk.yaml#L1679-L1687) in GOV.UK's AWS account. Subdomains of this are configured in [`publishing.service.gov.uk.yaml` in govuk-dns-tf](https://github.com/alphagov/govuk-dns-tf/blob/cd833c896bbebb90aa691372486f35e6663928e6/zones/publishing.service.gov.uk.yaml).

### The `data.gov.uk` domain

This is managed in the Government Digital Service Jisc account.

The `data.gov.uk` domain has [A records](https://github.com/alphagov/govuk-dns-tf/blob/f21d1f9dfde8470981e2fc79a63538753f2e25f8/zones/data.gov.uk.yaml#L3-L9) pointing to Fastly's virtual IP addresses, and `www.data.gov.uk` is a [CNAME to `www-gov-uk.map.fastly.net.`](https://github.com/alphagov/govuk-dns-tf/blob/f21d1f9dfde8470981e2fc79a63538753f2e25f8/zones/data.gov.uk.yaml#L291-L294). Both domains resolve to the [Production data.gov.uk](https://manage.fastly.com/configure/services/1hGLCRA0sJuaXJEFI49z2z) Fastly service.

The `data.gov.uk` redirect to `www.data.gov.uk` is [configured in govuk-fastly-secrets](https://github.com/alphagov/govuk-fastly-secrets/blob/61e0206f62a7af6e45c80820e90d52db7590f3ab/secrets.yaml#L387-L396).

There are a number of other subdomains of `data.gov.uk` configured in govuk-dns-tf.

### The `blog.gov.uk` domain

This is managed in the Government Digital Service Jisc account.

We have a [wildcard CNAME](https://github.com/alphagov/govuk-dns-tf/blob/8fa490bce3d9272e6df69f4dbcb1c1be1b3f07c2/zones/blog.gov.uk.yaml#L18-L21) delegating all subdomains of `blog.gov.uk` to our provider, DXW.

### The `campaign.gov.uk` domain

This is managed in the Government Digital Service Jisc account.

We have a [wildcard CNAME](https://github.com/alphagov/govuk-dns-tf/blob/1be5ae58e82fb47f0e42cc6f7c2507b424fa9200/zones/campaign.gov.uk.yaml#L91-L95) delegating all subdomains of `campaign.gov.uk` to our provider, DXW.

There are a handful of campaign subdomains that have their own specific NS records or CNAME, which take precedence over the wildcard ([example](https://github.com/alphagov/govuk-dns-tf/blob/1be5ae58e82fb47f0e42cc6f7c2507b424fa9200/zones/campaign.gov.uk.yaml#L54-L60)).

### The `independent.gov.uk` domain

This domain is currently administered by Cabinet Office, who manage the delegation of subdomains (e.g. to `icai.independent.gov.uk`).

[The management of the domain is being looked at](https://trello.com/c/qNpyVaC5/3228-consolidate-co-vs-non-co-domains-in-govuks-jisc-account) by Platform Security & Reliability.

Relatedly, there are a [number of `independent-*.uk` domains managed by GOV.UK](#other-domains-we-manage).

### The `api.gov.uk` domain

This domain is currently administered by Cabinet Office, but delegated to GOV.UK. GOV.UK itself then delegates subdomains (such as www.api.gov.uk) back to Cabinet Office, as well as other subdomains (such as driver-vehicle-licensing.api.gov.uk) to other organisations.

The `api.gov.uk` domain has [A records](https://github.com/alphagov/govuk-dns-tf/blob/552278f8cb155999185aa307124cbae226ad5da4/zones/api.gov.uk.yaml#L3-L8) pointing to Fastly's virtual IP addresses.

`www.api.gov.uk` is a [CNAME to `co-cddo.github.io.`](https://github.com/alphagov/govuk-dns-tf/blob/552278f8cb155999185aa307124cbae226ad5da4/zones/api.gov.uk.yaml#L26-L29).

The Platform Security & Reliability team are [looking at the future management of the api.gov.uk domain](https://trello.com/c/8aXqoeCN).

## Other domains we manage

GOV.UK manages DNS zones for some non-`gov.uk` domains (e.g. `independent-inquiry.uk`). Another example is `alphagov.co.uk`, which is the old domain name GOV.UK publishing used to live on - we maintain records which point to Bouncer so that these URLs redirect.

All domains should be managed in Terraform, with each domain having its own zone configuration file in [govuk-dns-tf](https://github.com/alphagov/govuk-dns-tf), with the exception of the domains in the next section.

### Domains and zones managed outside of govuk-dns-tf

The following DNS zones are hosted in Route53 and ultimately configured via [govuk-infrastructure](https://github.com/alphagov/govuk-infrastructure), [govuk-aws](https://github.com/alphagov/govuk-aws/) and
[govuk-aws-data](https://github.com/alphagov/govuk-aws-data/):

- `govuk.digital`
- `govuk-internal.digital`
- `production.govuk-internal.digital`
