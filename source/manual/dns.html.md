---
owner_slack: "#govuk-2ndline-tech"
title: Domain Name System (DNS) records
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK is responsible for managing several DNS zones. For documentation on updating DNS, see the [DNS change request and hostmaster](https://drive.google.com/drive/search?q=-%20type:document%20title:%22Tech%202nd%20Line%20-%20Handle%20Tickets%20on%20DNS%20Change%20request%20hostmaster%40%22) doc for Technical 2nd Line.

In most cases, zones are hosted by AWS (Route 53) and Google Cloud Platform (Cloud DNS). See [Amazon Route53 vs Google Cloud in the govuk-dns-tf README](https://github.com/alphagov/govuk-dns-tf#amazon-route53-vs-google-cloud)

As of December 2022, there are 61 hosted zones. A list is retrievable from a terminal using:

```
gds aws govuk-production-poweruser -- aws route53 list-hosted-zones | grep Name
```

Some individual records within these zones are managed by other teams.

## Records for GOV.UK systems

We use a few domains:

- `alphagov.co.uk` is the old domain name GOV.UK publishing used to live on.
  We maintain records which point to Bouncer so that these URLs redirect.
- `publishing.service.gov.uk` and `govuk.service.gov.uk` are where GOV.UK lives.

## DNS for `*.service.gov.uk` domains

GOV.UK Technical 2nd Line are responsible for delegating DNS to other government services.
Note that we __do not__ manage any other DNS records: if you get a request concerning anything other than `NS` records, it should be rejected.

When you've verified the authenticity of the request as per the SRE docs above, you should:

1. Ensure you have [Terraform Cloud access](/manual/terraform-cloud.html)
1. Commit your changes in [govuk-dns-tf][] (see [example](https://github.com/alphagov/govuk-dns-tf/pull/14))
1. Push your changes to GitHub and open a pull request
1. Terraform Cloud will automatically perform a plan. Open the [govuk-dns-tf][govuk-dns-tf-cloud] workspace to see it.
1. If you are happy with the results of the plan, merge your PR
1. From the PR page in GitHub, look under the pre-merge checks section and open the "details" link from the Terraform Cloud check.
1. Press "Confirm and apply" in Terraform Cloud.

[govuk-dns-tf-cloud]: https://app.terraform.io/app/govuk/workspaces/govuk-dns-tf

## DNS for `govuk.digital` and `govuk-internal.digital`

Currently these zones are only used in environments running on AWS.

These DNS zones are hosted in Route53 and managed by Terraform. Changes can be
made in the [govuk-aws](https://github.com/alphagov/govuk-aws/) and
[govuk-aws-data](https://github.com/alphagov/govuk-aws-data/) repositories.
Ask the Platform teams if you need help making your changes.

## DNS for the `publishing.service.gov.uk` domain

To make a change to this zone, begin by adding the records to the yaml file for
the zone held in the [DNS config repo](https://github.com/alphagov/govuk-dns-tf).

The deployment process is the same as for [`service.gov.uk`](#dns-for-service-gov-uk-domains)

## DNS for the `gov.uk` top level domain

[Jisc](https://www.jisc.ac.uk/) is a non-profit which provides networking to
UK education and government. They host DNS for the `gov.uk.` zone.

Requests to modify the DNS records for `gov.uk.` should be sent by
email to `naming@ja.net` from someone on Jisc's approved contacts
list. Speak to a member of Senior Tech or someone in the Platform teams if you
need to make a change and don't have access.

You should also make sure that the following groups of people are aware before
requesting any changes:

- Technical 2nd Line (via email)
- GOV.UK's Head of Tech and the senior tech team
- The CDDO domains team (#team-domains)

Technical 2nd Line should be notified of any planned changes via email.

- The domain name `gov.uk.` is an apex domain so it [cannot have a CNAME record](https://tools.ietf.org/html/rfc1912#section-2.4).
  Instead, it has A records that point directly to anycast virtual IP addresses (VIPs) for our CDN provider.
- `www.gov.uk.` is a CNAME to `www-cdn.production.govuk.service.gov.uk.`, which
  means we do not need to make a request to Jisc if we want to change CDN
  providers. We can just change where the CNAME points to.

## DNS for non-`gov.uk` domains

GOV.UK also manages DNS zones for some non-`gov.uk` domains (e.g. `independent-inquiry.uk`).

These should be managed in Terraform, with each domain having its own zone configuration file in [govuk-dns-tf][].

[govuk-dns-tf]: https://github.com/alphagov/govuk-dns-tf
