---
owner_slack: "#govuk-2ndline-tech"
title: Terraform Cloud
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK uses Terraform Cloud as a centralised interface for running Terraform.

## Getting Terraform Cloud access

You can sign up for Terraform Cloud and join the GOV.UK organisation yourself. You will need to be a member of the [Technical 2nd Line Support](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/2nd-line-support) Google Group, or the [GOV.UK Terraform Cloud Access](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/GOV.UK_Terraform_Cloud_Access/members) group.

1. Follow this link to [join the GOV.UK Terraform Cloud organisation](https://accounts.google.com/o/saml2/initsso?idpid=C01ppujwc&spid=738388265440&forceauthn=false). By connecting your digital.cabinet-office.gov.uk Google account, you'll be granted access to the GOV.UK organisation.
2. After connecting Google, you'll be asked to create a Terraform Cloud account (or sign in if you already have one), as [SSO does not automatically provision Terraform Cloud user accounts](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/single-sign-on#sso-identities-and-terraform-cloud-user-accounts). You'll need to set an account password, however, once the SSO identity is linked, you'll only log in to the GOV.UK organization using the linked (Google) account.
3. You should now have access to [workspaces in the GOV.UK organisation](https://app.terraform.io/app/govuk/workspaces).

If you have problems following any of the above steps, you might be missing from the required Google Group. Ask over in the [#govuk-platform-engineering](https://gds.slack.com/channels/govuk-platform-engineering) Slack channel for help.
