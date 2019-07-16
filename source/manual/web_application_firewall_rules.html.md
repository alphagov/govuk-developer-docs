---
owner_slack: "#govuk-2ndline"
title: 'Web Application Firewall (WAF) configuration'
section: Security
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-15
review_in: 3 months
---

Web Application Firewall (WAF) rules enable blocking potentially
malicious/suspect requests at the edge of the network before they can reach the applications.

## How to configure WAF rules

WAF rules are confgiured via terraform and associated to infrastructure
resources such as load balancers.

The rules are maintained alongside the configuration for the public load
balancers in [govuk-aws/terraform/projects/infra-public-services](https://github.com/alphagov/govuk-aws/tree/master/terraform/projects/infra-public-services).
For instructions on how to deploy the terraform projects see [deploying terraform](/manual/deploying-terraform.html)

For documentation on the kinds of rules:

* [AWS WAF Documentation](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)
* [Terraform WAF Rule Documentation](https://www.terraform.io/docs/providers/aws/r/wafregional_rule.html)




