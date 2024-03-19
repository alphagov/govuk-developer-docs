---
owner_slack: "#govuk-developers"
title: Publish a Ruby gem
section: Packaging
layout: manual_layout
parent: "/manual.html"
---

## Conventions

For conventions around naming, refer to the [RubyGems naming guide][] and the
[GOV.UK naming policy][].

Follow [Semantic Versioning][] and put version updates in their own commit.

Follow the file and directory [conventions used by Bundler][].

[conventions used by Bundler]: https://bundler.io/guides/creating_gem.html
[Semantic Versioning]: https://semver.org/
[RubyGems naming guide]: http://guides.rubygems.org/name-your-gem/
[GOV.UK naming policy]: /manual/naming.html#naming-gems

## Releasing gem versions

Use GitHub Actions for releasing gems, with our [shared publish workflow][] and the
`ALPHAGOV_RUBYGEMS_API_KEY` secret. For builds with extra needs (e.g. the npm
build step in govuk_publishing_components), copy and adapt the shared workflow.

Contact a [GOV.UK GitHub Owner][] to grant your repository
[access to the secret][].

[shared publish workflow]: https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/publish-rubygem.yml
[GOV.UK GitHub Owner]: mailto:govuk-github-owners@digital.cabinet-office.gov.uk
[access to the secret]: https://github.com/organizations/alphagov/settings/secrets/actions

## Automatically releasing patch-level versions

Use the [shared autorelease workflow][] and the `GOVUK_CI_GITHUB_API_TOKEN`
secret to automatically raise a PR to perform a patch-level version bump if the
gem has unreleased changes, and all of those changes were authored by
Dependabot.

After a developer approves and merges that PR, the publish-rubygem workflow (if
present) will automatically publish the next release to Rubygems.

[shared autorelease workflow]: https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/autorelease-rubygem.yml

## Ruby version compatibility

Ensure gems are compatible with all [supported minor Ruby
versions][supported-rubies], specifying the minimum minor Ruby version in the gemspec
file. For example: `spec.required_ruby_version = ">= 3.1"`.

> Do not specify a patch (or "tiny") Ruby version unless there is a particular issue with a Ruby patch release.

The `.ruby-version` file should be the same minor version level as the
`required_ruby_version` in the gemspec, it is typically the most recent patch version.
For example: `spec.required_ruby_version >= "3.1"` would correlate to a `.ruby-version`
of 3.1.4.

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
[minimum-ruby-gem]: https://github.com/alphagov/govuk_sidekiq/blob/12183f8781f2755e185e6a14a722e6f3892bda4a/govuk_sidekiq.gemspec#L19
[old-policy-major-version]: https://github.com/alphagov/govuk-developer-docs/pull/3932
[rfc-156-versions]: https://github.com/alphagov/govuk-rfcs/blob/main/rfc-156-auto-merge-internal-prs.md#4-version-increase-is-patch-or-minor
[supported-rubies]: https://www.ruby-lang.org/en/downloads/branches/
[testing-gems]: /manual/test-and-build-a-project-with-github-actions.html#a-ruby-gem
