---
owner_slack: "#2ndline"
title: Add a new Ruby version
section: Tools
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/ruby.md"
last_reviewed_on: 2016-12-09
review_in: 6 months
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/ruby.md)


# Add a new Ruby version

The Ruby language is a core part of GOV.UK - most of our applications
are written in it.

## Managing different versions of Ruby

Each app can use whatever version of Ruby it wants. We manage this with
[rbenv](https://github.com/rbenv/rbenv).

## Setting up rbenv

We set up rbenv differently depending on what's going on:

- Interactive login shells: `/etc/profile.d/rbenv.sh` sets up rbenv
- Applications: `govuk_setenv` and a `.ruby-version` in the app directory set up rbenv
- Deployment: Capistrano uses a non -login shell so we [set `default_environment`][cap_deploy]
  ([commit][cap_deploy_commit])
- Testing: Jenkins uses a non-login shell so we [add `/usr/lib/rbenv/shims` to the `PATH`][rbenv_path]
- Cronjobs: some cronjobs start with `/bin/bash -l -c` which runs a login shell

[cap_deploy]: https://github.com/alphagov/govuk-app-deployment/blob/master/recipes/ruby.rb
[cap_deploy_commit]: https://github.gds/gds/alphagov-deployment/commit/b6404e33c354ef63f01c13b202ce0cf2ed2975fc
[rbenv_path]: https://github.gds/gds/deployment/blob/master/puppet/hieradata/integration_credentials.yaml

## Add a new Ruby version in puppet

Build a package using [fpm](debian-packaging.html) and make it
available using our aptly repository.

The package name includes the version of Ruby (eg `rbenv-ruby-2.3.1`) because
we need to install multiple versions of Ruby at the same time.

Once it's available as a package you can
[install it everywhere using Puppet][puppet_rbenv_all]. Machines only runs
`apt-get update` periodically so it might take a little time for the package
to become available.

[puppet_rbenv_all]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_rbenv/manifests/all.pp

## Testing whether a version of Ruby is in use

You can use the Fabric task `rbenv.version_in_use` to find out which
applications are using a specific version of Ruby on GOV.UK. For example:

```
fab production puppet_class:govuk_rbenv::all rbenv.version_in_use:2.3.1
```
