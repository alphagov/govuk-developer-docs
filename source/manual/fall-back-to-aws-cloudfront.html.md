---
owner_slack: "#govuk-2ndline"
title: Fall back to AWS CloudFront
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

There is a backup Content Delivery Network (CDN) that can be used if Fastly is down.
This backup CDN is currently provided by AWS CloudFront.

**Important** At the time of writing, GOV.UK will be served
by static mirrors and not the origin of GOV.UK if you fallback to the backup CDN.

## Procedure

You will have to make 2 DNS changes to GOV.UK:

1. The CNAME at `www-cdn.production.govuk.service.gov.uk` should point to
   cloudfront's WWW distribution instead of Fastly
2. The CNAME at `assets.publishing.service.gov.uk` should point to cloudfront's
   Assets distribution instead of Fastly

This [Draft PR to Failover to AWS CloudFront](https://github.com/alphagov/govuk-dns-config/pull/714)
shows the changes you need to make, and how to test the CDN before failing over.

You can check the domain names of the cloudfront distributions by looking in
the AWS web console, or with the CLI:

```
# www.gov.uk
gds aws govuk-production-readonly aws cloudfront list-distributions --query "DistributionList.Items[?Comment=='WWW'].DomainName | [0]"

# assets.publishing.service.gov.uk
gds aws govuk-production-readonly aws cloudfront list-distributions --query "DistributionList.Items[?Comment=='Assets'].DomainName | [0]"
```
