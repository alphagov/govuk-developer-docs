---
owner_slack: "#govuk-developers"
title: Policy on keeping software current
parent: "/manual.html"
layout: manual_layout
section: Dependencies
type: learn
---

One of our core values is to use secure and up-to-date software. This document lays out the policy for keeping our software current.

## Guiding principles

### Don't run EOL software

We should never be running [EOL (End-of-life) software](https://en.wikipedia.org/wiki/End-of-life_product).

We should also ensure that we upgrade software in plenty of time before its EOL deadline. This is something we're hoping to keep track of by reviewing the [dependency management spreadsheet](https://docs.google.com/spreadsheets/d/137KZhjctJ8qTKYPnq2QNVkyoIC6ok7KA2G1vErNC6Oo/edit) on a regular basis.

### Apply security patches quickly

Where an exploitable security vulnerability has been identified and patched, we must work quickly in applying the security patches, dropping other priorities if necessary.

If a vulnerability is only theoretical - for example, an issue in a library that is only used in your test suite and not user facing, then our normal dependency upgrade procedure applies. See next sections.

### Stay within two significant releases

We should always stay within two major releases from the current major release of any given software. There is some industry precedent for this: providers such as Terraform [expect customers to stay within two major releases](https://support.hashicorp.com/hc/en-us/articles/360021185113-Support-Period-and-End-of-Life-EOL-Policy) in order to receive optimal support.

This is a rough guide.  Some projects, such as Ruby, don't necessarily follow [semver](https://semver.org/), and consider their minor versions to be significant upgrades. In these cases, you should stay within two minor releases of the latest.

Another consideration is EOL. For example, if the latest version of something is version 9, and we're on version 7, but version 7 is EOL, we should update to version 8, despite version 7 being within two major versions of the latest.

The two-major-releases rule allows some wiggle-room for keeping upgrade cadences manageable. Teams don't have to worry about upgrading to a new major version the moment it becomes available, but shouldn't allow themselves to fall too far behind. Teams can leverage tools such as [Dependabot](/manual/manage-ruby-dependencies.html) to automate much of the chore work.

### Prioritise dependencies over subdependencies

In a perfect world, all software would always be fully up to date. However, this comes with a big developer overhead.

In [RFC-126](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-126-custom-configuration-for-dependabot.md), we agreed to configure Dependabot to only raise pull requests for important dependencies, so that we had a realistic chance of keeping on top of them all. We've prioritised security updates, internal dependencies and framework dependencies, and have configured Dependabot to only update top-level dependencies. We are less focussed on ensuring that dependencies of dependencies are kept up to date.

## Exceptions

Some dependencies have a stricter updates policy.

### Rails

It's very important that we're running a currently supported version of Rails for all applications, otherwise we aren't covered by security fixes. We should:

- Be running on the current major version
- Maintain our applications at the latest current bugfix release for the minor version we're on (expressed in Gemfile syntax as: ~> X.Y.Z)
- Keep abreast of breaking changes for the next major version (eg 5.y.z), and have a plan to migrate our apps before the current version is deprecated

Upgrading Rails requires carefully following the manual steps at [Upgrading Ruby on Rails][], for major and minor version increases.
For patch increases, no manual steps are required and it is fine to merge the update provided the tests pass.

[Upgrading Ruby on Rails]: https://guides.rubyonrails.org/upgrading_ruby_on_rails.html

### Ruby

New versions of Ruby bring us improved performance and nicer syntax for certain things, but also can cause issues with the libraries etc. we use. We should:

- Be running on the current major version
- Maintain our applications at the current or next-to-current minor version
- Maintain our gems to support all currently supported Ruby versions (see [Ruby version compatibility for gems](/manual/publishing-a-ruby-gem.html#ruby-version-compatibility))

See [Add a new Ruby version][] for a guide on how to install a new version of Ruby.

[Add a new Ruby version]: /manual/ruby.html
