---
owner_slack: "#2ndline"
title: Problems fetching packages in VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-28
review_in: 6 months
---

GOV.UK have an apt repository at http://apt.publishing.service.gov.uk/ This is
not accessible on the internet, so if you're trying to provision the
virtual machine outside of the GDS office, you will need to connect to the
VPN before running `vagrant provision`.

You may also need to run `sudo apt-get update` if you get errors that look
something like:

```shell
E: Unable to locate package rbenv-ruby-2.4.0
E: Couldn't find any package by regex 'rbenv-ruby-2.4.0'
```

## Bundler permissions error on provision

On `vagrant up` or `vagrant provision` you receive an error similar to:

```shell
/usr/lib/ruby/1.9.1/fileutils.rb:247:in 'mkdir': Permission denied - /Users (Errno::EACCES)`
```

Make sure that no bundler config already exists (if you have bundled outside of
the development VM).

You can remove this in the govuk-puppet directory:

`rm -r ~/govuk/govuk-puppet/.bundle`

## Are you using Vagrant 1.8.7?

If you use Vagrant 1.8.7 you may have this problem:

```shell
➜  development-vm git:(master) vagrant up
installing vagrant-dns plugin is recommended
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'govuk_dev_trusty64_20160323' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Box file was not detected as metadata. Adding it directly...
==> default: Adding box 'govuk_dev_trusty64_20160323' (v0) for provider: virtualbox
    default: Downloading: https://govuk-dev-boxes-test.s3.amazonaws.com/govuk_dev_trusty64_20160323.box
An error occurred while downloading the remote file. The error
message, if any, is reproduced below. Please fix this error and try
again.
```

It looks like a problem with this specific version of Vagrant. Using [version
1.8.6](https://releases.hashicorp.com/vagrant/1.8.6/) works instead
You can find more information about this issue [here](https://github.com/mitchellh/vagrant/issues/8002).

## `librarian:install` fails due to permission errors

Seeing `chown` / `OperationNotPermitted` errors during the `librarian:install` rake task?

Try `vagrant provision` on your host machine, as above.

## Hostname provisioning errors

If you use Vagrant 1.8.x, you may encounter an error along these lines during
provisioning:

```shell
Default: Setting hostname...
/opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/guests/ubuntu/cap/change_host_name.rb:37:in `block in init_package': unexpected return (LocalJumpError)
    from /opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/communicators/ssh/communicator.rb:222:in `call’
```

Updating to the latest version (v1.8.5+) might resolve this error. If not, try
`sudo vim`ing (or `sudo nano`, whichever you prefer) into that file and removing
the offending `return` line.
