---
owner_slack: "#govuk-developers"
title: Get SSH access to integration
layout: manual_layout
section: Accounts
last_reviewed_on: 2019-11-11
review_in: 6 months
---

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

## 3. Set up govukcli

Clone the `govuk-aws` repository and add a symlink to make `govukcli` executable globally:

```sh
cd ~/govuk
git clone git@github.com:alphagov/govuk-aws
ln -s ~/govuk/govuk-aws/tools/govukcli /usr/local/bin/govukcli
```

## 4. Access remote environments

Your pull request from earlier will hopefully have been merged by now. It's time to test your access to servers via SSH.

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

## Running a console
Once you have SSH'd into a machine, you can also open a console for a particular application so you can execute commands, for example:

```
govuk_app_console publishing-api
```

[ssh-config]: https://github.com/alphagov/govuk-puppet/blob/master/development-vm/ssh_config
