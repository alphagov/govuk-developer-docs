---
owner_slack: "#2ndline"
title: Fix problems with Vagrant
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-08-18
review_in: 2 months
---

## How to run an application

You can use [bowler](https://github.com/JordanHatch/bowler) to run an
application, it will also run all dependent services and applications.
The applications are listed in the [Pinfile][].

```shell
$ cd /var/govuk/govuk-puppet/development-vm
$ bowl rummager
```

If you want to run an application in development mode with the static assets
served from your local copy, run bowler with the `STATIC_DEV` variable defined
and make sure you're not setting `static=0`:

```shell
$ STATIC_DEV="http://static.dev.gov.uk" bowl planner static
```

To run a single application without the dependencies you can use
[foreman](http://ddollar.github.io/foreman/). The available apps are defined in
the [Procfile][].

```shell
$ cd /var/govuk/govuk-puppet/development-vm
$ foreman start rummager
```

Most apps also have a `startup.sh` script in their root folder, and you can
run that directly too:

```shell
$ cd /var/govuk/rummager
$ ./startup.sh
````

## Using `bowl` fails with bundler error

Sometimes the `bowl` command is not correctly installed on the VM.  If you
get an error like:

```shell
$ bowl frontend
bash: bowl: command not found
```

In other ruby applications this type of error can be solved by running the
command via `bundle exec` which load the application's `Gemfile` and makes
sure all the commands from the dependencies listed in there are available.
In this case however, `bowl` should be globally available, and running it via
`bundle exec` means we can't change the ruby version it will use to run each
different app.  Leading to errors like:

```
/usr/lib/rbenv/versions/2.4.0/bin/bundle:22:in `load': cannot load such file -- /usr/lib/rbenv/versions/1.9.3-p550/lib/ruby/gems/1.9.1/gems/bundler-1.7.4/lib/gems/bundler-1.7.4/bin/bundle (LoadError)
````

or

```
/usr/lib/rbenv/versions/1.9.3-p550/lib/ruby/gems/1.9.1/gems/bundler-1.7.4/lib/bundler/source/git.rb:188:in `rescue in load_spec_files': https://github.com/alphagov/mongoid_rails_migrations (at avoid-calling-bundler-require-in-library-code-v1.1.0-plus-mongoid-v5-fix) is not yet checked out. Run `bundle install` first. (Bundler::GitError)
```

To make `bowl` globally available reinstall it:

```shell
$ cd /var/govuk/govuk-puppet/development-vm
$ sudo gem install bowler
$ rbenv rehash
```

You should now be able to use `bowl` to run the apps correctly.

However, if you are seeing an error such as
`rbenv: cannot rehash: /usr/lib/rbenv/shims/.rbenv-shim exists` but the
`.rbenv-shim` file doesn't exist, try rebooting the VM. Use `vagrant halt`,
`vagrant up` and then `vagrant ssh` and hopefully `bowl` should be globally
available.

## Can't connect to Mongo

This is probably happening because your VM didn't shut down cleanly.
You should be running `vagrant halt` or `vagrant suspend` but if you had to
kill your VM or restart your machine MongoDB won't be able to connect. You can
fix this by deleting your `mongod.lock` and restarting MongoDB.

```shell
$ sudo rm /var/lib/mongodb/mongod.lock
$ sudo service mongodb start
```

## How to SSH into your VM directly

Consider using `vagrant ssh` to SSH into your VM directly, as it'll always do
the right thing.

If you need direct access (for `rsync`, `scp` or similar), you'll need to
manually configure your SSH configuration:

1. Run `vagrant ssh-config --host dev`
2. Paste the output into your `~/.ssh/config`
3. SSH into this using `ssh dev`

## Running `govuk_puppet` on VM

Generally, you might want to try `vagrant provision` on your host machine,
which does the same thing as `govuk_puppet`, but in a more reliable fashion.

## You don’t have enough RAM

If you have less than 8GB of RAM on your host machine, you’ll need to either:

* reduce the RAM available to the VM
* add extra RAM

You can reduce the RAM available to the VM in a `Vagrantfile.localconfig` file
in the same [directory][vagrantfile-directory] as Vagrantfile, which is
automatically read by Vagrant (don't forget to run `vagrant reload`):

```shell
$ cat ./Vagrantfile.localconfig
config.vm.provider :virtualbox do |vm|
    vm.customize [ "modifyvm", :id, "--memory", "1024", "--cpus", "2" ]
end
```

## Errors with NFS

### Are you on a VPN?

Using Cisco AnyConnect has been known to cause issues with NFS.

Either disconnect from the VPN and reload the VM for access.

Or, consider using [OpenConnect][] for your VPN. You can access the Aviation
House VPN via:

```shell
$ sudo openconnect -v --pfs --no-dtls -u $USER vpn.digital.cabinet-office.gov.uk/ah
```

### Vagrant error NFS is reporting that your exports file is invalid
```shell
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

This means that you may already have old Vagrant path definitions in your
`/etc/exports` file.

Try opening up `/etc/exports` file to identify old or unwanted Vagrant paths
and removing them if necessary.

On opening `/etc/exports` file each set begins with # VAGRANT-BEGIN: and ends
with # VAGRANT-END:. Make sure to delete these and any other lines between
VAGRANT-BEGIN: and VAGRANT-END:

or maybe

```shell
sudo rm /etc/exports
sudo touch /etc/exports

vagrant halt
vagrant up
```

### Permission denied errors on synced folders

If your host is running macOS 10.12 Sierra you may encounter this problem as
there is a bug in the NFS implementation that means the cache is not updated
frequently enough. The usual way of encountering this problem is early in a
`govuk_puppet` run, it will fail early with a Permission Denied error when
trying to remove a file in `vendor/modules/`. One workaround is to remove the
`vendor/modules` and `.tmp` folders from your govuk-puppet working
directory on your host, and then run `govuk_puppet` again in the VM.

The other solution, as mentioned in
[this GitHub issue against Vagrant](https://github.com/mitchellh/vagrant/issues/8061)
is to force macOS to refresh the NFS cache. To do this on your host you run

```shell
ls -alR > /dev/null
```

in the root of your govuk folder. To do this on your VM
you run

```shell
find /var/govuk -type d -exec touch '{}'/.touch ';' -exec rm -f '{}'/.touch ';' 2>/dev/null
```

The other solution, as mentioned in
[this GitHub issue against Vagrant](https://github.com/mitchellh/vagrant/issues/8061)
is to force macOS to refresh the NFS cache. To do this on your host you run

```shell
ls -alR > /dev/null
```

in the root of your govuk folder. To do this on your VM
run

```shell
find /var/govuk -type d -exec touch '{}'/.touch ';' -exec rm -f '{}'/.touch ';' 2>/dev/null
```

These two options have been provided as shell scripts in the `govuk-puppet/development-vm` folder:

* `refresh-nfs-cache-on-host.sh` - run this on your host machine to perform the `ls` command above on `../../` which should be the checkout location of all your repos.
* `refresh-nfs-cache-on-vm.sh` - run this on your VM to perform the `find` command above on `/var/govuk`.
* `vagrant-up.sh` - run this on your host to refresh the cache and then bring up your vagrant VM.

## Errors loading the Vagrantfile

If you're encountering errors loading the `Vagrantfile`, check you're running
the right version:

    vagrant --version

if it reports a version below `1.3.x`, you're out of date. This can be
verified by running `which vagrant`, which will likely report a path
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

## SSH into GOV.UK servers from the VM

You will need to either forward your publickey from the host machine to the
VM or have your VM publickey added to your [user manifest][user-manifests].

To confirm your key has been forwarded to the development vm you can run:

```shell
vagrant ssh # ssh onto vm
ssh-add -L  # list key and location on host machine
```
Things to check if it doesn't work:

-   **Can you SSH directly onto the jumpbox?**
    `ssh jumpbox.integration.publishing.service.gov.uk` If not, check your ssh
    version and config.
-   **Do you get a permission denied error?** Make sure you're in the
    user list in the [govuk-secrets repo](https://github.com/alphagov/govuk-secrets/tree/master/puppet/hieradata)
    for production access, or the [govuk-puppet repo](https://github.com/alphagov/govuk-puppet/tree/master/hieradata)
    for access to other environments.
-   **Are you connecting from outside Aviation House?** You'll need to
    connect to the Aviation House VPN first; SSH connections are
    restricted to the Aviation House IP addresses.

## vagrant-dns Issues

If after updating Vagrant, you get errors regarding vagrant-dns when
provisioning the VM you will need to reinstall the vagrant-dns plugin:

    vagrant plugin uninstall vagrant-dns
    vagrant plugin install vagrant-dns

You may see an error like:

```shell
/opt/vagrant/embedded/lib/ruby/2.2.0/rubygems/dependency.rb:315:in `to_specs': Could not find 'celluloid' (>= 0.16.0) among 45 total gem(s) (Gem::LoadError)
```

It looks like this might be a problem with Vagrant 1.9.0, because installing
1.8.6 fixes the problem. The issue has been raised with vagrant-dns, so
they may have a better workaround: https://github.com/BerlinVagrant/vagrant-dns/issues/45

You may also need to make sure the plugin has been started:

```shell
vagrant dns --start
```

If you're having issues with your host machine resolving hosts, try purging and
reinstalling the DNS config:

```shell
vagrant dns --purge
vagrant dns --install
vagrant dns --start
```

In order to check if the plugin started correctly, you can run:

```shell
ps aux | grep vagrant-dns
vagrant dns --start -o
```

If you're still having issues you can try to update the vagrant-dns plugin:

```shell
vagrant plugin update vagrant-dns
```

## Problems fetching packages

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

[Pinfile]: https://github.com/alphagov/govuk-puppet/blob/master/development-vm/Pinfile
[Procfile]: https://github.com/alphagov/govuk-puppet/blob/master/development-vm/Procfile
[vagrantfile-directory]: https://github.com/alphagov/govuk-puppet/tree/master/development-vm
[OpenConnect]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-gds/how-to/connect-to-the-aviation-house-vpn
[user-manifests]: https://github.com/alphagov/govuk-puppet/tree/master/modules/users/manifests
