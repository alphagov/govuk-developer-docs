---
owner_slack: "#govuk-platform-health"
title: Scale Mapit
layout: manual_layout
parent: "/manual.html"
section: Infrastructure
related_applications:
  - mapit
---

Mapit has a scaling process that is different to other GOV.UK applications.

To scale Mapit, follow these steps:

1. Edit the [Mapit machine Terraform](https://github.com/alphagov/govuk-aws/blob/a8217e42ee95b25da434fb27ab39788555a9448a/terraform/projects/app-mapit/main.tf#L157-L191) to include a `module mapit-<number>`, `resource "aws_erb_volume" "mapit-<number>"` and `resource "aws_iam_role_policy_attachment" "mapit_<number>_iam_role_policy_attachment"` block for each instance, e.g. for 4 instances you would need a `mapit-1`, `mapit-2`, `mapit-3` and `mapit-4`. You can copy an existing block and change the numbers.

1. [Deploy the Terraform](/manual/deploying-terraform.html).

1. [Make the Mapit database available to each machine](/manual/mapit-database-not-available.html).
