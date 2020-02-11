---
owner_slack: "#govuk-dev-tools"
title: Unable to mount VirtualBox shared folders
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-06
review_in: 6 months
---

The following error message can appear when you start the development
VM using vagrant.

```
Vagrant was unable to mount VirtualBox shared folders. This is usually
because the filesystem "vboxsf" is not available. This filesystem is
made available via the VirtualBox Guest Additions and kernel module.
Please verify that these guest additions are properly installed in the
guest. This is not a bug in Vagrant and is usually caused by a faulty
Vagrant box. For context, the command attempted was:

mount -t vboxsf -o uid=1000,gid=1000 vagrant /vagrant

The error output from the command was:

: No such device
```

This is often proceeded by a message that gives more information about
the guest additions.

```
==> default: Checking for guest additions in VM...
   default: The guest additions on this VM do not match the installed version of
   default: VirtualBox! In most cases this is fine, but in rare cases it can
   default: prevent things such as shared folders from working properly. If you see
   default: shared folder errors, please make sure the guest additions within the
   default: virtual machine match the version of VirtualBox you have installed on
   default: your host and reload your VM.
   default:
   default: Guest Additions Version: 4.3.20
   default: VirtualBox Version: 5.1
```

The "guest additions" are a set of Linux modules that are used inside
the development-vm. It is difficult to change the version of these
modules, so the easiest workaround may be to install a different
version of VirtualBox, specifically one which best matches the version
of the guest additions given in the above error message.
