---
owner_slack: "#2ndline"
title: Puppet Class Assignment
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/puppet-class-assignment.md"
last_reviewed_on: 2017-02-22
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.com/alphagov/govuk-legacy-opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/infrastructure/puppet-class-assignment.md)


## High level overview

On each instance running Puppet there is a [trusted fact](http://www.sebdangerfield.me.uk/2015/06/puppet-trusted-facts/)
called `certname`. This is based on the host name embedded in the instances certificate
and cannot be changed without making the cert invalid. This value is sent to the puppet master
on each run, as are all facts, and made available to the master in a data structure that cannot be easily overridden.
These values are used by puppet as it builds the config for the given host.

When an agent checks in, the puppet master looks in the `manifests/site.pp` file to find a `node` block matching
the nodes name. You would normally list the classes to include here. In our case we call out to the
`govuk_node_class()` function (which lives in (`./modules/govuk/lib/puppet/parser/functions/govuk_node_class.rb`)
and use it to extract a puppet class name by taking the following steps:

  * assume we start with a fully qualified host name of `api-1.api.integration.publishing.service.gov.uk
`
  * extract the host name (api-1)
  * remove the trailing hyphen and any machine host number (remove `-1` leaving `api`)
  * convert any hyphens to underscores (`-` become `_`)

The remaining value is then used as the final part in a class declaration:

    class { "govuk::node::s_${::govuk_node_class}": }

You can see all the currently defined roles in:

    ls -alh modules/govuk/manifests/node/s_*.pp

Assuming a matching class name exists the role is assigned to the host. In some cases there will also be an inherits
statement to include resources from one of the base classes. From this point you can follow the puppet resources
 assigned by reading the included classes in the roles and then the modules they include.
