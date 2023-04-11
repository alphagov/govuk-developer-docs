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

We use GitHub Actions as a means to create new releases of gems. We have
a [workflow][release-gem-workflow] that can be imported into apps and an
organisation [GitHub secret][gh-secret], `ALPHAGOV_RUBYGEMS_API_KEY`, that
can be used to authenticate with RubyGems.

To utilise these you will need to ask a [GOV.UK GitHub Owner][govuk-github-owners]
to grant your repository [access to the secret][secret-access] and apply
the workflow to your GitHub Action ([example][gh-workflow-example]).

Should you have an unconventional need in building your gem for deployment,
for example [govuk_publishing_components][] requires an npm build step, you
should not use the shared workflow, or adapt it for your edge case, and
instead add an app specific workflow to release the gem
([example][publishing-components-release-workflow]).

[release-gem-workflow]: https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/publish-rubygem.yaml
[gh-secret]: https://docs.github.com/en/actions/security-guides/encrypted-secrets
[govuk-github-owners]: mailto:govuk-github-owners@digital.cabinet-office.gov.uk
[secret-access]: https://github.com/organizations/alphagov/settings/secrets/actions
[gh-workflow-example]: https://github.com/alphagov/govuk_schemas/blob/74c5375505e6f46272c393e49e0d4e081b2cdd21/.github/workflows/ci.yml
[govuk_publishing_components]: /repos/govuk_publishing_components.html
[publishing-components-release-workflow]: https://github.com/alphagov/govuk_publishing_components/blob/04225e53f0a70f64589ebd0c66dd4e444430e460/.github/workflows/ci.yml#L41-L70

## Ruby version compatibility

Our policy is that our Ruby gems are compatible with all [currently supported
minor versions of Ruby][supported-rubies]. For example, in November 2022, There
were supported Ruby releases of 2.7, 3.0 and 3.1, thus we expected gems to be
compatible with each of those and be tested against them (there is
[documentation][testing-gems] on the approach to test them).

We specify the minimum Ruby version supported in the [gemspec file][gemspec-ruby-version]
and expect the `.ruby-version` to match that version. For example, if Ruby 2.7
is the oldest supported minor version, we expect gems to require Ruby 2.7 or
greater and the `.ruby-version` file to reference the most recent Ruby 2.7
release (which in November 2022 was 2.7.6).

When new minor versions of Ruby are released (typically each Christmas) we
update gems to test against the new version. For example, when Ruby 3.2
was released, our gem test matrices were expanded to test against Ruby 3.2.

When Ruby versions reach end-of-life (typically April) we update gems
to drop support for that Ruby version and update the `.ruby-version` files to
the next supported version. For example, when Ruby 2.7 reached end of life, we dropped 2.7
from the test matrices and we updated the `.ruby-version` file to be the most
recent release of the 3.0 branch, which in March 2023 was 3.0.5
(see [example][example-pr-dropping-ruby-support]).

We should then release the updated gem as a *minor version*.
In the past, [our policy was to release as a major version][old-policy-major-version],
but this was superfluous given that the change is low risk (Dependabot shouldn’t
even raise a PR unless the upstream app is on a supported Ruby version). It also
limited our ability to benefit from the automated workflows agreed in RFC-156,
which [apply only to patch and minor version upgrades][rfc-156-versions].
Note that patch versions are generally reserved only for bug fixes.

[example-pr-dropping-ruby-support]: https://github.com/alphagov/gds-api-adapters/pull/1191
[gemspec-ruby-version]: https://guides.rubygems.org/specification-reference/#required_ruby_version
[minimum-ruby-gem]: https://github.com/alphagov/govuk_sidekiq/blob/12183f8781f2755e185e6a14a722e6f3892bda4a/govuk_sidekiq.gemspec#L19
[old-policy-major-version]: https://github.com/alphagov/govuk-developer-docs/pull/3932
[rfc-156-versions]: https://github.com/alphagov/govuk-rfcs/blob/main/rfc-156-auto-merge-internal-prs.md#4-version-increase-is-patch-or-minor
[supported-rubies]: https://www.ruby-lang.org/en/downloads/branches/
[testing-gems]: /manual/test-and-build-a-project-with-github-actions.html#a-ruby-gem

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
