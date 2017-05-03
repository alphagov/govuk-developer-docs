---
owner_slack: "#2ndline"
title: Publish to Puppet Forge
section: Packaging
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/publish-to-puppet-forge.md"
last_reviewed_on: 2017-03-30
review_in: 6 months
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/publish-to-puppet-forge.md)


# Publish to Puppet Forge

## Logging in to the Forge

Credentials for the GDS Operations account can be found in the
`gds/deployment:creds/infra_team` secure store.

The URL for our account is: <http://forge.puppetlabs.com/gdsoperations>

## Checks before releasing a new or updated module

1)  Ensure that all tests pass and that the project conforms to our
    [Open Source
    Guidelines](https://gds-operations.github.io/guidelines/).
2)  Choose a new version number in accordance with [Semantic
    Versioning](http://semver.org/).
3)  Add a new release entry to the `CHANGELOG`.
4)  Update the `version` field in `Modulefile`.
5)  Create a pull request with these changes.

## Releasing a new or updated module

1)  Build the module with `bundle exec puppet module build`.
2)  Click [Publish](https://forge.puppetlabs.com/upload).
3)  Submit the tarball you just built from the `pkg/` directory.

Alternatively, use the
[puppet-blacksmith](https://github.com/maestrodev/puppet-blacksmith) gem
to push from the command line.

If publishing to the Forge was successful, create a tag on the
repository:

1)  Tag the release prefixed with a `v`, eg: `git tag v0.1.2`. Ensure
    you tag the merge commit, not the branch commit.
2)  Push the commit and tag to the repo: `git push --tags origin master`
