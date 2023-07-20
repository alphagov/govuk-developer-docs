---
owner_slack: "#govuk-developers"
title: Get started developing on GOV.UK
description: Guide for new developers on GOV.UK
layout: manual_layout
section: Learning GOV.UK
---

> This getting started guide is for new technical staff (for example developers, technical architects) working on GOV.UK in [GDS][]. Please note this guidance is only for the GOV.UK programme of GDS, it is not for Digital Identity, Digital Services Platforms or any other part of GDS.

Ask your tech lead to take you through the [overview slides][overview-slides] if they have not already done so.

If you're having trouble with this guide, you can ask your colleagues on the [#govuk-developers Slack channel](https://gds.slack.com/archives/CAB4Q3QBW) or using email.

[GDS]: https://gds.blog.gov.uk/about/
[overview-slides]: https://docs.google.com/presentation/d/1nAE65Og04JYNAc0VjYaUYLqNLuUOM9r3Mvo0PGFy_Zk
[govuk-user-reviewer]: https://github.com/alphagov/govuk-user-reviewer

## Before you start

> You must update your Slack profile to include details of:
> - your role
> - which team you're in
> - your GitHub handle
> - why you need access
>
> This is to help people ascertain if you should have access. Your Tech Lead should also be helping to make requests to other teams for you.

You must have a laptop with full admin access. To check if you have full admin access, run a `sudo` command in your command line. For example, `sudo ls`.

If you do not have full admin access to your laptop, ask your line manager to ask IT to provide you with a developer build on your laptop.

Once you have full admin access on your laptop, run the following in your command line to install the Xcode command line tool:

```
xcode-select --install
```

## 1. Install the Homebrew package manager

Run the following in your command line to install the [Homebrew package manager](https://brew.sh):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

This command works for macOS or Linux.

## 2. Generate a SSH key

### If you have a YubiKey

If you have a YubiKey, you will use `gpg-agent` in place of `ssh-agent`, which requires a GPG key to have been generated.

1. Create a GPG key as per the [Create a GPG Key][create-gpg-key] documentation.

1. Add the following to the `~/.gnupg/gpg-agent.conf` file:

   ```
   enable-ssh-support
   pinentry-program /usr/local/bin/pinentry-mac
   default-cache-ttl 60
   max-cache-ttl 120
   ```

1. Add the following to your `~/.zprofile` file:

   ```
   export GPG_TTY=$(tty)
   export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
   gpgconf --launch gpg-agent
   ```

1. Run `killall gpg-agent` to stop any running `gpg-agent` processes.

1. Run `ssh-add -L`. This will output your public SSH key, which should end `cardno:000000000000` (indicating it is from a YubiKey).

### If you do not have a YubiKey

1. [Generate a new SSH key for your laptop and add it to the ssh-agent][generate-ssh-key] for your GitHub account.

1. Add the following code into your `.zshrc`, `~/.bash_profile`, or equivalent so that it is persistent between restarts:

   ```
   $ /usr/bin/ssh-add -K <YOUR-PRIVATE-KEY>
   ```

[create-gpg-key]: /manual/create-a-gpg-key.html
[generate-ssh-key]: https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## 3. Set up your GitHub account

1. Set up a [GitHub] account (or use your existing personal account).
1. [Associate your GitHub account with your GDS email address][associate-email-github], which can be in addition to your personal email address.
1. [Get added to the alphagov org and the "GOV.UK" team](https://docs.publishing.service.gov.uk/manual/github-access.html).
1. [Add the SSH key to your GitHub account][add-ssh-key].
1. Test that the SSH key works by running `ssh -T git@github.com`.
1. Add your name and email to your git commits. For example:

    ```
    $ git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    $ git config --global user.name "Friendly Giraffe"
    ```

[GitHub]: https://www.github.com/
[associate-email-github]: https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-user-account/managing-email-preferences/adding-an-email-address-to-your-github-account
[add-ssh-key]: https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

## 4. Install GDS command line tools

On GOV.UK we use the following command-line tools for AWS and SSH access:

- [`govuk-connect`](https://github.com/alphagov/govuk-connect)
- [`gds-cli`](https://github.com/alphagov/gds-cli)

1. To install these command line tools, run the following in the command line:

    ```bash
    brew tap alphagov/gds
    brew install gds-cli govuk-connect
    brew install --cask aws-vault
    ```

    The GDS CLI repository is private, so you must first [set up your GitHub account](#3-set-up-your-github-account).

1. Test that both tools work by running `gds --help` and `gds govuk connect --help`.

    If you see a `fatal: no such path in the working tree` error, that's because you're using ZSH, which has `gds` set up as a Git alias. To solve this, you can either:
      - remove that alias by adding `unalias gds` to your `~/.zshrc`
      - use `gds-cli` instead of `gds` for all the relevant commands

1. Configure the GDS CLI by running:

    ```bash
    gds config email <FIRSTNAME>.<LASTNAME>@digital.cabinet-office.gov.uk
    ```

1. Run `gds config yubikey false` if you use your phone as an Multi-Factor Authentication (MFA) device.

    Run `gds config yubikey true` if you use a Yubikey.

## 5. Connect to the GDS VPN

If you're outside of the office or on [GovWiFi](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/we-are-gds/service-design-and-assurance/govwifi), you must connect to the GDS VPN to access to our infrastructure and internal services.

###  For GDS issued MacBooks

Follow the [GDS guidance on how to sign into the GDS VPN using Google credentials][gds-vpn-wiki].

###  For Bring Your Own Devices (BYOD)

Follow the [VPN guide for Bring Your Own Devices (BYOD)](https://docs.google.com/document/d/150JX1xiWdXY29ahcYUMb05Si-hEAZvtkGAKojT9Rjis/edit#)

[gds-it-helpdesk]: https://gdshelpdesk.digital.cabinet-office.gov.uk/helpdesk/WebObjects/Helpdesk.woa
[gds-vpn-wiki]: https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/edit

## 6. Get added to the GOV.UK user monitor system

We store who has access to GOV.UK tooling in a git repo, [GOV.UK User Reviewer][govuk-user-reviewer] and use automation to alert when people should not have access. It's a private repo so you won't be able to access it until step 3 is completed.

Get your tech lead to create a pull request to add you to the [tech users](https://github.com/alphagov/govuk-user-reviewer/blob/main/config/govuk_tech.yml). The repo readme specifies the [format new starters should have, with integration admin access](https://github.com/alphagov/govuk-user-reviewer/tree/main#properties-in-the-config-file). The `ssh_username` is in the format of `firstnamelastname` and is utilised in [8. Get SSH access to integration](#7-get-ssh-access-to-integration)).

If you are working with us as a contractor from a supplier, please include the supplier's name in the `why_do_they_need_access` field.

## 7. Set up GOV.UK Docker

We use a `govuk-docker` Docker environment for local development.

To set up GOV.UK Docker, see the [installation instructions in the `govuk-docker` GitHub repo][govuk-docker].

You can also try developing outside of Docker, using tools like [rbenv](https://github.com/rbenv/rbenv) directly. [This approach generally works for frontend apps](https://docs.publishing.service.gov.uk/manual/local-frontend-development.html) but not for other apps with databases, etc., and is not officially supported.

[govuk-docker]: https://github.com/alphagov/govuk-docker/blob/master/README.md

## 8. Get SSH access to integration

If you are a frontend developer you do not need to complete this step as part of your initial setup.

### Create a user to SSH into integration

User accounts in our integration environments are managed in the [govuk-puppet][] repository.

1. Run the following command to create a `govuk` folder in your home directory and clone the `govuk-puppet` GitHub repo:

    ```bash
    mkdir ~/govuk
    cd ~/govuk
    git clone git@github.com:alphagov/govuk-puppet.git
    ```

1. Add your SSH key which you created in [step 2](#generate-a-ssh-key).

   If you do not have a YubiKey, run `more ~/.ssh/id_ed25519.pub` to retrieve your public key. The key should begin with `ssh-ed25519 AAA` and end with `== <WORK EMAIL>`. If you have an existing RSA public key you could add that instead, although ed25519 keys are preferable. An RSA public key will start with `ssh-rsa AAA`. You may need to manually add the email address to the end of your key.

   If you have a YubiKey, run `ssh-add -L` to retrieve the key from your device. The key should end with `cardno:000000000000`.

1. Create a user manifest file at `~/govuk/govuk-puppet/modules/users/manifests/<FIRSTNAMELASTNAME>.pp` with the following code:

    ```
    # Creates the <FIRSTNAMELASTNAME> user
    class users::<FIRSTNAMELASTNAME> {
      govuk_user { '<FIRSTNAMELASTNAME>':
        fullname => 'FIRSTNAME LASTNAME',
        email    => 'WORK EMAIL',
        ssh_key  => '<SSH-PUBLIC-KEY-VALUE>',
      }
    }
    ```

    Enter your information and SSH public key value into the file. For example:

    ```
    # Creates the johnsmith user
    class users::<johnsmith> {
      govuk_user { '<johnsmith>':
        fullname => 'John Smith',
        email    => 'john.smith@digital.cabinet-office.gov.uk',
        ssh_key  => '<SSH-PUBLIC-KEY-VALUE>',
      }
    }
    ```

1. Add the name of your user manifest file (`<FIRSTNAMELASTNAME>.pp`) into the list of `users::usernames` in [`hieradata_aws/integration.yaml`][integration-aws-hiera].

1. Create a pull request with these changes and ask a developer in your team to review it.

    Once the pull request has been [reviewed][merging], you can merge it and the pull request will automatically deploy to the integration environment.

[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[integration-aws-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/integration.yaml
[merging]: /manual/merge-pr.html

### Access remote environments and server

Once your pull request with your user manifest file is merged and deployed, you should test your SSH access to remote environments and servers.

If you are outside of the office or on GovWiFi, you must first [connect to the GDS VPN](#4-connect-to-the-gds-vpn).

Test your SSH access by running:

```bash
gds govuk connect --environment integration ssh backend
```

If you see an error `Permission denied`, check the message shown later, similar to: `The SSH username used was: jsmith` - if this is not the user you specified in the puppet config above, you need to specify a username:

```bash
USER=jaysmith gds govuk connect --environment integration ssh backend
```

(or you can `export USER=jaysmith` separately to set it for a shell session)

If you see an error similar to `no matching host key type found. Their offer: ssh-rsa,ssh-dss` you will have to change your ssh configuration - this is an issue with OSX Ventura (and possibly other operating systems) - see [this StackOverflow issue](https://stackoverflow.com/questions/74215881/visual-studio-2022-wont-connect-via-ssh-on-macos-after-upgrading-to-ventura)

You need to add the following into your ssh config (e.g. `~/.ssh/config`):

```text
Host *
  HostkeyAlgorithms +ssh-rsa
  PubkeyAcceptedAlgorithms +ssh-rsa
```

Note this may happen even if you don't use an rsa ssh private key - it is caused by the _host key_ which is defined by the server you connect to, not your _user key_ which you have defined.

#### Running a console

Once you have SSH access into a remote environment or server, you can also open a Rails app console for a particular application so you can run commands.

For example, to open a console for GOV.UK Publisher, run the following on a `backend` machine:

```bash
$ govuk_app_console publisher
```

As a shortcut, to remove the need to look up the machine class for an application, you can use the following without SSHing first:

```bash
gds govuk connect --environment integration app-console publisher
```

## 9. Get AWS access

If you are a frontend developer you do not need to complete this step as part of your initial setup.

GDS maintains a central account for AWS access.

You must have access to this GDS account to work with [govuk-aws](https://github.com/alphagov/govuk-aws) and [govuk-aws-data](https://github.com/alphagov/govuk-aws-data).

The notes below are a summary - the definitive guide lives [on the reliability engineering site](https://reliability-engineering.cloudapps.digital/iaas.html#amazon-web-services-aws).

### Request access to the GDS AWS account

You request access to the GDS AWS account through the [Request an AWS account form](https://gds-request-an-aws-account.cloudapps.digital).

Select __Request user access__ to request access to the GDS AWS account and complete the form.

After submitting the form, you should receive an email to say your account creation is in progress, and later another email saying the work has been completed.

### Sign in to AWS

To sign in, go to [the `gds-users` AWS console][gds-users-aws-signin], and enter:

- `gds-users` in __Account ID or alias__
- your `@digital.cabinet-office.gov.uk` email address in __Username__
- your AWS account password in __Password__

### Set up Multi-Factor Authentication

You must set up [Multi-Factor Authentication (MFA)][MFA] to access AWS.

You may add up to 8 MFA devices. However, note that __MFA device names must be prefixed with your IAM username (usually your email address)__, otherwise you will receive a permissions error.

How you set up MFA depends on whether you have a GDS-issued Yubikey or not.

#### If you do not have a Yubikey

Use the following instructions to set up your MFA device.

1. Sign in to the [`gds-users` AWS console][gds-users-aws-signin].
1. Select the __IAM__ service.
1. Select __Users__ in the left hand menu and enter your name.
1. Select the link for your email address.
1. Select the __Security credentials__ tab.
1. Select __Manage__, which is next to __Assigned MFA device__.
1. Specify your email address as the entire MFA device name. Do __not__ add anything else to the name, or will receive a permissions error.
1. Follow the instructions to set up your MFA device.

#### If you have a Yubikey

1. Download the [Yubico Authenticator](https://www.yubico.com/products/yubico-authenticator/) app to your computer (or mobile device, if your Yubikey supports NFC).
1. Sign in to the [`gds-users` AWS console][gds-users-aws-signin].
1. Select the __IAM__ service.
1. Select __Users__ in the left hand menu and enter your name.
1. Select the link for your email address.
1. Select the __Security credentials__ tab.
1. Select __Manage__, which is next to __Assigned MFA device__.
1. Specify your email address as the MFA device name
1. When asked to scan the QR code with your mobile device, open the Yubico Authenticator app and use that to scan the QR code. The MFA code will now be present on your Yubikey.
1. Configure gds-cli to use the YubiKey:

```
gds config yubikey true
```

### Generate a pair of access keys

You must generate an AWS access key ID and secret access key to be able to perform operations with AWS on the command line.

1. Sign in to the [`gds-users` AWS console][gds-users-aws-signin].
1. Select your email address in the top right of the screen.
1. Select __My Security Credentials__.
1. Select __Create access key__.
1. Make a note of your AWS access key ID and secret access key for when you [access AWS for the first time](#8-access-aws-for-the-first-time).

[gds-users-aws-signin]: https://gds-users.signin.aws.amazon.com/console

### Get access to integration infrastructure

You must get access to the integration infrastructure so you can deploy to integration.

To get access, you must add your email address to the list of `role_user_user_arns` users in the `govuk-aws-data` GitHub repo.

Open a pull request to add the following code to the `role_user_user_arns` section in the [`infra-security/integration/common.tfvars` file in the `govuk-aws-data` repo](https://github.com/alphagov/govuk-aws-data/blob/master/data/infra-security/integration/common.tfvars).

```
arn:aws:iam::<account-ID>:user/<firstname.lastname>@digital.cabinet-office.gov.uk
```

Use the same `<account-ID>` as other entries in the `role_user_user_arns` section.

See this [example pull request](https://github.com/alphagov/govuk-aws-data/pull/758/files) for more information.

After your pull request has been merged, someone with production access will need to deploy the
`infra-security` project to integration, by assuming the `govuk-integration-admin` role.
See [Deploy Terraform](https://docs.publishing.service.gov.uk/manual/deploying-terraform.html)
to find out how to deploy infrastructure changes. The stackname is `govuk` and the project is
`infra-security`.

See the [AWS IAM users documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) for more information.

## 10. Access AWS for the first time

If you are a frontend developer you do not need to complete this step as part of your initial setup.

1. Open the [GDS CLI](#3-install-gds-command-line-tools) and run `gds aws govuk-integration-readonly -l` to open the AWS console in your web browser.
1. In the GDS CLI, enter your [AWS access key ID and secret access key](#generate-a-pair-of-access-keys).
1. Enter your [MFA token](#set-up-multi-factor-authentication) in the command line.

    Here is an example of the output you'll see:

    ```shell
    $ gds aws govuk-integration-readonly -l
    Welcome to the GDS CLI! We will now store your AWS credentials in the keychain using aws-vault.
    Enter Access Key ID: <YOUR-ACCESS-KEY-ID>
    Enter Secret Access Key: <YOUR-SECRET-ACCESS-KEY>
    Added credentials to profile "gds-users" in vault
    Successfully initialised gds-cli
    Enter token for arn:aws:iam::123456789012:mfa/firstname.lastname@digital.cabinet-office.gov.uk: 123456
    ```

1. When prompted, save credentials to your Mac's keychain as `aws-vault` and set a password for the keychain. Save that password somewhere safe, for example in a password manager.

If you have a GDS-issued Yubikey, you can run `gds config yubikey true` in the GDS CLI to set GDS CLI to automatically pull the MFA code from your Yubikey.

You have completed the get started process. You can now use `gds aws` to run generic [aws CLI](https://aws.amazon.com/cli/) commands by prefixing them with `gds aws <role>`. For example:

```shell
$ gds aws govuk-integration-readonly aws s3 ls
```

### Reset your AWS vault password

If you forget your `aws-vault` password, you must reset that password.

1. Delete the `aws-vault` keychain by running `rm ~/Library/Keychains/aws-vault.keychain-db` in the command line.
1. Re-initialise the `gds-cli` by opening `~/.gds/config.yml` and changing `initialised: true` to `initialised: false`.

## 11. Set up tools to use the GOV.UK Kubernetes platform

Follow [the instructions for setting up tools to use the GOV.UK Kubernetes platform](https://govuk-k8s-user-docs.publishing.service.gov.uk/get-started/set-up-tools/).

## 12. Get a Signon account for integration

[Signon](https://docs.publishing.service.gov.uk/repos/signon.html) is the application used to control access to the
GOV.UK Publishing applications.

Ask another developer to [create an account for the integration Signon](https://signon.integration.publishing.service.gov.uk/users/invitation/new),
at 'Superadmin' level with permission to access the applications that your team are likely to work on.

## 13. Get access to the Release app

[Release](https://docs.publishing.service.gov.uk/repos/release.html) is the application we use to track deployments,
work out which branch/tag is deployed to each environment and link to Jenkins to deploy code.

Ask someone with production access (e.g. your tech lead or buddy) to [create an account for the production
Signon](https://signon.publishing.service.gov.uk/users/invitation/new), at 'Normal' level with access to
the 'Release' app only. No permissions should be given for other applications, until [production access](/manual/rules-for-getting-production-access.html)
is granted.

## 15. Talk to your tech lead about supporting services you should have access to

Depending on the team you've joined, you will likely need access to other supporting services to fulfil your role. Talk to your tech lead about which ones you need as part of onboarding and they can arrange access (or escalate to their allocated Lead Developer) to provide access. Services you may need access to are:

- [Sentry](/manual/sentry.html) - the error monitoring software we use
- [Logit](/manual/logit.html#accessing-logit) - the software we use for access application logs, where new starters are given access to the integration environment
- [Google Analytics](/manual/analytics.html) - the software we use to track user behaviour, typically only needed if you work on a team working frequently with analytics
- [Zendesk](/manual/zendesk.html) - the software we use for tracking support tickets, typically access isn't needed until working as part of the [2nd line](/manual/2nd-line.html) support team

## Supporting information

Now you have completed the get started process, you should look at the following supporting information:

- the [architectural deep dive of GOV.UK][architectural-deep-dive]
- [how GDS uses Docker](/manual/intro-to-docker.html)

[architectural-deep-dive]: /manual/architecture-deep-dive.html
[govuk-aws-data-users-group]: /manual/set-up-aws-account.html#4-get-the-appropriate-access
[infra-terra]: https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security
[MFA]: https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication
[iam]: https://console.aws.amazon.com/iam/home?region=eu-west-1#/users
