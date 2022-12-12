---
owner_slack: "#govuk-2ndline-tech"
title: Domain Name System (DNS) records
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK is responsible for managing several DNS zones.

By default, zones are hosted by AWS (Route 53) and Google Cloud Platform (Cloud DNS). We use both for redundancy.

As of December 2022, there are 61 hosted zones. A list is retrievable from a terminal using:

```
gds aws govuk-production-admin -- aws route53 list-hosted-zones | grep Name
```

Some individual records within these zones are managed by other teams.

## Records for GOV.UK systems

We use a few domains:

- `alphagov.co.uk` is the old domain name GOV.UK publishing used to live on.
  We maintain records which point to Bouncer so that these URLs redirect.
- `publishing.service.gov.uk` and `govuk.service.gov.uk` are where GOV.UK lives.

## DNS for `*.service.gov.uk` domains

GOV.UK Technical 2nd Line are responsible for delegating DNS to other government services.
Note that we __do not__ manage any other DNS records: if you get a request concerning anything other than `NS` records, it should be rejected. See the [SRE interruptible documentation](https://docs.google.com/document/d/1QzxwlN9-HoewVlyrOhFRZYc1S0zX-pd97igY8__ZLAo/edit#heading=h.wg0s4ugkpdpc) for details.

When you've verified the authenticity of the request as per the SRE docs above, you should:

1. Make the changes in govuk-dns-config (see [example](https://github.com/alphagov/govuk-dns-config/pull/851))
1. Deploy the changes via the [Deploy_DNS Jenkins job](https://deploy.blue.production.govuk.digital/job/Deploy_DNS/). You'll need production admin access to do this.

Deploying is a multi-step process:

1. Run a `plan` of the deployment, against the `aws` provider.
  - You can get the necessary AWS credentials by running `gds aws govuk-production-admin -e`.
1. Check that the output is what you expect.
1. Retrieve a Google OAuth access token.
  - You'll need the gcloud CLI (`brew install --cask google-cloud-sdk`).
  - Then run the following - you'll be prompted to login to your Google account to allow Google Cloud SDK access your Google Account. The token will be printed in the terminal:
  - `gcloud config set project govuk-production; gcloud auth login --brief; gcloud auth print-access-token`
  - Use this token for the `GOOGLE_OAUTH_ACCESS_TOKEN` field in the next step.
1. Now run a `plan` of the deployment against the `gcp` provider.
  - You'll still need to provide all the AWS credentials as per step 1. This is because the Terraform state is held in an S3 bucket.
1. Check that the output is what you expect.
  - It's normal to see changes in TXT records relating to escaping of quotes. You can safely ignore these if they don't change any of the content of the record. This is a bug in the way we handle splitting long TXT records between AWS and GCP in our [YAML -> Ruby -> Terraform process](https://github.com/alphagov/govuk-dns).
1. Finally, run an `apply` deployment for both `aws` AND `gcp`. (The order doesn't matter).
  - Sometimes, the GCP deployment requires multiple runs. This is because, in order to change a DNS record, the Google provider deletes and re-adds that record. This can cause a [race condition](https://github.com/alphagov/govuk-dns/issues/67) where Google tries to create the new one before it has successfully deleted the old one. In this case, the build will fail, and you just need to re-run the GCP `apply` job.

## DNS for `govuk.digital` and `govuk-internal.digital`

Currently these zones are only used in environments running on AWS.

These DNS zones are hosted in Route53 and managed by Terraform. Changes can be
made in the [govuk-aws](https://github.com/alphagov/govuk-aws/) and
[govuk-aws-data](https://github.com/alphagov/govuk-aws-data/) repositories.
While GOV.UK migrates to AWS speak with GOV.UK Replatforming for support
making your changes.

## DNS for the `publishing.service.gov.uk` domain

To make a change to this zone, begin by adding the records to the yaml file for
the zone held in the [DNS config repo](https://github.com/alphagov/govuk-dns-config).

We use a Jenkins job that publishes changes to `publishing.service.gov.uk`. The
job uses [Terraform](https://www.terraform.io/) and pushes changes to the
selected provider.

## DNS for the `gov.uk` top level domain

[Jisc](https://www.jisc.ac.uk/) is a non-profit which provides networking to
UK education and government. They control the `gov.uk.` top-level domain.

Requests to modify the DNS records for `gov.uk.` should be sent by
email to `naming@ja.net` from someone on Jisc's approved contacts
list. Speak to a member of the senior tech team or someone in
GOV.UK Replatforming if you need to make a change and don't have
access.

You should also make sure that the following groups of people are aware before
requesting any changes:

- Technical 2nd Line (via email)
- GOV.UK's Head of Tech and the senior tech team
- The CDDO domains team (the senior tech team can contact them)

Technical 2nd Line should be notified of any planned changes via email.

- `gov.uk.` is a top-level domain so it cannot contain a CNAME record
  (see [RFC 1912 section 2.4](https://tools.ietf.org/html/rfc1912#section-2.4)).
  Instead, it contains A records that point to anycast IP addresses for our CDN provider.
- `www.gov.uk.` is a CNAME to `www-cdn.production.govuk.service.gov.uk.`, which means we
  do not need to make a request to Jisc if we want to change CDN providers. Just change where
  the CNAME points to.
