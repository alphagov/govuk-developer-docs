---
owner_slack: "#govuk-dev-tools"
title: Fix NFS errors in VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-11
review_in: 6 months
---

## Are you on a VPN?

Using Cisco AnyConnect will prevent Vagrant from mounting your shared folders
in the developer VM. If your VM is already running, it will freeze if you attempt
to access a shared folder.

To prevent this, start your VM with the command `VAGRANT_GOVUK_NFS=no vagrant up`.

This will use a less efficient method of sharing folders, but it will work with
the VPN.

Once you disconnect from the VPN, you will need to [run these commands](/manual/vm-vpn-issues.html)
before you're able to use Vagrant with NFS again.


## Vagrant error NFS is reporting that your exports file is invalid
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

## Permission denied errors on synced folders

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

These two options have been provided as shell scripts in the `govuk-puppet/development-vm` folder:

* `refresh-nfs-cache-on-host.sh` - run this on your host machine to perform the `ls` command above on `../../` which should be the checkout location of all your repos.
* `refresh-nfs-cache-on-vm.sh` - run this on your VM to perform the `find` command above on `/var/govuk`.
* `vagrant-up.sh` - run this on your host to refresh the cache and then bring up your vagrant VM.
