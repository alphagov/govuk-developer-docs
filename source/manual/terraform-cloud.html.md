---
owner_slack: "#govuk-platform-engineering-team"
title: Terraform Cloud
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK uses Terraform Cloud as a centralised interface for running Terraform.

## Getting Terraform Cloud access

You can sign up for HashiCorp Cloud Platform (HCP) account, and then sign into Terraform Cloud using Single Sign On and join the GOV.UK organisation yourself. You will need to be a member of the [GOV.UK Terraform Cloud Access](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/GOV.UK_Terraform_Cloud_Access/members) group (or of a group that is a member of that group, such as [GOV.UK Technical On-Call Comms](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/gov-uk-technical-oncall-comms)).

***Note:*** You must create the account in step 1 below since [SSO does not automatically provision HCP user accounts](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/single-sign-on#sso-identities-and-terraform-cloud-user-accounts), and you must not create an HCP account using GitHub or SSO authentication, you must use a username and password.

1. Create a HashiCorp Cloud Platform (HCP) account from [the HCP sign-in page](https://portal.cloud.hashicorp.com/sign-in) (do not use GitHub authentication or SSO here, instead create a username and password)
2. HCP will email the address on your account, follow the link in that email to verify your email.
3. Follow [this link to join the GOV.UK Terraform Cloud organisation](https://accounts.google.com/o/saml2/initsso?idpid=C01ppujwc&spid=738388265440&forceauthn=false). By connecting your digital.cabinet-office.gov.uk Google account, you'll be granted access to the GOV.UK organisation.
4. After connecting Google, you'll be asked to sign into an HCP account, you should enter the username and password you set up in step 1. this will link your Google Account to your HCP account as a login for the GOV.UK Terraform Cloud organisation. Once the SSO identity is linked, you'll only log in to the GOV.UK organization using SSO with the linked Google account.
5. You must [enable Two-factor Authentication in Terraform Cloud](https://app.terraform.io/app/settings/two-factor) before you are able to access the GOV.UK organisation.
6. You should now have access to [workspaces in the GOV.UK organisation](https://app.terraform.io/app/govuk/workspaces).

If you have problems following any of the above steps, you might be missing from the required Google Group. Ask over in the [#govuk-ask-platform-engineering](https://gds.slack.com/channels/govuk-ask-platform-engineering) Slack channel for help.
