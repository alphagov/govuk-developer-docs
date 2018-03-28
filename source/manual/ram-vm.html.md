---
owner_slack: "#2ndline"
title: Increase RAM on the VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-28
review_in: 6 months
---

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
