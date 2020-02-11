---
owner_slack: "#govuk-dev-tools"
title: Problems provisioning and fetching packages in VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-12
review_in: 6 months
---

> **Note**
>
> Make sure you are running the latest versions of VirtualBox and Vagrant.
> Specifically, Vagrant 1.8.x versions have known issues with provisioning.

GOV.UK has an apt repository at [https://apt.publishing.service.gov.uk/]. This is
not accessible on the internet, so if you're trying to provision the
virtual machine outside of the GDS office, you will need to connect to the
VPN before running `vagrant provision`.

You may also need to run `sudo apt-get update` if you get errors such as:

```shell
E: Unable to locate package rbenv-ruby-2.4.0
E: Couldn't find any package by regex 'rbenv-ruby-2.4.0'
```

## Bundler permissions error on provision

If you see the following error when running `vagrant up` or `vagrant provision`:

```shell
/usr/lib/ruby/1.9.1/fileutils.rb:247:in 'mkdir': Permission denied - /Users (Errno::EACCES)`
```

Make sure that no bundler config already exists (if you have bundled outside of
the development VM).

You can remove this in the govuk-puppet directory:

`rm -r ~/govuk/govuk-puppet/.bundle`

## `librarian:install` fails due to permission errors

If you see `chown`/`OperationNotPermitted` errors during the `librarian:install` rake task,
try running `vagrant provision` on your host machine.
