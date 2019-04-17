---
owner_slack: "#govuk-2ndline"
title: Get SSH access to integration
layout: manual_layout
section: Accounts
last_reviewed_on: 2019-02-08
review_in: 3 months
---

## 1. Get access

Ask somebody with access to add your SSH username (`firstnamelastname`) to the [user monitoring system][user-reviewer].

## 2. Create a user to SSH into integration

User accounts in our integration environments are managed in the [govuk-puppet][] repository.

    mac$ mkdir ~/govuk
    mac$ cd ~/govuk
    mac$ git clone git@github.com:alphagov/govuk-puppet.git

To create a new account, start by creating an SSH key at least 4096 bits long. For example:

    mac$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/alphagov

Import the SSH key into your keychain.

    mac$ /usr/bin/ssh-add -K ~/.ssh/alphagov

Now create a user manifest in `~/govuk/govuk-puppet/modules/users/manifests` with your username and the public key you just created. Your username should use the `firstnamelastname` format.

Add the name of your manifest (your username) into the list of `users::usernames` in [`hieradata_aws/integration.yaml`][integration-aws-hiera] for integration and in [`hieradata/integration.yaml`][integration-hiera] for CI.

Create a pull request with these changes. Once it has been [reviewed by a member of the GOV.UK team][merging], you can merge it and it will automatically deploy to the integration environment.

[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[integration-aws-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/integration.yaml
[integration-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/integration.yaml
[merging]: /manual/merge-pr.html

## 3. Access remote environments

Your pull request from earlier will hopefully have been merged by now. It's time to test your access to servers via SSH.

> If you're not in the office right now, you'll need to be connected to the GDS Office VPN for SSH access to integration.

While the applications are available directly via the public internet, SSH access to remote environments is via a ‘jumpbox’. You’ll need to configure your machine to use this jumpbox and use `govukcli` to SSH into server.

1. Copy the [example SSH config file][ssh-config] into the `~/.ssh/config` file on your host machine.
1. Run `ln -s ~/govuk/govuk-aws/tools/govukcli /usr/local/bin/govukcli` on your host machine to be able to use the `govukcli` tool from any directory.

Test that it works by running:

    mac$ govukcli set-context integration
    mac$ govukcli ssh backend

Next, you'll need to do the same thing inside your VM:

    dev$ sudo ln -s /var/govuk/govuk-aws/tools/govukcli /usr/local/bin/govukcli
    dev$ govukcli set-context integration
    dev$ govukcli ssh backend

The built-in key-forwarding should mean that you don't need to edit the `~/.ssh/config` file inside the VM (it will default to your host machine's config file instead).

[ssh-config]: https://github.com/alphagov/govuk-puppet/blob/master/development-vm/ssh_config
