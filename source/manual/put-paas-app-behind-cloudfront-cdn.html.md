---
owner_slack: "#govuk-2ndline-tech"
title: Put a PaaS application behind Cloudfront CDN
parent: /manual.html
layout: manual_layout
section: PaaS
---
It is possible to put an application behind a Cloudfront CDN when it is on the PaaS with a custom domain. This means you can quickly set up a new application and have it serve traffic at scale.

There are instructions on how to set this up in [their docs](https://docs.cloud.service.gov.uk/deploying_services/use_a_custom_domain/#set-up-the-gov-uk-paas-cdn-route-service).

At step 5, you need to add the CNAME records to DNS, you can do this by manually adding it to Route53 in the AWS console to check that you've got it right.

Once you have checked it works, and been through the rest of the PaaS documentation, you should add this to the `govuk-dns-config` repo so that your changes won't be lost. There is [prior art](https://github.com/alphagov/govuk-dns-config/pull/694).

Once it's merged you must then [deploy the changes](dns.html)
