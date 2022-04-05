---
owner_slack: "#govuk-2ndline-tech"
title: Rollback Puppet if Jenkins is broken
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

Sometimes, a Puppet release may break Jenkins and since Jenkins is used to
release Puppet, there is no straight forward way to rollback Puppet.

This procedure will rollback Puppet to a previous release so that Jenkins is
restored:

1. log into the Puppet master machine:

```sh
  gds govuk connect ssh -e <govuk_environment> puppetmaster
```

2. check the current active release by looking at the symbolic link of `/usr/share/puppet/production/current`:

```sh
  sudo su
  su deploy
  ls -lh /usr/share/puppet/production/
```

3. get a list of Puppet available releases on the Puppet master, they are in the format year/month/day/time:

```sh
  ls /usr/share/puppet/production/releases
```

4. link to another previous release using:

```sh
  ln -sfn /usr/share/puppet/production/releases/<previous_release_number> /usr/share/puppet/production/current
```

5. restart Puppet service (as root or your admin user):

```sh
  service puppetserver restart
```

6. log into the Jenkins server and re-run Puppet:

```sh
  gds govuk connect ssh -e integration jenkins
  govuk_puppet --test
```
