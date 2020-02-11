---
owner_slack: "#govuk-dev-tools"
title: Not enough RAM for the VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-13
review_in: 6 months
---

If you have less than 8GB of RAM on your host machine, you should ask IT for
an upgrade. Your line manager can help you with this.

In the meantime, if you're struggling to run the VM and your macOS applications,
you can reduce the RAM available to the VM. You can specify this in a
`Vagrantfile.localconfig` file in the same directory (`govuk-puppet/development-vm`)
as the Vagrantfile, which is automatically read by Vagrant (don't forget to run
`vagrant reload`):

```shell
$ cat ./Vagrantfile.localconfig
config.vm.provider :virtualbox do |vm|
    vm.customize [ "modifyvm", :id, "--memory", "1024", "--cpus", "2" ]
end
```
