---
owner_slack: "#govuk-developers"
title: Get started on GOV.UK
description: Guide for new developers on GOV.UK
layout: manual_layout
section: Learning GOV.UK
---

This is the guide for new technical staff working on GOV.UK in [GDS][]. If you just joined, 👋 welcome!

If they haven't done so yet, ask your tech lead to take you through the [overview slides][overview-slides].

If you're having trouble with this guide, you can ask your colleagues or the #govuk-developers channel in Slack.

[GDS]: https://gds.blog.gov.uk/about/
[overview-slides]: https://docs.google.com/presentation/d/1nAE65Og04JYNAc0VjYaUYLqNLuUOM9r3Mvo0PGFy_Zk

## 1. Install the [Homebrew package manager](https://brew.sh) (on macOS or Linux)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

## 2. Set up your GitHub account

1. Set up a [GitHub] account. Existing personal accounts are fine to use.
1. Ask your tech lead to add you to the [alphagov organisation][alphagov]. You will have to be added to the [GOV.UK team][govuk-team] to get access to repos & CI. Remember to click accept in the GitHub email invitation.
1. Ask somebody with access to add your GitHub username to the [user monitoring system][user-reviewer].
1. [Generate and register an SSH key pair][register-ssh-key] for your laptop for your GitHub account. You should use a `4096` bit key.
1. Import the SSH key into your keychain. Once you’ve done this, you'll be able to clone repos over SSH.

    ```
    $ /usr/bin/ssh-add -K your-private-key
    ```

1. Add the above line into your `~/.bash_profile` or equivalent so that it is persistent between restarts.

1. Test that it all works by running `ssh -T git@github.com`.

1. While you're here, associate your name and email to your git commits:

    ```
    $ git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    $ git config --global user.name "Friendly Giraffe"
    ```

[alphagov]: https://github.com/alphagov
[GitHub]: https://www.github.com/
[govuk-team]: https://github.com/orgs/alphagov/teams/gov-uk/members
[register-ssh-key]: https://help.github.com/articles/connecting-to-github-with-ssh/
[user-reviewer]: https://github.com/alphagov/govuk-user-reviewer

## 3. Install GDS tooling

On GOV.UK we use two command-line tools day-to-day: [`govuk-connect`](https://github.com/alphagov/govuk-connect) and the [`gds-cli`](https://github.com/alphagov/gds-cli) for AWS, SSH and VPN access.

To install these, run:

```bash
brew tap alphagov/gds
brew install gds-cli govuk-connect
```

The GDS CLI repository is private, so you'll need to follow the GitHub setup instructions above for the download to work.

Test that both tools work by running `gds --help` and `gds govuk connect --help`.

> If you see `fatal: no such path in the working tree`, it's because you're using ZSH, which has `gds` set up as a Git alias. You can either remove that alias by adding `unalias gds` to your `~/.zshrc`, or use `gds-cli` instead of `gds` for all the relevant commands.

The GDS CLI requires some initial configuration:

```bash
gds config email firstname.lastname@digital.cabinet-office.gov.uk
gds config yubikey false # If you type MFA codes from your phone
```

## 4. Connecting to the GDS VPN

Access to our infrastructure and internal services is controlled by IP safelisting. If you're outside of the office or not on the Brattain network (ie, you're on GovWiFi), you'll need to connect to the GDS VPN to access our stuff.

To do this, read [the GDS Wiki page about the VPN][gds-vpn-wiki] to ensure you have the required pre-requisites, for example the Cisco AnyConnect software installed on your computer, and an MFA token given to you when you arrived by GDS IT. If you don't have these, [contact the IT helpdesk][gds-it-helpdesk].

The `gds-cli` tool that we installed earlier has a `vpn` subcommand.

To connect to the VPN, run `gds vpn connect` and you'll be asked for a password and MFA code. The password is the one you use to login to your GDS-issued laptop, printers, or the Cisco AnyConnect VPN GUI.

To disconnect, run `gds vpn disconnect`.

If you're here, you're probably using a GDS-issued laptop. If for any reason you're on your own device, or a GDS-issued Linux laptop, you'll need to run `gds vpn configure-byod-profiles` first as the non-GDS-assured VPN is a little different.

[gds-it-helpdesk]: https://gdshelpdesk.digital.cabinet-office.gov.uk/helpdesk/WebObjects/Helpdesk.woa
[gds-vpn-wiki]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/it-the-white-chapel-building/how-to/gds-vpn

## 5. Set up govuk-docker

We use a Docker environment - [govuk-docker][] - for local development.

👉 [Learn about how we use Docker](/manual/intro-to-docker.html)

👉 [Get setup with govuk-docker][govuk-docker]

[govuk-docker]: https://github.com/alphagov/govuk-docker/blob/master/docs/installation.md

## 6. Get SSH access to integration

### Get access

Ask somebody with access to add your SSH username (`firstnamelastname`) to the [user monitoring system][user-reviewer].

[user-reviewer]: https://github.com/alphagov/govuk-user-reviewer

### Create a user to SSH into integration

User accounts in our integration environments are managed in the [govuk-puppet][] repository.

```bash
mkdir ~/govuk
cd ~/govuk
git clone git@github.com:alphagov/govuk-puppet.git
```

Now create a user manifest in `~/govuk/govuk-puppet/modules/users/manifests` with your username and the public key you created when you set up your GitHub account above. Your file should use the `firstnamelastname.pp` format.

```
class users::johnsmith {
  govuk_user { 'johnsmith':
    fullname => 'John Smith',
    email    => 'john.smith.123@digital.cabinet-office.gov.uk',
    ssh_key  => 'this public key will be a few lines long (copy the output from `more ~/.ssh/alphagov.pub`). It should begin with `ssh-rsa AAA` and end with `== john.smith.123@digital.cabinet-office.gov.uk`. You may need to add the email address to the end of your public key manually.',
  }
}
```

Add the name of your manifest (your username) into the list of `users::usernames` in [`hieradata_aws/integration.yaml`][integration-aws-hiera] for integration and in [`hieradata/integration.yaml`][integration-hiera] for CI.

Create a pull request with these changes. Once it has been [reviewed by a member of the GOV.UK team][merging], you can merge it and it will automatically deploy to the integration environment.

[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[integration-aws-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/integration.yaml
[integration-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/integration.yaml
[merging]: /manual/merge-pr.html

### Access remote environments

Your pull request from earlier will hopefully have been merged by now. If it's been longer than 30 minutes since the merge, it would have been deployed, too. It's time to test your access to servers via SSH.

> If you're not in the office right now, you'll need to be [connected to the GDS office VPN](#connect-to-gds-vpn) for SSH access to integration.

Test that it works by running:

```bash
gds govuk connect --environment integration ssh backend
```

The commands can be shortened to `gds govuk c -e integration ssh backend` if you wish.

#### Running a console

Once you have SSH'd into a machine, you can also open a console for a particular application so you can execute commands, for example:

```bash
govuk_app_console transition
```

## 7. Get AWS access

To work with [govuk-aws](https://github.com/alphagov/govuk-aws) and [govuk-aws-data](https://github.com/alphagov/govuk-aws-data),
you will require an account in AWS.

### Request a GDS AWS account

GDS maintains a central account for AWS access. You will need to request an account from the Technology and Operations team.

👉 [Request an AWS account](https://gds-request-an-aws-account.cloudapps.digital)

You'll want to click "Request user access" - NOT "Request an account". After submitting the form, you should receive an email to say your account creation is in progress, and later another email saying the work has been completed. You can then move onto step 2.

### Sign in to AWS

To sign in, go to [the GDS AWS Sign page][gds-users-aws-signin], and use the following credentials:

- "Account ID or alias": `gds-users`
- Username: your `@digital.cabinet-office.gov.uk` email address
- Password: your password

### Set up your MFA

You have to set up [Multi-Factor Authentication (MFA)][MFA].

1. [Sign in to AWS GDS account][gds-users-aws-signin]
1. Select or go to IAM service.
1. Click on "Users" in the menu bar on the left hand side
1. Enter your name
1. Click on the link for your email address
1. Click on the security credentials tab
1. Click on the "Manage" link next to "Assigned MFA device"
1. Follow the steps to set up your MFA device

> If you have a GDS-issued Yubikey, follow the [cross-GDS Yubikey docs](https://re-team-manual.cloudapps.digital/yubikeys.html#use-yubikey-for-2fa-in-amazon-web-services).

### Generate a pair of access keys

You have to generate an AWS Access Key and Secret Key to be able to
perform operations with AWS on the command-line.

1. [Sign in to the gds-users AWS Console][gds-users-aws-signin].
1. Click on your email address in the top right.
1. Click 'My Security Credentials'.
1. Click 'Create access key'.
1. Copy/paste them into the inputs that the gds-cli provides for you,
   if you're following [the setup instructions](#first-run).

[gds-users-aws-signin]: https://gds-users.signin.aws.amazon.com/console

#### Changing your MFA device

1. Follow steps 1 to 7 in [set up your MFA](#set-up-your-mfa)
1. Choose one of the two options (Remove or Resync)

### Get the appropriate access

An account in AWS doesn't give you access to anything, you'll need to be given rights.

Add yourself to a lists of users found in [the data for the infra-security project][infra-terra]. There are 5 groups:

- `govuk-administrators`: people in Reliability Engineering who are working on GOV.UK infrastructure
- `govuk-internal-administrators`: people in GOV.UK who are working on GOV.UK infrastructure including Architects, Lead Developers and anyone else working on the AWS migration
- `govuk-powerusers`: anyone else who can have production access on GOV.UK
- `govuk-platformhealth-powerusers`: as above but for members of the GOV.UK Platform Health team. (Same access rights as above, we just have limits on the number of users per role).
- `govuk-users`: anyone else who needs integration access on GOV.UK

> Note: There is a limit on the number of people that can be in each group. If you find that the limit has been hit, try and identify any users who no longer need access and can be removed. Otherwise, a new group will need to be created.

The identifier you need to add is called the "User ARN". You can find this by going
to the [users page in AWS IAM][iam] and selecting your profile.

```
arn:aws:iam::<account-id>:user/<firstname.lastname>@digital.cabinet-office.gov.uk
```

After your PR has been merged, someone from the `govuk-administrators`
or `govuk-internal-administrators` group needs to deploy the
`infra-security` project.

## 8. Use your AWS access

### First run

Here, you will use the GDS CLI you [installed and set up earlier](#3-install-gds-tooling). You'll be asked for AWS credentials on the first run:

```shell
$ gds aws govuk-integration-poweruser -l
Welcome to the GDS CLI! We will now store your AWS credentials in the keychain using aws-vault.
Enter Access Key ID: AK-YOUR-ACCESS-KEY-ID
Enter Secret Access Key: blah blah
Added credentials to profile "gds-users" in vault
Successfully initialised gds-cli
Enter token for arn:aws:iam::123456789012:mfa/firstname.lastname@digital.cabinet-office.gov.uk: 123456
```

Your (Secret) Access Key is from the AWS console. Follow [the instructions to generate one](#generate-a-pair-of-access-keys). The token requested at the end is the [MFA token](#set-up-your-mfa). If you have a GDS-issued Yubikey (you probably don't at this stage), set `gds config yubikey true` and the GDS CLI will automatically pull the MFA code from your Yubikey.

You'll be prompted to save credentials to your Mac's Keychain as `aws-vault` and set a password for it. Save that password somewhere safe, like a password manager.

If you have `bash-completion` installed and configured, the gds-cli tab completions will work out of the box. They're especially useful for long commands like AWS account names.

### Re-initialising

If you forget your `aws-vault` password:

1. Delete the aws-vault keychain with `rm ~/Library/Keychains/aws-vault.keychain-db`
1. Re-initialise the `gds-cli` by changing `initialised: true` in `~/.gds/config.yml` to `initialised: false`.
1. Then re-run the "First run" commands above.

### Get Your Role

Work out which [list of users you're part of in govuk-aws-data][govuk-aws-data-users-group].
You're about to use it in the 'Web Console' section below.

### Usage

#### Web Console

If you're new to GOV.UK and want to look around in integration:

```bash
gds aws govuk-integration-readonly -l
```

Replace `readonly` with the non-pluralised version of your role name. For example,
if you want to assume the `govuk-powerusers` role on Staging, you would run
`gds aws govuk-staging-poweruser -l`.

`-l` opens the web browser and logs you in. For a full list of CLI parameters,
consult the [gds-cli README](https://github.com/alphagov/gds-cli).

#### Terraform

👉 [Deploy AWS infrastructure with Terraform](/manual/deploying-terraform.html)

#### Terminal commands

You can also chain commands, like this one to list S3 buckets in integration:

```bash
gds aws govuk-integration-poweruser aws s3 ls
```

## You're all done!

You're set up and ready to go. It might be worth reading and bookmarking
the [architectural deep-dive of GOV.UK][architectural-deep-dive] to
familiarise yourself with how things fit together.

[architectural-deep-dive]: /manual/architecture-deep-dive.html
[govuk-aws-data-users-group]: /manual/set-up-aws-account.html#4-get-the-appropriate-access
[infra-terra]: https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security
[MFA]: https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication
[iam]: https://console.aws.amazon.com/iam/home?region=eu-west-1#/users
