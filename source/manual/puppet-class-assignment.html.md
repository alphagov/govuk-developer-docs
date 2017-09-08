---
owner_slack: "#2ndline"
title: Puppet Class Assignment
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/puppet-class-assignment.md"
last_reviewed_on: 2017-09-08
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.com/alphagov/govuk-legacy-opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/infrastructure/puppet-class-assignment.md)


## High level overview

On each instance running Puppet there is a [trusted fact](http://www.sebdangerfield.me.uk/2015/06/puppet-trusted-facts/)
called `certname`. This is based on the host name embedded in the instances certificate
and cannot be changed without making the cert invalid. This value is sent to the Puppet master
on each run, as are all facts, and made available to the master in a data structure that cannot be easily overridden.
These values are used by Puppet as it builds the config for the given host.

When an agent checks in, the Puppet master looks in the `manifests/site.pp` file to find a `node` block matching
the nodes name. You would normally list the classes to include here. In our case we call out to the
`govuk_node_class()` function (which lives in (`./modules/govuk/lib/puppet/parser/functions/govuk_node_class.rb`)
and use it to extract a Puppet class name by taking the following steps:

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
statement to include resources from one of the base classes. From this point you can follow the Puppet resources
assigned by reading the included classes in the roles and then the modules they include.

## Puppet class assignment on AWS

On AWS we can't use `certname` to do the class assignment because it is not a fixed value. In this case we are
using [certificate extensions](https://docs.puppet.com/puppet/latest/ssl_attributes_extensions.html) to decide which class
should be assigned to an instance. On the instances, the certificate request has been updated at provisioning time to
include the following extensions, that will appear in the `$::trusted['extensions']` hash:
  - pp_instance_id: AWS instance Id
  - pp_image_name: AWS image name
  - 1.3.6.1.4.1.34380.1.1.13 (pp_role): Instance role, populated at provisioning time with the value of the `aws_migration` tag.
  - 1.3.6.1.4.1.34380.1.1.18 (pp_region): AWS instance region

When we run `puppet agent`, `govuk_node_class()` will return the content of `$::trusted['extensions']['1.3.6.1.4.1.34380.1.1.13']`
if it's not empty or null. Otherwise the previous `$::trusted['certname']` is used to extract the class_name.

When we run `puppet apply --trusted_node_data`, `govuk_node_class()` will return the value of the fact
`$::aws_migration` if it's not empty or null. Otherwise `$::trusted['certname']` will be used.

