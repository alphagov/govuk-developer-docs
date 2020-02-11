---
owner_slack: "#govuk-developers"
title: Publish to Puppet Forge
section: Packaging
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-22
review_in: 6 months
---

## Logging in to the Forge

Credentials for the GDS Operations account can be found in `packages/puppet_forge`
in the 2ndline password store.

The URL for our account is <http://forge.puppetlabs.com/gdsoperations>.

## Checks before releasing a new or updated module

1.  Ensure that all tests pass and that the project conforms to our
    [Open Source
    Guidelines](https://gds-operations.github.io/guidelines/).
2.  Choose a new version number in accordance with [Semantic
    Versioning](http://semver.org/).
3.  Add a new release entry to the `CHANGELOG`.
4.  Update the `version` field in `metadata.json`. If this file is not present, but `Modulefile` is, address this before progressing with the release.
5.  Create a pull request with these changes.

## Releasing a new or updated module

### Via the Forge website

1. Build the new version with `bundle exec puppet module build`
2. Click [Publish](https://forge.puppetlabs.com/upload)
3. Submit the tarball you just built from the `pkg/` directory

If you get the "this action has been replaced by Puppet Development
Kit" error, run these commands instead:

```sh
$ brew cask install puppetlabs/puppet/pdk
$ pdk build
```

### Via the command line

The web UI is the preferred method, but it is also possible to use the
[puppet-blacksmith](https://github.com/maestrodev/puppet-blacksmith) gem
to push from the command line.

If publishing to the Forge was successful, create a tag on the
repository:

1.  Tag the release prefixed with a `v`, eg: `git tag v0.1.2`. Ensure
    you tag the merge commit, not the branch commit.
2.  Push the commit and tag to the repo: `git push --tags origin master`.
