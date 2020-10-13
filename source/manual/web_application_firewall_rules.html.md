---
owner_slack: "#re-govuk"
title: 'Web Application Firewall (WAF) configuration'
section: Security
layout: manual_layout
parent: "/manual.html"
---

Web Application Firewall (WAF) rules enable blocking potentially
malicious/suspect requests at the edge of the network before they can reach the applications.

## How to configure WAF rules

WAF rules are configured via Terraform and associated to load balancers.

The rules are maintained alongside the configuration for the public load
balancers in [govuk-aws/terraform/projects/infra-public-services](https://github.com/alphagov/govuk-aws/tree/master/terraform/projects/infra-public-services).
For instructions on how to deploy the terraform projects see [deploying terraform](/manual/deploying-terraform.html)

For documentation on the kinds of rules:

* [AWS WAF Documentation](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)
* [Terraform WAF Rule Documentation](https://www.terraform.io/docs/providers/aws/r/wafregional_rule.html)

## Viewing logs for WAF

Each time a WAF rule is evaluated and matched it gets logged as either `ALLOW`
or `BLOCK`. Requests that match the "default" action are not logged. This means
that only rules that have been explicitly told to `ALLOW` or `BLOCK` will be
logged, otherwise the logs would contain every single request.

Logs are shipped to a Splunk instance managed by Cyber Security for monitoring
and the logs are accessible by members of GOV.UK by logging in with your GDS
Google Account.

Example query links:

* [ALL requests](https://gds.splunkcloud.com/en-GB/app/gds-006-govuk/search?q=search%20index%3D"govuk_waf")
* [BLOCKED requests](https://gds.splunkcloud.com/en-GB/app/gds-006-govuk/search?q=search%20index%3D"govuk_waf"%20action%3DBLOCK)
* [ALLOWED requests](https://gds.splunkcloud.com/en-GB/app/gds-006-govuk/search?q=search%20index%3D"govuk_waf"%20action%3DALLOW)

If you do not have access to Splunk, you can request access by raising a
support ticket with IT and asking them to enable Splunk for your Google account
and saying you work on GOV.UK.

## Debugging issues with logs delivery

If Splunk is down the logs will be requeued and retried for several
minutes before falling back to storage in an S3 bucket. The S3 bucket
has a very short expiry of 3 days since its primary use is to
troubleshoot issues in scenerios where Splunk delivery is failing.

In addition to the previous 3 days of backup logs, the s3 bucket will also dump
any errors encountered into `failed-delivery` and `failed-processing` folders.
