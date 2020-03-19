---
owner_slack: "#govuk-developers"
title: Get started on GOV.UK
description: Guide for new developers on GOV.UK
layout: manual_layout
section: Learning GOV.UK
last_reviewed_on: 2019-12-05
review_in: 3 months
---

This is the guide for new technical staff working on GOV.UK in [GDS][]. If you just joined, 👋 welcome!

If they haven't done so yet, ask your tech lead to take you through the [overview slides][overview-slides].

If you're having trouble with this guide, you can ask your colleagues or the #govuk-developers channel in Slack.

[GDS]: https://gds.blog.gov.uk/about/
[overview-slides]: https://docs.google.com/presentation/d/1nAE65Og04JYNAc0VjYaUYLqNLuUOM9r3Mvo0PGFy_Zk

## 1. Set up your GitHub account

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

## 2. Set up govuk-docker

We use a Docker environment - [govuk-docker][] - for local development.

👉 [Learn about how we use Docker](/manual/intro-to-docker.html)

👉 [Get setup with govuk-docker][govuk-docker]

[govuk-docker]: https://github.com/alphagov/govuk-docker/blob/master/docs/installation.md

## 3. Get SSH access to integration

### Get access

Ask somebody with access to add your SSH username (`firstnamelastname`) to the [user monitoring system][user-reviewer].

[user-reviewer]: https://github.com/alphagov/govuk-user-reviewer

### Create a user to SSH into integration

User accounts in our integration environments are managed in the [govuk-puppet][] repository.

    mac$ mkdir ~/govuk
    mac$ cd ~/govuk
    mac$ git clone git@github.com:alphagov/govuk-puppet.git

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

### Set up govukcli

Clone the `govuk-aws` repository and add a symlink to make `govukcli` executable globally:

```sh
cd ~/govuk
git clone git@github.com:alphagov/govuk-aws
ln -s ~/govuk/govuk-aws/tools/govukcli /usr/local/bin/govukcli
```

### Access remote environments

Your pull request from earlier will hopefully have been merged by now. If it's been longer than 30 minutes since the merge, it would have been deployed, too. It's time to test your access to servers via SSH.

> If you're not in the office right now, you'll need to be connected to the GDS Office VPN for SSH access to integration.

While the applications are available directly via the public internet, SSH access to remote environments is via a ‘jumpbox’. You’ll need to configure your machine to use this jumpbox and use `govukcli` to SSH into server.

Copy the [example SSH config file][ssh-config] into the `~/.ssh/config` file on your host machine.

Test that it works by running:

    mac$ govukcli set-context integration
    mac$ govukcli ssh backend

You should be able to do the same thing in your VM:

    dev$ govukcli set-context integration
    dev$ govukcli ssh backend

The built-in key-forwarding should mean that you don't need to edit the `~/.ssh/config` file inside the VM (it will default to your host machine's config file instead).

#### Running a console
Once you have SSH'd into a machine, you can also open a console for a particular application so you can execute commands, for example:

```
govuk_app_console publishing-api
```

[ssh-config]: https://github.com/alphagov/govuk-puppet/blob/master/development-vm/ssh_config

## 4. Get AWS access

To work with [govuk-aws](https://github.com/alphagov/govuk-aws) and [govuk-aws-data](https://github.com/alphagov/govuk-aws-data),
you will require an account in AWS.

### Request a GDS AWS account

GDS maintains a central account for AWS access. You will need to request an account from the Technology and Operations team.

👉 [Request an AWS account](https://gds-request-an-aws-account.cloudapps.digital)

You'll want to click "Request user access" - NOT "Request an account". After submitting the form, you should receive an email to say your account creation is in progress, and later another email saying the work has been completed. You can then move onto step 2.

### Sign in to AWS

To sign in, go to [the GDS AWS Sign page](https://gds-users.signin.aws.amazon.com/console), and use the following credentials:

- "Account ID or alias": `gds-users`
- Username: your `@digital.cabinet-office.gov.uk` email address
- Password: your password

👉 [Sign in to AWS GDS account](https://gds-users.signin.aws.amazon.com/console)

### Set up your MFA

You have to set up [Multi-Factor Authentication (MFA)][MFA].

1. [Sign in to AWS GDS account](https://gds-users.signin.aws.amazon.com/console)
2. Select or go to IAM service.
3. Click on "Users" in the menu bar on the left hand side
4. Enter your name
5. Click on the link for your email address
6. Click on the security credentials tab
7. Click on the "Manage" link next to "Assigned MFA device"
8. Follow the steps to set up your MFA device

### Generate a pair of access keys

You have to generate an AWS Access Key and Secret Key to be able to
perform operations with AWS on the command-line.

1. [Sign in to the gds-users AWS Console](https://gds-users.signin.aws.amazon.com/console).
1. Click on your email address in the top right.
1. Click 'My Security Credentials'.
1. Click 'Create access key'.
1. Copy/paste them into the inputs that the gds-cli provides for you,
   if you're following [the setup instructions](/manual/access-aws-console.html).

#### Changing your MFA device

1. Follow steps 1 to 7 in [set up your MFA](#set-up-your-mfa)
1. Choose one of the two options (Remove or Resync)
2. Click on the "Manage" link next to "Assigned MFA device"
3. Follow the steps to set up your MFA device. If you're using a
   Yubikey, you must choose "TOTP" device, not "U2F" device, for the
   gds-cli to continue working.

### Get the appropriate access

An account in AWS doesn't give you access to anything, you'll need to be given rights.

Add yourself to a lists of users found in [the data for the infra-security project][infra-terra]. There are 5 groups:

- `govuk-administrators`: people in Reliability Engineering who are working on GOV.UK infrastructure
- `govuk-internal-administrators`: people in GOV.UK who are working on GOV.UK infrastructure including Architects, Lead Developers and anyone else working on the AWS migration
- `govuk-powerusers`: anyone else who can have production access on GOV.UK
- `govuk-platformhealth-powerusers`: as above but for members of the GOV.UK Platform Health team
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

### Do your thing 🚀

You can now:

👉 [Access AWS via the web interface or on the command line][access-aws-console]

👉 [Deploy AWS infrastructure with Terraform](/manual/deploying-terraform.html)

[access-aws-console]: /manual/access-aws-console.html
[infra-terra]: https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security
[MFA]: https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication
[iam]: https://console.aws.amazon.com/iam/home?region=eu-west-1#/users
