---
owner_slack: "#govuk-2ndline"
title: Get started on GOV.UK
description: Guide for new developers on GOV.UK
layout: manual_layout
section: Basics
last_reviewed_on: 2018-06-04
review_in: 3 months
---

This is the guide for new technical staff working on GOV.UK in [GDS][]. If you just joined, 👋 welcome!

Note that if you're not working for GDS you'll not be able to complete all of the steps in this guide.

Follow the steps on this page to get your GOV.UK development environment running with a [VirtualBox][] VM, managed and configured by [Vagrant][].

> You'll need to use a Mac to follow this guide.

It will take you roughly one day to do everything in this guide from start to finish. There are lots of things to download, and loads of installers need to do their thing.

> You'll need up to 150GB of free space on your hard-drive to run the whole of GOV.UK.

**Developing outside the VM**

You don't have to develop on the VM, but we strongly recommend it. If you have problems with the development VM you can always ask for help in the #govuk-developers Slack channel.

**Where you should run commands**

Run commands prepended with `mac$` on your Mac:

    mac$ echo "Think Different"

Run commands prepended with `dev$` in the development VM:

    dev$ echo "Linux for human beings"

Note: `dev$` and `mac$` are prompts within this guide and not part of the given command.

**If you run into problems**

If you're having trouble with Vagrant or the development VM, you can ask your colleagues or the #govuk-developers channel in Slack.

[GDS]: https://gds.blog.gov.uk/about/
[VirtualBox]: https://www.virtualbox.org/
[Vagrant]: https://www.vagrantup.com/

## 1. Install some dependencies

First, install:

* git command line tool: either from the Managed Software Center or from [git-scm][]
* [VirtualBox][]
* [Vagrant][]
* The vagrant-dns plugin (`vagrant plugin install vagrant-dns`)

[git-scm]: https://git-scm.com/downloads
[VirtualBox]: https://www.virtualbox.org/
[Vagrant]: https://www.vagrantup.com/downloads.html

Starting with High Sierra 10.13, kernel extensions must be approved by
the user (see [this Apple technical note][kext]).  This causes the
VirtualBox installer to fail with a permissions error.

[kext]: https://developer.apple.com/library/content/technotes/tn2459/_index.html

To install VirtualBox on High Sierra 10.13 or later:

1. Run the VirtualBox installer
2. Open "Security & Privacy" in the system preferences
3. Allow the blocked VirtualBox kernel extension
4. Run the VirtualBox installer again

## 2. Create your GitHub accounts

1. Set up a [GitHub][] account.
1. Ask somebody with access to add your GitHub username and SSH username (`firstnamelastname`) to the [user monitoring system][user-reviewer].
1. Ask your tech lead to add you to the [alphagov organisation][alphagov]. You will have to be added to the [GOV.UK team][govuk-team] to get access to repos & CI.
1. [Generate and register an SSH key pair][register-ssh-key] for your Mac for your GitHub account.
1. Import the SSH key into your keychain. Once you’ve done this, it’ll be available to the VM you'll install in the next step.

        mac$ /usr/bin/ssh-add -K your-private-key

1. Test that it all works by running `ssh -T git@github.com`.

[GitHub]: https://www.github.com/
[user-reviewer]: https://github.com/alphagov/govuk-user-reviewer
[alphagov]: https://github.com/alphagov
[govuk-team]: https://github.com/orgs/alphagov/teams/gov-uk/members
[register-ssh-key]: https://help.github.com/articles/connecting-to-github-with-ssh/

## 3. Create a user in integration and CI

User accounts in our integration and CI environments are managed in the [govuk-puppet][] repository.

    mac$ mkdir ~/govuk
    mac$ cd ~/govuk
    mac$ git clone git@github.com:alphagov/govuk-puppet.git

To create a new account, start by creating an SSH key at least 4096 bits long. For example:

    mac$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/alphagov

Import the SSH key into your keychain.

    mac$ /usr/bin/ssh-add -K ~/.ssh/alphagov

Now create a user manifest in `~/govuk/govuk-puppet/modules/users/manifests` with your username and the public key you just created. Your username should use the `firstnamelastname` format.

Add the name of your manifest (your username) into the list of `users::usernames` in [`hieradata_aws/integration.yaml`][integration-aws-hiera] for integration and in [`hieradata/integration.yaml`][integration-hiera] for CI.

Create a pull request with these changes. Once it has been [reviewed by a member of the GOV.UK team][rfcs], you can merge it and it will automatically deploy to the integration environment.

[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[integration-aws-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/integration.yaml
[integration-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/integration.yaml
[rfcs]: https://github.com/alphagov/govuk-rfcs/blob/master/rfc-052-pull-request-merging-process.md

## 4. Boot your VM

Run the VM bootstrap script:

    mac$ cd govuk-puppet/development-vm
    mac$ vagrant up
    mac$ vagrant dns --install

This will take a little while, but it will throw up a question or two in your console so check back on it occasionally. Now might be a good time to scan through the [GOV.UK technology blog][govuk-tech-blog] while Puppet runs.

Once your VM is running, you can SSH into it with:

    mac$ vagrant ssh

> See the full command list by typing `vagrant --help`

[govuk-tech-blog]: https://gdstechnology.blog.gov.uk/category/gov-uk/

### Set your Git username and email

You can assign your name and email to commits on the VM:

    dev$ git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    dev$ git config --global user.name "Friendly Giraffe"

### Config for ZSH users

If you use ZSH as your shell, you may find that the Ruby version on your VM is stuck on `1.9.3` and there seems to not be any other versions installed when you run `rbenv versions`.  To fix this, add `. /etc/profile` to your `.zshrc`.

## 5. Set up your apps

Begin by checking out all of the GOV.UK services. There's a handy shortcut:

    dev$ cd /var/govuk/govuk-puppet/development-vm
    dev$ ./checkout-repos.sh < alphagov_repos

Most of our apps are written in Ruby and use [Bundler][] to manage their dependencies. To boot apps, you’ll also need to install those dependencies:

    dev$ ./update-bundler.sh

There are also some Python apps, which use [PIP][]. You’ll probably need to install those dependencies too, so run:

    dev$ ./update-pip.sh

If installing the Python dependencies for fabric-scripts fails, your version of setuptools may be too old:

    dev$ cd /var/govuk/fabric-scripts
    dev$ virtualenv .venv
    dev$ source .venv/bin/activate
    dev$ pip install --upgrade setuptools
    dev$ pip install -r requirements.txt

> `~/govuk/` on your host machine is mounted as `/var/govuk` inside the VM. Any app repositories you clone should go here.

[Bundler]: http://bundler.io/rationale.html
[PIP]: https://pip.pypa.io/en/stable/

## 6. Access remote environments

Your pull request from earlier will hopefully have been merged by now. It's time to test your access to servers via SSH.

> If you're not in the office right now, you'll need to be connected to the GDS Office VPN for SSH access to integration.

While the applications are available directly via the public internet, SSH access to remote environments is via a ‘jumpbox’. You’ll need to configure your machine to use this jumpbox and use `govukcli` to SSH into server.

1. Copy the [example SSH config file][ssh-config] into the `~/.ssh/config` file on your host machine.
1. Run `ln -s ~/govuk/govuk-aws/tools/govukcli /usr/local/bin/govukcli` on your host machine to be able to use the `govukcli` tool from any directory.

Test that it works by running:

    mac$ govukcli set-context integration
    mac$ govukcli ssh backend

Next, follow the same steps inside your VM. You can choose whether to import your `alphagov` keypair to the VM or to use the built in key-forwarding. Test that you can reach integration from your VM:

    dev$ govukcli set-context integration
    dev$ govukcli ssh backend

[ssh-config]: https://github.com/alphagov/govuk-puppet/blob/master/development-vm/ssh_config

## 7. Import production data

Application data from production can be imported to be used within your development environment. Dumps of production data are generated in the early hours each day and made available from the integration environment.

Make sure you have the correct permissions to access the AWS integration account. To add permissions to assume role follow documentation on [adding your ARN to GOV.UK account role][add-your-arn].

>If you're unable to get permission, ask someone to give you a copy of their data. 

You will also need to configure an AWS profile for the integration environment, refer to documentation on [storing credentials on disk.][creds-on-disk]

After gaining access to the integration environment, download the data by running:

    mac$ cd ~/govuk/govuk-puppet/development-vm/replication
    mac$ ./replicate-data-local.sh -u $USERNAME -F ../ssh_config -n

You should then be prompted to enter your MFA token.

Once you have downloaded or obtained the data, run the following:

    dev$ cd /var/govuk/govuk-puppet/development-vm/replication
    dev$ ./replicate-data-local.sh -d backups/YYYY-MM-DD/ -s

Replace YYYY-MM-DD with the current date.

> Downloading and decompressing the data may take a long time. Depending on your application you may not need all the data. 

> Run `./replicate-data-local.sh --help` for options to skip databases.

For more information or troubleshooting advice see the guide in the developer docs on [replicating application data locally for development][data-replication].

[creds-on-disk]: user-management-in-aws.html#storing-credentials-on-disk
[add-your-arn]: user-management-in-aws.html#add-your-arn-to-govuk-account-role
[data-replication]: replicate-app-data-locally.html
[data-replication-aws-access]: replicate-app-data-locally.html#aws-access

## 8. Run your apps

You can run any of the GOV.UK apps from the `/var/govuk/govuk-puppet/development-vm` directory. You’ll first need to run `bundle install` in this folder to install the required gems.

Since many of our apps depend on other apps, we normally run them using [bowler][] instead of foreman.

To run particular apps with bowler, use:

    dev$ bowl content-tagger

This will also run all of the dependencies defined in the `Pinfile`.

If you don't need an optional dependency, you can pass the `-w` option:

    dev$ bowl whitehall -w mapit

If these `bowl` commands fail, try the troubleshooting guide on [how to fix a broken bowl][bowl-error].

Now visit this URL once the app is running:

`http://whitehall-admin.dev.gov.uk/`

You should be able to see Whitehall.

[bowler]: https://github.com/JordanHatch/bowler
[bowl-error]: bowl-error.html

## 9. Keep your VM up to date

There are a few scripts that should be run regularly to keep your VM up to date. In `govuk-puppet/development-vm` there is `update-git.sh` and `update-bundler.sh` to help with this. Also, `govuk_puppet` should be run from anywhere on the VM regularly.

The following script will do all of this for you.

    dev$ cd /var/govuk/govuk-puppet/development-vm
    dev$ ./update-all.sh

This will run:

* `git pull` on each of the applications checked out in `/var/govuk`
* `govuk_puppet` to bring the latest configuration to the dev VM
* `bundle install` for each Ruby application to install any missing gems
* `pip install` to update runtime dependencies for any Python apps

## 10. Access the web frontend

Most GOV.UK web applications and services are available via the public internet, on the following forms of URL:

* [http://publisher.dev.gov.uk](http://publisher.dev.gov.uk) (local dev, requires the application to be running)
* [https://www-origin.integration.publishing.service.gov.uk](https://www-origin.integration.publishing.service.gov.uk) (integration, HTTP basic auth)
* [https://deploy.staging.publishing.service.gov.uk](https://deploy.staging.publishing.service.gov.uk) (staging, restricted to GDS office IP addresses)
* [https://alert.publishing.service.gov.uk](https://alert.publishing.service.gov.uk) (production, restricted to GDS office IP addresses)

The basic authentication username and password is widely known, so just ask somebody on your team if you don't know it.

If you can't resolve `dev.gov.uk` domains, see [fix issues with vagrant-dns](vagrant-dns.html).
