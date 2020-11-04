---
owner_slack: "#re-govuk"
title: Domain Name System (DNS) records
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

The Reliability Engineering team is responsible for managing several DNS zones.

By default, zones are hosted by AWS (Route 53) and Google Cloud Platform (Cloud DNS)

As of Feb 2020, there are 40 hosted zones. A list is retrievable from a terminal using:

```
  gds aws govuk-production-admin -- aws route53 list-hosted-zones | grep Name
```

Some individual records within these zones are managed by other teams.

## Amazon Route 53 and Google Cloud DNS

Use the "production" account. [Speak to Infrastructure if you require access](/manual/raising-issues-with-reliability-engineering.html).

## Records for GOV.UK systems

We use a few domains:

- `alphagov.co.uk` is the old domain name GOV.UK publishing used to live on.
  We maintain records which point to Bouncer so that these URLs redirect.
- `publishing.service.gov.uk` and `govuk.service.gov.uk` are where GOV.UK lives.

## Making changes to publishing.service.gov.uk

To make a change to this zone, begin by adding the records to the yaml file for
the zone held in the [DNS config repo](https://github.com/alphagov/govuk-dns-config).

We use a Jenkins job that publishes changes to `publishing.service.gov.uk`. The
job uses [Terraform](https://www.terraform.io/) and pushes changes to the
selected provider.

### Deployment

**Always `plan` first, check that the output is what you expect, then `apply`.**

When the changes have been reviewed and merged, you can deploy them in your terminal
by using at least version `v2.15.0` of [`gds-cli`][gds-cli].

**You MUST deploy to BOTH DNS providers. We use both for redundancy.**

You should **always**:

1. `plan` in each DNS provider and check the console output is what you expect.
2. `apply` in each DNS provider until you see that your changes has been applied.
    There are [circumstances where terraform is not able to apply the changes](#google-based-caveats)
    in 1 run and need **multiple** runs.

Deployment is done by first obtaining (first time set up) your GitHub credentials
by creating a read-only GitHub personal access token. This [GitHub personal access token](https://github.com/settings/tokens) should be created with the `read:org`
scope only.

> Take care to store and handle the token securely. If you accidentally share your token,
  [revoke it immediately](https://github.com/settings/tokens) and follow the
  [instructions for reporting a potential data security incident][security-incidents].

You can then run [`gds-cli`][gds-cli]:

```sh
GITHUB_USERNAME=<github_username> GITHUB_TOKEN=<github_token> \
gds govuk dns -p <dns_provider> -z <dns_zone> -a <action> -r <aws_role>
```

Where:

1. `<github_username>` is the name of your GitHub account
1. `<github_token>` is the GitHub token that you created as described above
1. `<dns_provider>` is one of the 2 DNS provider of govuk, i.e. `gcp` or `aws`
1. `<dns_zone>` is the govuk DNS zone to be deployed. E.g. `direct.gov.uk`
1. `<action>` is the terraform action you want to perform. i.e. `plan` or `apply`
1. `<aws_role>` is the govuk aws role you want to use for terraforming. i.e. `govuk-production-admin` or `govuk-production-poweruser`

After you deploy, you can visit the [Jenkins job](https://deploy.blue.production.govuk.digital/job/Deploy_DNS/) to see the job running or queued.

> **Note**
>
> - Due to the Terraform state being held in an S3 bucket, you
> will require access to the GOV.UK AWS "production" account to roll changes for
> both Amazon and Google.
> - The order in which you deploy to providers is not important.
> - You will not require credentials for Google Cloud. These credentials are stored
> in Jenkins itself.

#### Google-based caveats

> - When deploying to Google it's normal to see changes in TXT records
> relating to escaping of quotes. You can safely ignore these if
> they don't change any of the content of the record. This is a bug
> in the way we handle splitting long TXT records between AWS and
> GCP in our [YAML -> Ruby -> Terraform process](https://github.com/alphagov/govuk-dns).
> - To change a DNS record, the Google provider deletes and
> re-adds that record. This can sometimes cause a [race
> condition](https://github.com/alphagov/govuk-dns/issues/67) where
> Google tries to create the new one before it has sucessfully deleted
> the old one. In this case, the build will fail, and you need to
> re-run the GCP `apply` job.

### Making changes to internal DNS (govuk.digital and govuk-internal.digital)

Currently these zones are only used in environments running on AWS.

These DNS zones are hosted in Route53 and managed by Terraform. Changes can be
made in the [govuk-aws](https://github.com/alphagov/govuk-aws/) and
[govuk-aws-data](https://github.com/alphagov/govuk-aws-data/) repositories.
While GOV.UK migrates to AWS speak with Reliability Engineering for support
making your changes.

## DNS for the `gov.uk` top level domain

[Jisc](https://www.jisc.ac.uk/) is a non-profit which provides networking to
UK education and government. They control the `gov.uk.` top-level domain.

Requests to modify the DNS records for `gov.uk.` should be sent by email to
`naming@ja.net` from someone on Jisc's approved contacts list. Speak to a
senior technologist member of GOV.UK or Reliability Engineering if you need to
make a change and don't have access.

2nd line should be notified of any planned changes via email.

- `gov.uk.` is a top-level domain so it cannot contain a CNAME record
  (see [RFC 1912 section 2.4](https://tools.ietf.org/html/rfc1912#section-2.4)).
  Instead, it contains A records that point to anycast IP addresses for our CDN provider.
- `www.gov.uk.` is a CNAME to `www-cdn.production.govuk.service.gov.uk.`, which means we
  do not need to make a request to Jisc if we want to change CDN providers. Just change where
  the CNAME points to.

## Delegating `service.gov.uk` domains

At the moment Reliability Engineering are also responsible for delegating DNS
to other government services.

The request will arrive by email or Zendesk from a member of the GOV.UK Proposition
team. The request will contain the service domain name that needs to be delegated and
more than one nameserver hostname (usually `ns0.example.com`, `ns1.example.com`).

In Route 53, create a new node for the service domain underneath `service.gov.uk`
and add `NS` records for that node.

We __do not__ manage DNS for service domains. If you get a request asking you to add
anything other than `NS` records, it should be rejected. This is so we're not
the single point of DNS for government.

There are ongoing plans to move this responsibility to a different part of GDS.

## Other weird bits of DNS

If you receive a request to change any other DNS that hasn't come from the GOV.UK
Proposition team, send it to them using the Zendesk group "3rd Line--GOV.UK Proposition".

[security-incidents]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/security/security-incidents
[gds-cli]: https://github.com/alphagov/gds-cli
