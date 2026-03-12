---
owner_slack: "#govuk-developers"
title: Get started developing on GOV.UK
description: Guide for new developers on GOV.UK
layout: manual_layout
section: Learning GOV.UK
---

> This getting started guide is for new technical staff (for example developers, technical architects) working on GOV.UK in [GDS][]. Please note this guidance is only for the GOV.UK programme of GDS, it is not for Digital Identity, Digital Services Platforms or any other part of GDS.

If you're having trouble with this guide, you can ask your colleagues on the [#govuk-developers Slack channel](https://gds.slack.com/archives/CAB4Q3QBW).

[GDS]: https://gds.blog.gov.uk/about/

## Before you start

You will need to know who your tech lead is, as you will need them for some of these steps.

If you are on a team that does not have a tech lead, or you are the tech lead, please contact the Lead Developer in your area or email [GOV.UK senior tech](/manual/ask-for-help.html#contact-senior-tech) with details on who you are and what team you've joined, so that they can help.

You should have been given a GDS "developer build" laptop with full admin access. To find out, try running `sudo whoami` in your terminal. It should prompt for your local account password and print `root` if you entered your password correctly.

If you don't have admin access to your laptop, file a ticket with the IT helpdesk and copy your line manager.

## 1. Install the Xcode command-line tools

Run the following in your command line to install the Xcode command line tools:

```sh
xcode-select --install
```

## 2. Install the Homebrew package manager

To install the [Homebrew package manager](https://brew.sh):

1. Download the latest .pkg from the [Homebrew releases](https://github.com/Homebrew/brew/releases/)
1. Double click on the downloaded .pkg file, and complete the installer steps

## 3. Fill out your Slack profile

You should already have access to Slack. If not, please talk with your line manager.

Help others know who you are by [updating your Slack profile's 'title' field](https://slack.com/intl/en-gb/help/articles/204092246-Edit-your-profile). This should include:

- your job role
- the team you're working on
- the name of your organisation, if you're not directly employed by GDS / Cabinet Office

## 4. Set up your AWS IAM user account

1. [Request a AWS user account][request-aws-user].
1. You should receive an email when your account is created.
1. Follow instructions in the email to sign into the `gds-users` AWS account for the first time.
1. [Enable Multi-factor Authentication (MFA)][enable-mfa] for your IAM User.

> <strong>You must specify your email address as the MFA device name.</strong>

![Screenshot of the Add MFA Device dialog in the AWS console](images/aws/assign-mfa-device.png)

You should [use your Yubikey as your MFA device][yubikey-aws-mfa] if you have one.

[aws-account-info]: https://reliability-engineering.cloudapps.digital/iaas.html#amazon-web-services-aws
[iam-role-creation]: #6-get-permissions-for-aws-github-and-other-third-party-services
[request-aws-user]: https://request-an-aws-user.digital.cabinet-office.gov.uk/user
[enable-mfa]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-iam-user
[yubikey-aws-mfa]: /manual/setup-a-yubikey.html#set-up-as-an-mfa-device-for-aws
[aws-cli-auth]: https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html#cli-authentication-user-get

## 5. Set up your GitHub account

1. [Log into your existing GitHub account](https://github.com/login) or [create a new one](https://github.com/signup).
1. [Add your GDS email address to your GitHub account][associate-email-github], which can be in addition to your personal email address.
1. [Generate an SSH key].
1. [Add the SSH key to your GitHub account][add-ssh-key].
1. Check that you can access GitHub using the new key:

    ```sh
    ssh -T git@github.com
    ```

1. Add your name and email to your git commits. For example:

    ```sh
    git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    git config --global user.name "Friendly Giraffe"
    ```

[associate-email-github]: https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-user-account/managing-email-preferences/adding-an-email-address-to-your-github-account
[Generate an SSH key]: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
[add-ssh-key]: https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

## 6. Get permissions for AWS, GitHub and other third party services

Permissions to GOV.UK's AWS, [GitHub], [Fastly] and [Pagerduty] accounts are managed by the [govuk-user-reviewer](https://github.com/alphagov/govuk-user-reviewer) private repository. You won't be able to see this repo until you are added to the alphagov GitHub organisation.

Ask your tech lead to follow the [instructions] in govuk-user-reviewer to grant you access.

For [Sentry], your tech lead should manually add you via the Sentry UI. Once you've been added, you can [sign in](https://sentry.io/auth/login/) using your GDS Google account.

[Fastly]: /manual/cdn.html
[GitHub]: /manual/github.html
[Sentry]: /manual/sentry.html
[Pagerduty]: /manual/pagerduty.html
[govuk-user-reviewer]: https://github.com/alphagov/govuk-user-reviewer
[instructions]: https://github.com/alphagov/govuk-user-reviewer#adding-users

## 7. Install and configure the GDS CLI

> [!NOTE]
> You must be a member of the [alphagov GitHub org](https://github.com/alphagov/) (see previous step) to proceed.

On GOV.UK we use `gds-cli` for AWS access. Follow the instructions on the [repo's README](https://github.com/alphagov/gds-cli) to install/configure the tool.

## 8. Connect to the GDS VPN

> This step might not be necessary if you are a contractor. Ask your tech lead.

If you're outside of the office or on [GovWiFi](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/we-are-gds/service-design-and-assurance/govwifi), you must connect to the GDS VPN to use some internal Cabinet Office services (e.g. SOP and the intranet).

###  For GDS issued MacBooks

Follow the [GDS guidance on how to sign into the GDS VPN using Google credentials][gds-vpn-wiki].

###  For Bring Your Own Devices (BYOD)

Follow the [VPN guide for Bring Your Own Devices (BYOD)](https://docs.google.com/document/d/150JX1xiWdXY29ahcYUMb05Si-hEAZvtkGAKojT9Rjis/edit#)

[gds-it-helpdesk]: https://gdshelpdesk.digital.cabinet-office.gov.uk/helpdesk/WebObjects/Helpdesk.woa
[gds-vpn-wiki]: https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/edit

## 9. Set up GOV.UK Docker

We use a [Docker](/manual/intro-to-docker.html) environment for local development, [GOV.UK Docker](https://github.com/alphagov/govuk-docker).

To set up GOV.UK Docker, see the [installation instructions in the `govuk-docker` GitHub repo](https://github.com/alphagov/govuk-docker#installation).

> If you are a frontend developer, you may be able to use [alternative approaches to local development](/manual/local-frontend-development.html) if you prefer to avoid GOV.UK Docker.

## 10. Set up tools to use the GOV.UK Kubernetes clusters

Follow [the instructions for getting started with the GOV.UK Kubernetes clusters](/kubernetes/get-started/).

## 11. Get Signon accounts

[Signon](/repos/signon.html) controls access to the GOV.UK Publishing applications.

Ask your tech lead for:

- a 'Superadmin' privileged account in [**integration** Signon](https://signon.integration.publishing.service.gov.uk/users/invitation/new)
- a 'Normal' account in [**production** Signon](https://signon.publishing.service.gov.uk/users/invitation/new) with access to the 'Release' app **only** and no other apps

Production Signon accounts are copied automatically to the staging environment overnight, so you will have access to staging the next day.

## 12. Get familiar with the Release app

[Release](/repos/release.html) is the application we use to track deployments, work out which branch/tag is deployed to each environment.

> Your tech lead will have granted access to the Release app in the step above.

## 13. Talk to your tech lead about supporting services you should have access to

Depending on your role and the team you've joined, you will likely need access to some other services. Your tech lead will know which ones you will need and can arrange access. For example:

- [Logit](/manual/logit.html#accessing-logit) for reading application logs and request logs. New developers typically need access to logs for the integration environment.
- [Zendesk](/manual/zendesk.html) for working with user support tickets.
- [Google Analytics](/manual/analytics.html) for analysing trends in user behaviour. Most new developers won't need this at first.
- [Terraform](/manual/terraform-cloud.html) for reviewing and applying infrastructure changes.

## Supporting information

Now you have completed the get started process, you should look at the following supporting information:

- the [architectural deep dive of GOV.UK][architectural-deep-dive]
- GOV.UK's [conventions for Rails applications](/manual/conventions-for-rails-applications.html)

[architectural-deep-dive]: /manual/architecture-deep-dive.html
[govuk-aws-data-users-group]: /manual/set-up-aws-account.html#4-get-the-appropriate-access
[infra-terra]: https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security
[MFA]: https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication
[iam]: https://console.aws.amazon.com/iam/home?region=eu-west-1#/users
