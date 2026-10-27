---
owner_slack: "#govuk-platform-engineering-team"
title: Domain Name System (DNS) records
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

> For documentation on when and how to respond to DNS delegation and domain verification requests, read the [DNS change request and hostmaster Google doc](https://beisgov.sharepoint.com/:w:/r/sites/GOVUKPE/Shared%20Documents/General/Platform%20Engineering/Runbooks/Domain-related%20tickets%20that%20come%20into%20Platform%20Support.docx?d=w03b15fa6d5144a91a29b34408deedc64&csf=1&web=1&e=dxuHed).

GOV.UK is responsible for managing several DNS zones, spanning a number of `*.gov.uk` domains. As of February 2024, there are 45 hosted zones, configuring many hundreds of domains. A list of hosted zones is retrievable from a terminal using:

```sh
gds aws govuk-production-developer -- aws route53 list-hosted-zones | grep Name
```

## Records for GOV.UK systems

We use a few domains:

- `alphagov.co.uk` is the old domain name GOV.UK publishing used to live on.
  We maintain records which point to Bouncer so that these URLs redirect.
- `publishing.service.gov.uk` and `govuk.service.gov.uk` are where GOV.UK lives.

## DNS for `*.service.gov.uk` domains

The GOV.UK Platform Engineering team is responsible for delegating DNS to other government services.
Note that we __do not__ manage any other DNS records: if you get a request concerning anything other than `NS` records, it should be rejected.

When you've verified the authenticity of the request as per the SRE docs above, you should:

1. Ensure you have [Terraform Cloud access](/manual/terraform-cloud.html)
1. Commit your changes in [govuk-dns-tf][] (see [example](https://github.com/alphagov/govuk-dns-tf/pull/14))
1. Push your changes to GitHub and open a pull request
1. Terraform Cloud will automatically perform a plan. Open the [govuk-dns-tf][govuk-dns-tf-cloud] workspace to see it.
1. If you are happy with the results of the plan, merge your PR
1. From the [govuk-dns-tf][] landing page, click on the green pre-merge check tick and open the "details" link from the Terraform Cloud check.
1. Press "Confirm and apply" in Terraform Cloud.

[govuk-dns-tf-cloud]: https://app.terraform.io/app/govuk/workspaces/govuk-dns-tf

## DNS for `govuk.digital` and `govuk-internal.digital`

Currently these zones are only used in environments running on AWS.

These DNS zones are hosted in Route53 and managed by Terraform. Changes can be
made in the [govuk-aws](https://github.com/alphagov/govuk-aws/) and
[govuk-aws-data](https://github.com/alphagov/govuk-aws-data/) repositories.
Ask the Platform Engineering team if you need help making your changes.

## DNS for the `publishing.service.gov.uk` domain

To make a change to this zone, begin by adding the records to [the Terraform configuration](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/tfc-configuration/govuk-publishing-infrastructure.tf)
for the GOV.UK publishing infrastructure.

The deployment process is the same as for any other Terraform root in the `govuk-infrastructure` repository.

## DNS for the `gov.uk` top level domain

[Nominet](https://www.nominet.uk/) hosts DNS for the `gov.uk.` zone. The
`.gov.uk` registry is managed by the Services team at the Government Cyber
Unit (GCU) at the Department for Digital, Culture, Media and Sport (DCMS).

### Before requesting a DNS change

Speak to a member of Senior Tech or someone in the Platform Engineering team if
you need to make a DNS change and are unsure of the process or do not have the
required access.

Before submitting a request, make sure the following people are aware of the
proposed change:

- GOV.UK Technical On Call (via Slack)
- GOV.UK's Head of Technology and the Senior Tech team

### Requesting a DNS change

Send all requests for changes to the `gov.uk.` DNS to the GCU Services team at
[support@domains.gov.uk](mailto:support@domains.gov.uk). Make it clear in the
subject line that you need a DNS change to `.gov.uk`.

Your request should include:

- Timings: when the change is needed and any relevant deadlines or dependencies
- Zone and record: the DNS zone and record(s) to be changed
- New values: the exact new DNS values or DNSSEC records needed
- Outcome: what the change is intended to achieve
- Verification of success: how successful implementation of the change can be confirmed
- Risks: any identified risks associated with making the change
- Fallback plan: what should happen if the change is unsuccessful or needs to be reversed

Providing complete information when you submit the request will help GCU and
Nominet progress the change as quickly as possible.

### Change control and timescales

DNS changes to the `.gov.uk` registry are subject to an established
change-control process between GCU and Nominet. This provides appropriate
assurance before changes are implemented. The GCU Services team aims to
acknowledge requests within 24 hours.

Changes can take up to 10 working days to complete, as they must pass through
Nominet's weekly Change Approval Board and be verified out-of-band. Changes may
take longer if additional information is needed or the request needs to be
amended.

Submit requests well in advance of any service, certificate or other
operational deadline. If your change is linked to a fixed deadline, such as a
TLS certificate renewal, make this clear in the request.

### Out-of-hours changes

GCU does not currently operate an out-of-hours approval service for DNS
changes. Plan changes far enough in advance to allow for the change-control
timescales.

### Technical notes

- The domain name `gov.uk.` is an apex domain so it [cannot have a CNAME record](https://tools.ietf.org/html/rfc1912#section-2.4).
  Instead, it has A records that point directly to anycast virtual IP addresses (VIPs) for our CDN provider.
- `www.gov.uk.` is a CNAME to `www-cdn.production.govuk.service.gov.uk.`, which
  means we do not need to request a change to the `gov.uk.` apex DNS records if
  we want to change CDN providers. We can just change where the CNAME points to.

## DNS for non-`gov.uk` domains

GOV.UK also manages DNS zones for some non-`gov.uk` domains (e.g. `independent-inquiry.uk`).

These should be managed in Terraform, with each domain having its own zone configuration file in [govuk-dns-tf][].

[govuk-dns-tf]: https://github.com/alphagov/govuk-dns-tf
