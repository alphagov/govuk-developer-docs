---
owner_slack: "#govuk-developers"
title: Get SSH access to integration
layout: manual_layout
section: Accounts
last_reviewed_on: 2019-11-11
review_in: 6 months
---

## 0. Pre-requisites

Install the [Homebrew](https://brew.sh) package manager on macOS or Linux.

## 1. Get access

Ask somebody with access to add your SSH username (`firstnamelastname`) to the [user monitoring system][user-reviewer].

[user-reviewer]: https://github.com/alphagov/govuk-user-reviewer

## 2. Create a user to SSH into integration

User accounts in our integration environments are managed in the [govuk-puppet][] repository.

    mac$ mkdir ~/govuk
    mac$ cd ~/govuk
    mac$ git clone git@github.com:alphagov/govuk-puppet.git

Now create a user manifest in `~/govuk/govuk-puppet/modules/users/manifests` with your username and the public key you [created when you set up your GitHub account](/manual/github-setup.html). Your username should use the `firstnamelastname.pp` format.

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

## 3. Set up SSH access

Install GDS-wide and GOV.UK tooling via the GDS Homebrew tap:

```
brew tap alphagov/gds
brew install gds-cli govuk-connect
```

You'll be using more of the GDS CLI's features when you [set up your
AWS account](/manual/set-up-aws-account.html). For now, we're focusing
on SSH.

The easiest way to use `govuk-connect` is via the GDS CLI, so you
don't have to context-switch between tools for AWS access vs. SSH.

The `gds govuk connect --help` command will get you started. This
shortens to `gds govuk c`.

## 4. Access remote environments

Your pull request from earlier will hopefully have been merged by now. It's time to test your access to servers via SSH.

```
gds govuk connect -e integration ssh backend
```

> If you're not in the office right now, you'll need to be connected to the GDS Office VPN for SSH access to integration.

## Running a console
Once you have SSH'd into a machine, you can also open a console for a particular application so you can execute commands, for example:

```
govuk_app_console publishing-api
```

[ssh-config]: https://github.com/alphagov/govuk-puppet/blob/master/development-vm/ssh_config
