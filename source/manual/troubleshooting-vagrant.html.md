---
owner_slack: "#2ndline"
title: Troubleshooting Vagrant
section: Support
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2016-11-25
review_in: 6 months
---

# Troubleshooting Vagrant

## loading the Vagrantfile

If you're encountering errors loading the `Vagrantfile`, check you're running the right version:

    vagrant --version

if it reports a version below `1.3.x`, you're out of date. This can be
verified by running `which rbenv`, which will likely report a path
like `/opt/boxen/rbenv/shims/vagrant`.

This means you're still running the old Gem installed version of
Vagrant, which can be forcibly removed by running the following
script (directly on the terminal):

```shell
for version in `rbenv versions --bare`; do
    rbenv local $version
    gem uninstall vagrant
    gem uninstall vagrant-dns
done
```

then run `rbenv rehash` to make sure all the Gem installed shims are
removed from your `PATH`.

## Permission denied (publickey).

You need to forward your publickey to the vm. Run `ssh-add` from the host machine, then attempt to provision your machine again.

To confirm your key has been forwarded to the development vm you can run

```
vagrant ssh # ssh onto vm
ssh-add -L  # list key and location on host machine
```

## SSH conection errors

Things to check if it doesn't work:

-   **Can you ssh directly onto the jumpbox?**
    `ssh jumpbox.integration.publishing.service.gov.uk` If not, check your ssh
    version and config.
-   **Do you get a permission denied error?** Make sure you're in the
    user list in the [deployment repo](https://github.gds/gds/deployment/tree/master/puppet/hieradata)
    for production access, or the [govuk-puppet repo](https://github.com/alphagov/govuk-puppet/tree/master/hieradata)
    for access to other environments.
-   **Are you connecting from outside Aviation House?** You'll need to
    connect to the Aviation House VPN first; SSH connections are
    restricted to the Aviation House IP addresses.
-   **Do you have a really old (5.3) version of openssh?** You need to
    swap `-W %h:%p` for `exec nc %h %p`

If you get an error `percent_expand: unknown key %r` then replace `%r`
with your username. This is a known issue on ubuntu lucid.

## Errors with NFS

You're likely on the production VPN. Disconnect the VPN and `reload`
your VM.

### Vagrant error :NFS is reporting that your exports file is invalid
```
==> default: Exporting NFS shared folders...
NFS is reporting that your exports file is invalid. Vagrant does
this check before making any changes to the file. Please correct
the issues below and execute "vagrant reload":

exports:2: path contains non-directory or non-existent components: /Users/<username>/path/to/vagrant
exports:2: no usable directories in export entry
exports:2: using fallback (marked offline): /
exports:5: path contains non-directory or non-existent components: /Users/<username>/path/to/vagrant
exports:5: no usable directories in export entry
exports:5: using fallback (marked offline): /
```

This means that you may already have old vagrant path definitions in your `/etc/exports` file.

Try opening up `/etc/exports` file to identify old or unwanted vagrant paths and removing them if necessary

On opening `/etc/exports` file each set begins with # VAGRANT-BEGIN: and ends with # VAGRANT-END:. Make sure to delete these and any other lines between VAGRANT-BEGIN: and VAGRANT-END:

or maybe

```
sudo rm /etc/exports
sudo touch /etc/exports

vagrant halt
vagrant up
```

### Permission denied errors on synced folders

If your host is running macOS 10.12 Sierra you may encounter this problem as there is a bug in the nfs implementation that means the cache is not updated frequently enough.  The usual way of encountering this problem is early in a `govuk_puppet` run, it will fail early with a Permission Denied error when trying to remove a file in `vendor/modules/`.  One workaround is to remove the `vendor/modules` and `.tmp` folders from your govuk-puppet working directory on your host, and then run `govuk_puppet` again in the VM.

The other solution, as mentioned in [this github issue against vagrant](https://github.com/mitchellh/vagrant/issues/8061) is to force macOS to refresh the nfs cache.  To do this on your host you run `ls -alR > /dev/null` in the root of your govuk folder.  To do this on your vm you run `find /var/govuk -type d -exec touch '{}'/.touch ';' -exec rm -f '{}'/.touch ';' 2>/dev/null`.

## installing vagrant-dns

Installing vagrant-dns with `vagrant plugin install vagrant-dns` against Vagrant 1.9 installed may give an error like:

```
/opt/vagrant/embedded/lib/ruby/2.2.0/rubygems/dependency.rb:315:in `to_specs': Could not find 'celluloid' (>= 0.16.0) among 45 total gem(s) (Gem::LoadError)
```

It looks like this might be a problem with Vagrant 1.9.0, because installing 1.8.6 fixes the problem. The issue has been raised with vagrant-dns, so they may have a better workaround: https://github.com/BerlinVagrant/vagrant-dns/issues/45

## vagrant-dns having updated vagrant

If after updating vagrant, you get errors regarding vagrant-dns when provisioning the VM you will need to reinstall the vagrant-dns plugin:

    vagrant plugin uninstall vagrant-dns
    vagrant plugin install vagrant-dns

You may also need to make sure the plugin has been started:

    vagrant dns --start

If you're having issues with your host machine resolving hosts, try purging and reinstalling the DNS config:

    vagrant dns --purge
    vagrant dns --install
    vagrant dns --start

In order to check if the plugin started correctly, you can run:

    ps aux | grep vagrant-dns
    vagrant dns --start -o

If you're still having issues you can try to update the vagrant-dns plugin:

    vagrant plugin update vagrant-dns

## Fetching packages

GOV.UK have an apt repository at http://apt.publishing.service.gov.uk/ This is not accessible on the internet, so if you're trying to provision the virtual machine outside of the GDS office, you have a little bit of work to do. The prerequisites talk about needing an LDAP account to access GDS Github Enterprise, so you should have an account which lets you access the VPN.

1. [Install openconnect](https://github.com/alphagov/gds-boxen/blob/1ba02125e0/modules/people/manifests/jabley.pp#L31)
2. [Connect to the Aviation House VPN](https://github.com/jabley/homedir/commit/2682f094024524cb7e31ca447694bdf81b1239a2)
3. `vagrant provision` should now be able to download packages when running apt

You may also need to run `sudo apt-get update` if you get errors that look something like:

```
E: Unable to locate package rbenv-ruby-2.4.0
E: Couldn't find any package by regex 'rbenv-ruby-2.4.0'
```

## Bundler permissions error on provision

On `vagrant up` or `vagrant provision` you receive an error similar to:

`/usr/lib/ruby/1.9.1/fileutils.rb:247:in `mkdir': Permission denied - /Users (Errno::EACCES)`

Make sure that no bundler config already exists (if you have bundled outside of the development vm).

You can remove this in the govuk-puppet directory:

`rm -r ~/govuk/govuk-puppet/.bundle`

## Running `govuk_puppet` on VM

Generally, you might want to try `vagrant provision` on your host machine, which does the same thing as `govuk_puppet`, but in a more reliable fashion.

## Can't connect to Mongo

This is probably happening because your VM didn't shut down cleanly. You should be running `vagrant halt` or `vagrant suspend` but if you had to kill your VM or restart your machine mongo won't be able to connect. You can fix this by deleting your `mongod.lock` and restarting mongodb.

```
sudo rm /var/lib/mongodb/mongod.lock
sudo service mongodb start
```

## Vagrant 1.8.7

If you use Vagrant 1.8.7 you may have this problem:

```
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

it looks like a problem with this specific version of Vagrant. Using version 1.8.6 works instead: https://releases.hashicorp.com/vagrant/1.8.6/
You can find more information about this issue here: https://github.com/mitchellh/vagrant/issues/8002

### `librarian:install` fails due to permission errors

Seeing `chown` / `OperationNotPermitted` errors during the `librarian:install` rake task?

Try `vagrant provision` on your host machine, as above.

### Hostname provisioning errors

If you use Vagrant v1.8.x, you may encounter an error along these lines during provisioning:

```
Default: Setting hostname...
/opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/guests/ubuntu/cap/change_host_name.rb:37:in `block in init_package': unexpected return (LocalJumpError)
    from /opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/communicators/ssh/communicator.rb:222:in `call’
```

Updating to the latest version (v1.8.5+) might resolve this error. If not, try `sudo vim`ing (or `sudo nano`, whichever you prefer) into that file and removing the offending `return` line.

## You don’t have enough RAM

If you have less than 8GB of RAM on your host machine, you’ll need to either:

* reduce the RAM available to the VM
* add extra RAM

You can reduce the RAM available to the VM in a `Vagrantfile.localconfig` file in this directory, which is automatically read by Vagrant (don't forget to run `vagrant reload`):

        mac$ cat ./Vagrantfile.localconfig
        config.vm.provider :virtualbox do |vm|
          vm.customize [ "modifyvm", :id, "--memory", "1024", "--cpus", "2" ]
        end

## SSH into your VM directly

Consider using `vagrant ssh` to SSH into your VM directly, as it'll always do the right thing.

If you need direct access (for `rsync`, `scp` or similar), you'll need to manually configure your ssh configuration:

1. Run`vagrant ssh-config --host dev`
2. Paste the output into your `~/.ssh/config`
3. SSH into this using `ssh dev`

## Running the dev stack with local assets

If you want to run the project in development mode with the static assets served from your local copy, run bowler with the STATIC_DEV variable defined and make sure you're not setting static=0:

    dev$ STATIC_DEV="http://static.dev.gov.uk" bowl planner static

## Working on databases while out of the office

If you take your laptop home at night, you may want to download the data while in the office and restore it overnight to minimise disruption.

First, do the download on your host as the unzipping is a lot quicker when not run over NFS:

    mac$ ./replicate-data-local.sh -u your_ssh_username -n

Then when you get home (or if you have a spare hour during meetings) run the script on your VM and specify the backup directory for the date you performed the download:

    dev$ ./replicate-data-local.sh -s -d backups/2016-11-17

## Run a single app

You can use [foreman](http://ddollar.github.io/foreman/) to run a single app. The available apps are defined in the Procfile.

    dev$ cd /var/govuk/govuk-puppet/development-vm
    dev$ foreman start rummager
