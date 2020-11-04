---
owner_slack: "#re-govuk"
title: Duplicate SSH host keys
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This check indicates that more than one machine in an environment is
using the same SSH host key. This is bad because it means that we can't
verify the authenticity of a particular host and it could be used in a
[MITM attack](http://en.wikipedia.org/wiki/Man-in-the-middle_attack).

The check will list the affected machines and key fingerprints. To
determine which key the fingerprint belongs to (RSA, DSA or ECDSA) you
can run the following command on the host:

```
for file in /etc/ssh/ssh_host_*.pub; do sudo ssh-keygen -lf $file; done
```

The immediate problem can be resolved by deleting the host keys and
regenerating them with `dpkg-reconfigure openssh-server`.

However, bear in mind that the:

- root cause in templating/provisioning also needs to be fixed
- key change should be communicated to all people with login accounts

It is also important to keep in mind that this check uses Puppetdb to query
the facts 'sshdsakey', 'sshecdsakey' and 'sshrsakey' and find duplicated values.
The check assumes some default values that might change with the time, or there
could be a problem with Puppetdb itself.

For more information, check the source of the check [here](https://github.com/alphagov/nagios-plugins/blob/master/plugins/command/check_puppetdb_ssh_host_keys.py)
