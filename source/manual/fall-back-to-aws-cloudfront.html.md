---
owner_slack: "#govuk-platform-engineering"
title: Fall back to AWS CloudFront
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

There is a backup Content Delivery Network (CDN) that can be used if Fastly is down.
This backup CDN is currently provided by AWS CloudFront.

> **Important**: The failover CloudFront distribution does not have feature parity with the primary Fastly service.
> [Most features](https://docs.google.com/document/d/17_dfWvKNmqyLX1h_PPY6_Cd6IggrrSsP-Peh2De6JQk/edit) will continue to work, including search, smart answers, and postcode lookups. Some features, including
> A/B testing, will not work.

## Fail over checklist

> Note: The last time we needed to initiate a CDN failover, we found that Terraform does not work reliably when Fastly is
> having a major incident. The situation might have changed since then, but it is still recommended to perform the
> failover manually, before attempting to update our Terraform configuration.

<!-- Force separation between these two blockquotes -->

> Note: These steps will have you make changes to our production environment. This is because our DNS records and domains for our integration and staging environments are configured in our AWS and GCP production accounts.

### Initial steps

1. Confirm that Fastly is the cause of the incident (check [https://status.fastly.com/](https://status.fastly.com/)
  and keep an eye on twitter - if there's a major Fastly outage there will be a lot of noise)
2. Escalate to GOV.UK SMT as soon as you begin to consider failing over
3. Sign in to the AWS console as an fulladmin (`gds aws govuk-production-fulladmin -l`, or however you prefer to sign in to AWS)
4. Sign in to [the `govuk-production` project on GCP console](https://console.cloud.google.com/home/dashboard?project=govuk-production)

Now follow the steps below for [**Production**](#production) or for [**Staging**](#staging), depending on your scenario:

> Note: If you are undertaking this as a drill, follow the steps for **Staging**.

### Production

Open the following four pages as separate tabs:

- [GCP Cloud DNS www-cdn.production.govuk.service.gov.uk](https://console.cloud.google.com/net-services/dns/zones/govuk-service-gov-uk/rrsets/www-cdn.production.govuk.service.gov.uk./CNAME/edit?project=govuk-production)
- [AWS Route 53 govuk.service.gov.uk](https://console.aws.amazon.com/route53/v2/hostedzones#ListRecordSets/Z22RPYZA77J620)
- [GCP Cloud DNS assets.publishing.service.gov.uk](https://console.cloud.google.com/net-services/dns/zones/publishing-service-gov-uk/rrsets/assets.publishing.service.gov.uk./CNAME/edit?project=govuk-production)
- [AWS Route 53 publishing.service.gov.uk](https://console.aws.amazon.com/route53/v2/hostedzones#ListRecordSets/Z3SBFBO09PD5HF)

You are going to update the `CNAME` records for two different domains, in both GCP and AWS. These two domains are:

- `www-cdn.production.govuk.service.gov.uk`
- `assets.publishing.service.gov.uk`

This [Draft PR to Failover to AWS CloudFront](https://github.com/alphagov/govuk-dns-tf/pull/69) shows the `CNAME`s you need to change, and how to test that they are correct

You can also get the `CNAME`s to use for the secondary CDN from the AWS CLI:

```bash
  # www-cdn.production.govuk.service.gov.uk
  gds aws govuk-production-developer aws cloudfront list-distributions \
    --query "DistributionList.Items[?Aliases.Items[0]=='www.gov.uk'].DomainName | [0]"
  # assets.publishing.service.gov.uk
  gds aws govuk-production-developer aws cloudfront list-distributions \
    --query "DistributionList.Items[?Aliases.Items[0]=='assets.publishing.service.gov.uk'].DomainName | [0]"
```

The records should look like `d0000000000000.cloudfront.net.` (with 0s replaced with letters and numbers). Now you can manually update the `CNAME` records for both domains in both GCP and AWS, via the tabs you opened in your web browser earlier:

- Change the canonical name from `www-gov-uk.map.fastly.net.` to the CloudFront domain name you found before, including the trailing period (e.g. `d0000000000000.cloudfront.net.`)
- Test if the new Cloudfront domain is serving assets correctly, for example:

```bash
curl -vs https://assets.staging.publishing.service.gov.uk/media/662a74aa45f183ec818a72c2/dvsa-earned-recognition-vehicle-operators-accredited-list.csv/preview | grep cloudfront
```

- Two ways to check if the Cloudfront domain is working correctly:
  - There will be a missing key: `fastly-backend-name`
  - Look for a value of `xxxxx.cloudfront.net` in the `via` key.
- After performing the manual failover, you should also update our infrastructure-as-code to match the changes you just made:
  - Merge [the PR to Failover to AWS CloudFront](https://github.com/alphagov/govuk-dns-tf/pull/69)
  - Terraform Cloud should automatically perform a plan when your PR is merged, but the apply will require manual approval - you can do this in the [govuk-dns-tf workspace](https://app.terraform.io/app/govuk/workspaces/govuk-dns-tf)

### Staging

Open the following three pages as separate tabs:

- [GCP Cloud DNS www.staging.publishing.service.gov.uk](https://console.cloud.google.com/net-services/dns/zones/publishing-service-gov-uk/rrsets/www.staging.publishing.service.gov.uk./CNAME/edit-standard?project=govuk-production)
- [GCP Cloud DNS assets.staging.publishing.service.gov.uk](https://console.cloud.google.com/net-services/dns/zones/publishing-service-gov-uk/rrsets/assets.staging.publishing.service.gov.uk./CNAME/edit-standard?project=govuk-production)
- [AWS Route 53 publishing.service.gov.uk](https://us-east-1.console.aws.amazon.com/route53/v2/hostedzones#ListRecordSets/Z3SBFBO09PD5HF)

You are going to update the `CNAME` records for two different domains, in both GCP and AWS. These two domains are:

- `www.staging.publishing.service.gov.uk`
- `assets.staging.publishing.service.gov.uk`

You can get the `CNAME`s to use for the secondary CDN from the AWS CLI:

```bash
  # www.staging.publishing.service.gov.uk
  gds aws govuk-staging-developer aws cloudfront list-distributions \
    --query "DistributionList.Items[?Aliases.Items[0]=='www.staging.publishing.service.gov.uk'].DomainName | [0]"
  # assets.staging.publishing.service.gov.uk
  gds aws govuk-staging-developer aws cloudfront list-distributions \
    --query "DistributionList.Items[?Aliases.Items[0]=='assets.staging.publishing.service.gov.uk'].DomainName | [0]"
```

The records should look like `d0000000000000.cloudfront.net.` (with 0s replaced with letters and numbers). Now you can manually update the `CNAME` records for both domains in both GCP and AWS, via the tabs you opened in your web browser earlier:

- Change the canonical name from `www-gov-uk.map.fastly.net.` to the CloudFront domain name you found before, including the trailing period (e.g. `d0000000000000.cloudfront.net.`)
- Test if the new Cloudfront domain is serving assets correctly, for example:

```bash
curl -vs https://assets.staging.publishing.service.gov.uk/media/662a74aa45f183ec818a72c2/dvsa-earned-recognition-vehicle-operators-accredited-list.csv/preview | grep cloudfront
```

- Two ways to check if the Cloudfront domain is working correctly:
  - There will be a missing key: `fastly-backend-name`
  - Look for a value of `xxxxx.cloudfront.net` in the `via` key.

### Finishing up

- Once you've failed over, keep a close eye on Fastly's status
- As soon as you are confident that Fastly has recovered
  - Manually set each of the `CNAME` records you changed above back to `www-gov-uk.map.fastly.net.`
  - If you previously raised a PR in [govuk-dns-tf](https://github.com/alphagov/govuk-dns-tf), raise another PR to revert your changes and restore the old records. Get it approved, merged and approve the Terraform apply via the [govuk-dns-tf workspace](https://app.terraform.io/app/govuk/workspaces/govuk-dns-tf) on Terraform Cloud.
