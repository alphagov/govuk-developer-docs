---
owner_slack: "#2ndline"
title: Fix issues with vagrant-dns
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-28
review_in: 6 months
---

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

If this gives an error about an "undefined method `socket_type`", then
you have hit a bug in async-dns, a dependency of vagrant-dns.  The
solution is to install an older version of vagrant-dns:

```shell
vagrant plugin uninstall vagrant-dns
vagrant plugin install vagrant-dns --plugin-version 1.1.0
```

If you're still having issues you can try to update the vagrant-dns plugin:

```shell
vagrant plugin update vagrant-dns
```
