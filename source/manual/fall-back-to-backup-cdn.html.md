---
owner_slack: "#re-govuk"
title: Fall back to backup CDN
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

There two backup Content Delivery Network (CDN) that can be used if Fastly is down.
AWS CloudFront or Google Cloud CDN.

**Important** At the time of writing, GOV.UK will be served
by static mirrors and not the origin of GOV.UK if you fallback to one of the backup CDN.

## Procedure

To switch to AWS Cloudfront:
You will have to make 2 DNS changes to GOV.UK:

1. you will have to ask JISC (very few people are authorised to make such changes) to change
   the cname of `www.gov.uk` to the `www` AWS CloudFront distribution domain.
   You can log into the AWS web console to find the `www` AWS CloudFront distribution domain.

2. you will have to change the cname of `assets.publishing.service.gov.uk` to
   the `assets` AWS CloudFront distribution domain using the usual gov.uk processes.
   You can log into the AWS web console to find the `assets` AWS CloudFront distribution domain.

To switch to Google Cloud CDN
To access the GCP console you will neeed to [set up your GCP account](/manual/set-up-gcp-account.html)
You will have to make 2 DNS changes to GOV.UK:

1. you will have to ask JISC (very few people are authorised to make such changes) to change
   the cname of `www.gov.uk` to point towards the loadbalancer associated with the govuk-mirror-www Cloud CDN.

2. you will have to change the cname of `assets.publishing.service.gov.uk` to point towards the loadbalancer associated with the govuk-mirror-www Cloud CDN.
   You can log into the AWS web console to find the `assets` AWS CloudFront distribution domain.
