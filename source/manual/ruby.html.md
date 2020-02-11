---
owner_slack: "#govuk-developers"
title: Add a new Ruby version
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-12
review_in: 6 months
---

The [Ruby language](https://www.ruby-lang.org/en/) is a core part of GOV.UK - most of our applications are written in it.

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

[cap_deploy]: https://github.com/alphagov/govuk-app-deployment/blob/master/recipes/ruby.rb#L4
[cap_deploy_commit]: https://github.com/alphagov/alphagov-deployment/commit/b6404e33c354ef63f01c13b202ce0cf2ed2975fc
[rbenv_path]: https://github.com/alphagov/govuk-secrets/blob/master/puppet/hieradata/integration_credentials.yaml

## Add a new Ruby version in puppet

You will need to build a new [fpm](debian-packaging.html#fpm) package with the new Ruby version.
This package can then be copied to Aptly machine, and the new version added to puppet.

### Building the fpm package.

- Add a new recipe for the ruby version in [Packager][packager].
The folder name will be the Ruby version, and contain a `recipe.rb` file. See previous entries for examples.
The recipe will require the [SHA256][sha256_checksum] of the version's `tar.gz`, available at [Ruby cache][ruby_cache].

- Once the Packager change is merged, [build the package][jenkins].

Use the VM to [test the recipe](debian-packaging.html#test-the-recipe)

To make sure it has been successful
 - `rbenv versions` to make sure your version is available
 - `rbenv local X.X.X` to use your new version
 - `ruby -v` to make sure your version is in use

### Copying to Aptly

### Add to Puppet

Once it's available as a package in Aptly you can
[install it everywhere using Puppet][puppet_rbenv_all]. Machines only run
`apt-get update` periodically so it might take a little time for the package
to become available.

[packager]: https://github.com/alphagov/packager/tree/master/fpm/recipes
[sha256_checksum]: https://emn178.github.io/online-tools/sha256_checksum.html
[ruby_cache]: https://cache.ruby-lang.org/pub/ruby/
[jenkins]: https://ci.integration.publishing.service.gov.uk/job/build_fpm_package
[puppet_rbenv_all]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_rbenv/manifests/all.pp

## Testing whether a version of Ruby is in use

You can use the Fabric task `rbenv.version_in_use` to find out which
applications are using a specific version of Ruby on GOV.UK. For example:

```
fab production puppet_class:govuk_rbenv::all rbenv.version_in_use:2.3.1
```
