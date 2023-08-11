---
owner_slack: "#govuk-2ndline-tech"
title: Fall back to AWS CloudFront
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

# Fall back to AWS CloudFront

There is a backup Content Delivery Network (CDN) that can be used if Fastly is down.
This backup CDN is currently provided by AWS CloudFront.

> **Important** GOV.UK will be served by static mirrors and not the origin of GOV.UK if you fallback to the backup CDN.
> This is significantly degraded service compared to the primary CDN. Major features such as search, smart answers, and
> postcode lookups will not work when using the secondary CDN.

## Fail over checklist

- Confirm that Fastly is the cause of the incident (check [https://status.fastly.com/](https://status.fastly.com/)
  and keep an eye on twitter - if there's a major Fastly outage there will be a lot of noise)
- Sign in to the AWS console as an admin (`gds aws govuk-production-admin -l`, or however you prefer to sign in to AWS)
- Sign in to [the GCP console](https://console.cloud.google.com/home/dashboard?project=govuk-production)
- Open the following four pages as separate tabs:
  - [GCP Cloud DNS www-cdn.production.govuk.service.gov.uk](https://console.cloud.google.com/net-services/dns/zones/govuk-service-gov-uk/rrsets/www-cdn.production.govuk.service.gov.uk./CNAME/edit?project=govuk-production)
  - [AWS Route 53 govuk.service.gov.uk](https://console.aws.amazon.com/route53/v2/hostedzones#ListRecordSets/Z22RPYZA77J620)
  - [GCP Cloud DNS assets.publishing.service.gov.uk](https://console.cloud.google.com/net-services/dns/zones/publishing-service-gov-uk/rrsets/assets.publishing.service.gov.uk./CNAME/edit?project=govuk-production)
  - [AWS Route 53 publishing.service.gov.uk](https://console.aws.amazon.com/route53/v2/hostedzones#ListRecordSets/Z3SBFBO09PD5HF)
- Because the secondary CDN provides degraded service we have a grace period
  before failing over
  - Escalate to GOV.UK SMT as soon as you begin to consider failing over
  - For a major Fastly outage (more than 30% of requests failing) wait 15
    minutes (from the start of the incident) and then start the fail over
  - For a minor Fastly outage (less than 30% of requests failing) wait at least
    15 minutes (from the start of the incident) before failing over - discuss
    the decision with the GOV.UK SMT Escalations person
- While you wait, confirm the new CNAMES for www-cdn.production.govuk.service.gov.uk and assets.publishing.service.gov.uk
  - This [Draft PR to Failover to AWS CloudFront](https://github.com/alphagov/govuk-dns-config/pull/714) shows the CNAMES you need to change, and how to test that they are correct
  - You can also get the CNAMEs to use for the secondary CDN from the AWS CLI: <div class="highlight"><pre class="highlight plaintext"><code># www.gov.uk
  gds aws govuk-production-readonly aws cloudfront list-distributions --query "DistributionList.Items[?Comment=='WWW'].DomainName | [0]"
  # assets.publishing.service.gov.uk
  gds aws govuk-production-readonly aws cloudfront list-distributions --query "DistributionList.Items[?Comment=='Assets'].DomainName | [0]"</code></pre></div>
  - The records should look like `d0000000000000.cloudfront.net.` (with 0s replaced with letters and numbers)
- When you are ready to fail over:
  - Manually update the CNAME record for www-cdn.production.govuk.service.gov.uk in GCP and AWS
  - Manually update the CNAME record for assets.publishing.service.gov.uk in GCP and AWS
- After failing over manually:
  - Merge [the PR to Failover to AWS CloudFront](https://github.com/alphagov/govuk-dns-config/pull/714)
  - [Deploy DNS using Jenkins and Terraform](/manual/dns.html#dns-for-the-publishingservicegovuk-domain)
- Once you've failed over, keep a close eye on Fastly's status
- As soon as you are confident that Fastly has recovered
  - Manually set the CNAME records you changed above back to www-gov-uk.map.fastly.net.
  - Raise a PR in [govuk-dns-config](https://github.com/alphagov/govuk-dns-config) to set the records back formally. Get it approved, merged and [Deploy DNS using Jenkins and Terraform](/manual/dns.html#dns-for-the-publishingservicegovuk-domain)
