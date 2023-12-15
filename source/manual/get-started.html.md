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

You should determine who your tech lead is in your team, as there are a number of steps that require their involvement.

If you are on a team that does not have a tech lead, or you are the tech lead, please contact the Lead Developer in your area or email [GOV.UK senior tech](mailto:govuk-senior-tech-members@digital.cabinet-office.gov.uk) with details on who you are and what team you've joined, so that they can help.

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

## 3. Set up your Slack profile

As part of your onboarding to GDS you will have been given access to Slack - if you've not got this please talk to your tech lead.

Help others know who you are by [updating your Slack profile's 'title' field](https://slack.com/intl/en-gb/help/articles/204092246-Edit-your-profile). This should include:

- your job role
- the team you're working on
- if relevant, the name of your supplier

## 4. Set up your AWS IAM User

GDS has a central `gds-users` AWS account where you create your IAM User. Your [tech lead will then create IAM Roles][iam-role-creation] that you can assume for access to GOV.UK's AWS accounts. The [reliability engineering site][aws-account-info] has more information on how AWS accounts are structured.

1. [Request a AWS IAM User][request-aws-user] for the central `gds-users` AWS account.
1. You should receive an email when your account is created.
1. Follow instructions in the email to sign into the `gds-users` AWS account for the first time.
1. [Enable Multi-factor Authentication (MFA)][enable-mfa] for your IAM User.

***Important - You must specify your email address as the MFA device name.***

If you were issued a Yubikey, you can [use it as a MFA device][yubikey-aws-mfa].

[aws-account-info]: https://reliability-engineering.cloudapps.digital/iaas.html#amazon-web-services-aws
[iam-role-creation]: #6-get-permissions-for-aws-github-and-other-third-party-services
[request-aws-user]: https://gds-request-an-aws-account.cloudapps.digital/
[enable-mfa]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-iam-user
[yubikey-aws-mfa]: /manual/setup-a-yubikey.html#set-up-as-an-mfa-device-for-aws
[aws-cli-auth]: https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html#cli-authentication-user-get

## 5. Set up your GitHub account

1. [Login into your existing GitHub account][github-login] or [create a new GitHub account][github-signup].
1. [Associate your GitHub account with your GDS email address][associate-email-github], which can be in addition to your personal email address.
1. [Add the SSH key to your GitHub account][add-ssh-key].
1. Test that the SSH key works by running `ssh -T git@github.com`.
1. Add your name and email to your git commits. For example:

    ```
    $ git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    $ git config --global user.name "Friendly Giraffe"
    ```

[github-login]: https://www.github.com/login
[github-signup]: https://www.github.com/signup
[associate-email-github]: https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-user-account/managing-email-preferences/adding-an-email-address-to-your-github-account
[add-ssh-key]: https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

## 6. Get permissions for AWS, GitHub and other third party services

Permissions to GOV.UK's AWS, [GitHub], [Fastly], [Sentry] and [Pagerduty] accounts are managed by the [govuk-user-reviewer](https://github.com/alphagov/govuk-user-reviewer) repository. This is a private repository so will 404 before joining GOV.UK's GitHub.

Ask your tech lead to follow the [instructions] in govuk-user-reviewer to grant you access. *You must complete steps 1-5 first*.

[Fastly]: /manual/cdn.html
[GitHub]: /manual/github.html
[Sentry]: /manual/sentry.html
[Pagerduty]: /manual/pagerduty.html
[govuk-user-reviewer]: https://github.com/alphagov/govuk-user-reviewer
[instructions]: https://github.com/alphagov/govuk-user-reviewer#addingremoving-users

## 7. Install and configure the GDS CLI

On GOV.UK we use the [`gds-cli`](https://github.com/alphagov/gds-cli) for AWS and SSH access.

1. Run the following install GDS CLI:

    ```bash
    brew tap alphagov/gds
    brew install gds-cli govuk-connect
    brew install --cask aws-vault
    ```

    The GDS CLI repository is private, so your tech lead must have first completed [step 6](#6-get-permissions-for-aws-github-and-other-third-party-services) to provide you with the necessary access.

1. Test that installation was successful by running `gds --help`  and `gds govuk connect --help`.

    If you see a `fatal: no such path in the working tree` error, that's because you're using ZSH, which has `gds` set up as a Git alias. To solve this, you can either:
      - remove that alias by adding `unalias gds` to your `~/.zshrc`
      - use `gds-cli` instead of `gds` for all the relevant commands

1. Configure the GDS CLI by running:

    ```bash
    gds config email <FIRSTNAME>.<LASTNAME>@digital.cabinet-office.gov.uk
    ```

1. Set up AWS credentials:

    1. [Create an AWS access key][create-aws-access-key] via the [console][gds-users-aws-signin].
    1. Run a GDS CLI command to prompt for credentials. For example `gds aws govuk-integration-readonly -l`.
    1. Enter your Access Key ID and Secret Access Key
    1. Enter your AWS MFA token
    1. When prompted, save credentials to your Mac's keychain as `aws-vault` and set a password for the keychain. Save that password somewhere safe, for example in a password manager.

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

If you have a GDS-issued Yubikey, you can run `gds config yubikey true` in the GDS CLI to set GDS CLI to automatically pull the MFA code from your Yubikey.

You have completed the get started process. You can now use `gds aws` to run generic [aws CLI](https://aws.amazon.com/cli/) commands by prefixing them with `gds aws <role>`. For example:

```shell
gds aws govuk-integration-readonly aws s3 ls
```

[gds-users-aws-signin]: https://gds-users.signin.aws.amazon.com/console
[create-aws-access-key]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey

## 8. Connect to the GDS VPN

If you're outside of the office or on [GovWiFi](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/we-are-gds/service-design-and-assurance/govwifi), you must connect to the GDS VPN to access to our infrastructure and internal services.

###  For GDS issued MacBooks

Follow the [GDS guidance on how to sign into the GDS VPN using Google credentials][gds-vpn-wiki].

###  For Bring Your Own Devices (BYOD)

Follow the [VPN guide for Bring Your Own Devices (BYOD)](https://docs.google.com/document/d/150JX1xiWdXY29ahcYUMb05Si-hEAZvtkGAKojT9Rjis/edit#)

[gds-it-helpdesk]: https://gdshelpdesk.digital.cabinet-office.gov.uk/helpdesk/WebObjects/Helpdesk.woa
[gds-vpn-wiki]: https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/edit

## 9. Set up GOV.UK Docker

We use a [Docker](/manual/intro-to-docker.html) environment for local development, [GOV.UK Docker](https://github.com/alphagov/govuk-docker).

To set up GOV.UK Docker, see the [installation instructions in the `govuk-docker` GitHub repo](https://github.com/alphagov/govuk-docker#installation).

> If you are a frontend developer, and you are working on GOV.UK's frontend apps, there is documentation on [alterntaive local development approaches](/manual/local-frontend-development.html) that make low or no usage of GOV.UK Docker.

## 10. Get SSH access to integration

> If you are a frontend developer you do not need to complete this step as part of your initial setup.

### Create a user to SSH into integration

User accounts in our integration environments are managed in the [govuk-puppet][] repository.

1. Run the following command to create a `govuk` folder in your home directory and clone the `govuk-puppet` GitHub repo:

    ```bash
    mkdir ~/govuk
    cd ~/govuk
    git clone git@github.com:alphagov/govuk-puppet.git
    ```

1. Add your SSH key which you created in [step 2](#2-generate-a-ssh-key).

    If you do not have a YubiKey, run `more ~/.ssh/id_ed25519.pub` to retrieve your public key. The key should begin with `ssh-ed25519 AAA`. If you have an existing RSA public key you could add that instead, although ed25519 keys are preferable. An RSA public key will start with `ssh-rsa AAA`. You may need to manually add the email address to the end of your key.

    If you have a YubiKey, run `ssh-add -L` to retrieve the key from your device. The key should end with `cardno:000000000000`.

1. Create a user manifest file at `~/govuk/govuk-puppet/modules/users/manifests/<firstnamelastname>.pp` with the following code:

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
    class users::johnsmith {
      govuk_user { 'johnsmith':
        fullname => 'John Smith',
        email    => 'john.smith@digital.cabinet-office.gov.uk',
        ssh_key  => 'ssh-ed25519 AAAAC37eiue0923jfwnfwle93fnwefwn john.smith@digital.cabinet-office.gov.uk',
      }
    }
    ```

1. Add the name of your user class (`<firstnamelastname>`) into the list of `users::usernames` in [`hieradata_aws/integration.yaml`][integration-aws-hiera].

1. Create a pull request with these changes and ask your tech lead to review it.

    Once the pull request has been [reviewed][merging], you can merge it and the pull request will automatically deploy to the integration environment.

[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[integration-aws-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/integration.yaml
[merging]: /manual/merge-pr.html

### Access remote environments and server

Once your pull request with your user manifest file is merged and deployed, you should test your SSH access to remote environments and servers.

If you are outside of the office or on GovWiFi, you must first [connect to the GDS VPN](#8-connect-to-the-gds-vpn).

Test your SSH access by running:

```bash
gds govuk connect --environment integration ssh jumpbox
```

If you see an error `Permission denied`, check the message shown later, similar to: `The SSH username used was: jsmith` - if this is not the user you specified in the puppet config above, you need to specify a username:

```bash
USER=jaysmith gds govuk connect --environment integration ssh jumpbox
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

## 11. Set up tools to use the GOV.UK Kubernetes platform

Follow [the instructions for setting up tools to use the GOV.UK Kubernetes platform](/kubernetes/get-started/set-up-tools/).

## 12. Get a Signon account for integration

[Signon](/repos/signon.html) is the application used to control access to the GOV.UK Publishing applications.

Ask your tech lead to [create an account for the integration Signon](https://signon.integration.publishing.service.gov.uk/users/invitation/new), at 'Superadmin' level with permission to access the applications that your team are likely to work on.

## 13. Get access to the Release app

[Release](/repos/release.html) is the application we use to track deployments,
work out which branch/tag is deployed to each environment and link to Jenkins to deploy code.

Ask your tech lead to [create an account for the production Signon](https://signon.publishing.service.gov.uk/users/invitation/new), at 'Normal' level with access to the 'Release' app only. No permissions should be given for other applications, until [production access](/manual/rules-for-getting-production-access.html) is granted.

## 14. Talk to your tech lead about supporting services you should have access to

Depending on the team you've joined, you will likely need access to other supporting services to fulfil your role. Talk to your tech lead about which ones you need as part of onboarding and they can arrange access. Services you may need access to are:

- [Logit](/manual/logit.html#accessing-logit) - the software we use for access application logs, where new starters are given access to the integration environment
- [Google Analytics](/manual/analytics.html) - the software we use to track user behaviour, typically only needed if you work on a team working frequently with analytics
- [Zendesk](/manual/zendesk.html) - the software we use for tracking support tickets, typically access isn't needed until working as part of the [2nd line](/manual/2nd-line.html) support team

## Supporting information

Now you have completed the get started process, you should look at the following supporting information:

- the [architectural deep dive of GOV.UK][architectural-deep-dive]
- GOV.UK's [conventions for Rails applications](/manual/conventions-for-rails-applications.html)

[architectural-deep-dive]: /manual/architecture-deep-dive.html
[govuk-aws-data-users-group]: /manual/set-up-aws-account.html#4-get-the-appropriate-access
[infra-terra]: https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security
[MFA]: https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication
[iam]: https://console.aws.amazon.com/iam/home?region=eu-west-1#/users
