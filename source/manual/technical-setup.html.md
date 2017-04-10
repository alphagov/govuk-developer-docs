---
title: Technical setup
section: Support
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/technical-setup.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/technical-setup.md)


# Technical setup

## SSH config

Boxen contains an [example configuration](https://github.com/alphagov/gds-boxen/blob/master/modules/gds_ssh_config/files/gds_ssh_config)

After you place it into `~/.ssh/config` you will able able to be able to
ssh into any box in the infrastructure directly, by running, for
example, `ssh mongo-1.backend.production`.

Things to check if it doesn't work:

-   **Can you ssh directly onto the jumpbox?**
    `ssh jumpbox.publishing.service.gov.uk` If not, check your ssh
    version and config.
-   **Do you get a permission denied error?** Make sure you're in the
    user list in the [deployment repo](https://github.gds/gds/deployment/tree/master/puppet/hieradata)
    for production access, or the [govuk-puppet repo](https://github.com/alphagov/govuk-puppet/tree/master/hieradata)
    for access to other environments.
-   **Do you have a really old (5.3) version of openssh?** You need to
    swap `-W %h:%p` for `exec nc %h %p`
-   **Are you connecting from outside Aviation House?** You'll need to
    connect to the Aviation House VPN first; SSH connections are
    restricted to the Aviation House IP addresses.

It's possible the username on your local machine differs to the one
being used remotely, in which case add a `User joebloggs` line to each
Host section.

If you get an error `percent_expand: unknown key %r` then replace `%r`
with your username. This is a known issue on ubuntu lucid.

## Emergency Publishing

You should have a recent copy of the
[opsmanual](https://github.gds/gds/opsmanual) and the
[fabric scripts](https://github.com/alphagov/fabric-scripts) in case you're
required to perform [emergency publishing](emergency-publishing.html).

## ZenDesk

Tickets requiring your support may be raised in
[ZenDesk](http://govuk.zendesk.com/) so you'll need an account. If you
were not issued one on joining then any member of your team can request
you be added by raising a ticket in ZenDesk itself.

## Google Group

2nd line has a [Google Group](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/2nd-line-support)
that receives requests. Make sure you're a member.
