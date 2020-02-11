---
owner_slack: "#govuk-dev-tools"
title: GOV.UK Development VM setup instructions
description: Get started with the development VM (deprecated)
layout: manual_layout
section: Development VM
last_reviewed_on: 2020-01-22
review_in: 6 months
---

**Note that these instructions are deprecated in favour of [using govuk-docker](/manual/get-started.html), as of July 2019. Proceed at your own risk.**

This page describes setting up a local GOV.UK development environment with a [VirtualBox][] VM, managed and configured by [Vagrant][].

Note that if you're not working for GDS you'll not be able to complete all of the steps in this guide.

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

> **Note**
>
> `dev$` and `mac$` are prompts within this guide and not part of the given command.

**If you run into problems**

If you're having trouble with Vagrant or the development VM, you can ask your colleagues or the #govuk-developers channel in Slack.

[VirtualBox]: https://www.virtualbox.org/
[Vagrant]: https://www.vagrantup.com/

## 1. Install some dependencies

First, install:

* git command line tool: either from the Managed Software Center or from [git-scm][]
* [VirtualBox][]
* [Vagrant][]
* The vagrant-dns plugin (`vagrant plugin install vagrant-dns`)
* [rbenv][] (via Homebrew - `brew install rbenv` - you can install Homebrew via the Managed Software Center)

[git-scm]: https://git-scm.com/downloads
[VirtualBox]: https://www.virtualbox.org/
[Vagrant]: https://www.vagrantup.com/downloads.html
[rbenv]: https://github.com/rbenv/rbenv

Starting with High Sierra 10.13, kernel extensions must be approved by
the user (see [this Apple technical note][kext]).  This causes the
VirtualBox installer to fail with a permissions error.

[kext]: https://developer.apple.com/library/content/technotes/tn2459/_index.html

To install VirtualBox on High Sierra 10.13 or later:

1. Run the VirtualBox installer
2. Open "Security & Privacy" in the system preferences
3. Allow the blocked VirtualBox kernel extension
4. Run the VirtualBox installer again

If you have trouble installing the Vagrant DNS plugin due to Xcode version compatibility issues, you can try installing an older version of the plugin:

    mac$ vagrant plugin install vagrant-dns --plugin-version 1.1.0

## 2. Create your GitHub account

👉 [Set up your GitHub account](/manual/github-setup.html)

## 3. Set up your local workspace

Some processes are dependent on your local gov.uk setup being in `~/govuk`:

    mac$ mkdir ~/govuk
    mac$ cd ~/govuk
    mac$ git clone git@github.com:alphagov/govuk-puppet.git

### 3.1 Ensure your Ruby setup works

You'll want to install the [specific version of Ruby in govuk-puppet](https://github.com/alphagov/govuk-puppet/blob/master/.ruby-version#L1) (currently `rbenv install 1.9.3-p550`), as the default system Ruby is too locked-down.

Now verify that rbenv is working as expected:

    mac$ cd ~/govuk/govuk-puppet
    mac$ rbenv versions

This should output something like:

```
  system
* 1.9.3-p550 (set by /Users/yourname/govuk/govuk-puppet/.ruby-version)
```

    mac$ which ruby

This should output something like:

```
/Users/yourname/.rbenv/shims/ruby
```

If, instead, this outputs `/usr/bin/ruby`, then you'll need to update your `~/.bash_profile` to have `ruby` properly overridden in your `PATH`:

```bash
# force load rbenv to ensure correct version of ruby used
export PATH="$PATH:~/.rbenv/shims"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
```

This Ruby setup is a pre-requisite for the "[Import production data](#7-import-production-data)" step.

## 4. Boot your VM

Run the VM bootstrap script:

    mac$ cd ~/govuk/govuk-puppet/development-vm
    mac$ vagrant up
    mac$ vagrant dns --install

This will take a little while, but it will throw up a question or two in your console so check back on it occasionally. Now might be a good time to scan through the [GOV.UK technology blog][govuk-tech-blog] while Puppet runs.

Once your VM is running, you can SSH into it with:

    mac$ vagrant ssh

> See the full command list by typing `vagrant --help`

[govuk-tech-blog]: https://gdstechnology.blog.gov.uk/category/gov-uk/

### Config for ZSH users

If you use ZSH as your shell, you may find that the Ruby version on your VM is stuck on `1.9.3` and there seems to not be any other versions installed when you run `rbenv versions`.  To fix this, add `. /etc/profile` to your `.zshrc`.

## 5. Set up your apps

Begin by checking out all of the GOV.UK services. There's a handy shortcut:

    dev$ cd /var/govuk/govuk-puppet/development-vm
    dev$ ./checkout-repos.sh < alphagov_repos

Most of our apps are written in Ruby and use [Bundler][] to manage their dependencies. To boot apps, you’ll also need to install those dependencies:

    dev$ ./update-bundler.sh

There are also some Python apps, which use [pip][]. You’ll probably need to install those dependencies too, so run:

    dev$ ./update-pip.sh

If installing the Python dependencies fails, try and `cd` into each failing repository (e.g. `cd /var/govuk/fabric-scripts`) and remove the `.venv` directory (`rm -rf .venv`) before running the script again.

> `~/govuk/` on your host machine is mounted as `/var/govuk` inside the VM. Any app repositories you clone should go here.

[Bundler]: http://bundler.io/rationale.html
[pip]: https://pip.pypa.io/en/stable/

## 6. Get AWS access

👉 First, [set up your AWS account](/manual/set-up-aws-account.html)

👉 Then, [get credentials for CLI access to AWS](/manual/access-aws-console.html)

## 7. Import production data

Application data from production can be imported to be used within your development environment. Dumps of production data are generated in the early hours each day and made available from S3.

The scripts to download and import data in the dev VM directly no longer work, due to changes in how we manage AWS accounts.  Importing data is now a manual process.

Download the data using the scripts in govuk-docker:

```
mac$ git clone git@github.com:alphagov/govuk-docker.git
# or whatever database you want
mac$ SKIP_IMPORT=1 ./govuk-docker/bin/replicate-elasticsearch.sh
```

The replication scripts are:

- `replicate-elasticsearch.sh`
- `replicate-mongodb.sh APP-NAME`
- `replicate-mysql.sh APP-NAME`
- `replicate-postgresql.sh APP-NAME`

All the scripts, other than `replicate-elasticsearch.sh`, take the name of the app to replicate data for.

Draft data can be replicated with `replicate-mongodb.sh draft-content-store` and `replicate-mongodb.sh draft-router`.

If you've [set up your AWS account correctly](/manual/set-up-aws-account.html), you should then be prompted to enter your MFA token.

Once you have downloaded the data, it will be available in your dev VM at `/var/govuk/govuk-docker/replication`.

Import the data by looking at the replication script and seeing what it does with govuk-docker.  Good luck.

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

## 9. Access the web frontend 🚀

Most GOV.UK web applications and services are available via the public internet, on the following forms of URL:

* [http://publisher.dev.gov.uk](http://publisher.dev.gov.uk) (local dev, requires the application to be running)
* [https://www-origin.integration.publishing.service.gov.uk](https://www-origin.integration.publishing.service.gov.uk) (integration, HTTP basic auth)
* [https://deploy.staging.publishing.service.gov.uk](https://deploy.staging.publishing.service.gov.uk) (staging, restricted to GDS office IP addresses)
* [https://alert.publishing.service.gov.uk](https://alert.publishing.service.gov.uk) (production, restricted to GDS office IP addresses)

The basic authentication username and password is widely known, so just ask somebody on your team if you don't know it.

If you can't resolve `dev.gov.uk` domains, see [fix issues with vagrant-dns](/manual/vagrant-dns.html) or [VM access after using VPN](/manual/vm-vpn-issues.html).

## 10. Keep your VM up to date

There are a few scripts that should be run regularly to keep your VM up to date. In `govuk-puppet/development-vm` there is `update-git.sh` and `update-bundler.sh` to help with this. Also, `govuk_puppet` should be run from anywhere on the VM regularly.

The following script will do all of this for you.

```
dev$ cd /var/govuk/govuk-puppet/development-vm
dev$ ./update-all.sh
```

This will run:

* `git pull` on each of the applications checked out in `/var/govuk`
* `govuk_puppet` to bring the latest configuration to the dev VM
* `bundle install` for each Ruby application to install any missing gems
* `pip install` to update runtime dependencies for any Python apps
