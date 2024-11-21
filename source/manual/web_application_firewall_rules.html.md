---
owner_slack: "#govuk-platform-engineering"
title: 'Web Application Firewall (WAF) configuration'
section: Security
layout: manual_layout
parent: "/manual.html"
---

Web Application Firewall (WAF) rules enable blocking potentially
malicious/suspect requests at the edge of the network before they can reach the applications.

## How to configure WAF rules

WAF rules are configured via Terraform and associated to load balancers.

The rules are maintained in [govuk-aws/terraform/projects/infra-public-wafs](https://github.com/alphagov/govuk-aws/tree/main/terraform/projects/infra-public-wafs)
(alongside the configuration for the public load balancers in [govuk-aws/terraform/projects/infra-public-services](https://github.com/alphagov/govuk-aws/tree/main/terraform/projects/infra-public-services)).

For instructions on how to deploy the terraform projects see [deploying terraform](/manual/deploying-terraform.html).

For documentation on the kinds of rules:

* [AWS WAF Documentation](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)
* [Terraform WAF Rule Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl)

## Viewing logs for WAF

Our WAF ACLs are configured to log requests to Amazon CloudWatch log groups following the naming convention `aws-waf-logs-<acl>-public-<environment>`.
They can be live tailed or queried via the CloudWatch interface in the AWS console.

For the `cache_public` and `bouncer_public` WAF ACLs, we only log requests where the action is either `BLOCK` or `COUNT`. For the `backend_public` WAF ACL, we log all requests.

## Blocking requests by JA3 signature

[JA3 is a way of fingerprinting TLS connections](https://engineering.salesforce.com/open-sourcing-ja3-92c9e53c3c41/), which can be used to detect whether a connection comes from a particular browser, or another TLS client (like curl, python, or possibly malware). They are useful as a way to match botnet/malware traffic if there are no better criteria available. Their opaqueness is a disadvantage in that it's not possible to tell anything about what traffic they might apply to by reading the configuration.

Note that banning JA3s is potentially risky. If we get it wrong, we could ban a legitimate browser version.

The `backend_public` WAF ACL supports blocking requests by JA3 signature. The production denylist can be configured in
[govuk-aws-data/infra-public-wafs/production/common.tfvars](https://github.com/alphagov/govuk-aws-data/blob/main/data/infra-public-wafs/production/common.tfvars#L4)
([integration](https://github.com/alphagov/govuk-aws-data/blob/main/data/infra-public-wafs/integration/common.tfvars#L4),
[staging](https://github.com/alphagov/govuk-aws-data/blob/main/data/infra-public-wafs/staging/common.tfvars#L4)).

The `cache_public` and `bouncer_public` ACLs do not support JA3 denylisting, but this can instead be [configured at the CDN level](/manual/cdn.html#block-requests-based-on-their-ja3-signature).

## AWS Shield Response Team (SRT) access

We have pre-configured an [IAM role for the SRT team to use](https://github.com/alphagov/govuk-aws/pull/1550/files).

It is currently not assigned to any resources, but when activated will allow the SRT to view our shielded resources and edit things such as Web Application Firewall (WAF) rules, Access Control Lists (webacls), Shield and CloudFront configurations.

We should not enable the role unless we are [engaged with the team](https://docs.aws.amazon.com/waf/latest/developerguide/ddos-edit-drt.html) as a result of an incident.

To enable the role:

1. Open the AWS console for the affected environment, eg `gds aws govuk-integration-poweruser -l`
1. Navigate to the [Edit AWS Shield Response Team (SRT) access page](https://console.aws.amazon.com/wafv2/shieldv2#/drt_settings/edit)
1. In the AWS Shield Response Team (SRT) access section, select the "Choose an existing role for the SRT to access my accounts." radio button.
