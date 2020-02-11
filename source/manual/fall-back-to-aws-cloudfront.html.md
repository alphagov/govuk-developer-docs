---
owner_slack: "#govuk-2ndline"
title: Fall back to AWS CloudFront
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-06-28
review_in: 6 months
---

There is a backup Content Delivery Network (CDN) that can be used in case Fastly is down.
This backup CDN is currently provided by AWS CloudFront.

**Important** At the time of writing, GOV.UK will be served
by static mirrors and not the origin of GOV.UK if you fallback to the backup CDN.

## Procedure

You will have to make 2 DNS changes to GOV.UK:

1. you will have to ask JISC (very few people are authorised to make such changes) to change
   the cname of `www.gov.uk` to the `www` AWS CloudFront distribution domain.
   You can log into the AWS web console to find the `www` AWS CloudFront distribution domain.

2. you will have to change the cname of `assets.publishing.service.gov.uk` to the
   the `assets` AWS CloudFront distribution domain using the usual gov.uk processes.
   You can log into the AWS web console to find the `assets` AWS CloudFront distribution domain.
