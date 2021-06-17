---
owner_slack: "#govuk-developers"
title: Publish a Ruby gem
section: Packaging
layout: manual_layout
parent: "/manual.html"
---

## Naming

In general, the gem name should be the same as the thing you require when using
it. This means using `_`, and not `-` to separate multi-word gem names.  See the
[name your gem guide](http://guides.rubygems.org/name-your-gem/) for more detailed
guidance.

Also [see the general policy on naming](/manual/naming.html#naming-gems).

## Versioning

Follow the guidelines on [semver.org](http://semver.org/) for assigning version
numbers.

Versions should only be changed in a commit of their own, in a pull request of
their own.

This alerts team members to the new version and allows for last-minute scrutiny
before the new version is released. Also, by raising a separate pull request,
we avoid version number conflicts between feature branches.

## File layout

We should follow the scheme used by Bundler when creating gems (see [this
railscast](http://railscasts.com/episodes/245-new-gem-with-bundler?view=asciicast)).

> **Note**
>
> * The version is stored in a file by itself in `lib/<gem_name>/version.rb`.
> * The Gemfile references the gemspec for gem dependencies.  All gem
>   dependencies should be specified in the gemspec.
> * The Gemfile.lock is **never** committed (it should be in the `.gitignore`
>   file).

## Releasing gem versions

The default Jenkins build script will automatically detect the presence of a
`gemspec` file and publish the gem to rubygems.org. See the
[Jenkinsfile for govuk_app_config](https://github.com/alphagov/govuk_app_config/blob/master/Jenkinsfile)
for an example.

### Manually publishing gems from the CLI

Sometimes you may be required to publish a gem outside of Jenkins, if you need
to release a patch or minor version below the current latest major version.
For example, say you have a gem at version 1.0.0 and later release a major breaking
change as version 2.0.0. If you still need to support apps using v1, and you want
to apply a bugfix as a patch version 1.0.1, you would not be able to deploy off
the `main` branch as this will include all of the breaking v2 changes.

To manually publish from the command line:

1. Get your branch ready: checkout the tag of the previous major version (e.g.
   `git checkout v1.0.0`) and then create a branch pointing at this commit
   (`git checkout -b bump-version-to-1.0.1`).
1. Get your code ready: make your code changes, including adding a CHANGELOG entry
   and bumping the version number.
1. Commit.
1. Manually follow the steps of the [`publishGem` function in govuk-jenkinslib](https://github.com/alphagov/govuk-jenkinslib/blob/c25c362dd8288e92a09b6f6cc9b5dd6fd6c12c84/vars/govuk.groovy#L762-L806)
   i.e. check your new version doesn't already exist, build & publish the gem,
   make and push a git tag. The RubyGems credentials can be found in govuk-secrets.
1. Tidy up: open a pull request for this branch against `main`. There will be merge
   conflicts, which you'll have to manually resolve before you can merge. Do this
   **without rebasing**, as we want to keep the original `main` history. You'll end
   up with a meta commit like `Merge pull request #1 from username/branch-name`,
   but the full history of both `main` and your branch will be intact.

## Clearing the gemstash cache

When a new gem version is released, it may not be available immediately on Jenkins.
This is due to [gemstash][], our gem mirror. It caches versions for up to 30
minutes. To force it to clear, restart `gemstash` on the `apt` machine in the
relevant environment, e.g. for integration:

```
gds govuk c ssh -e integration apt 'sudo docker restart gemstash'
```

To clear the cache for the CI Jenkins instance, run this in integration.

[gemstash]: https://github.com/bundler/gemstash/
