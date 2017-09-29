---
owner_slack: "#govuk-developers"
title: Publishing a Ruby gem
section: Patterns & Style Guides
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-09-29
review_in: 6 months
---

## Naming

In general, the gem name should be the same as the thing you require when using
it.  This means using `_`, and not `-` to separate multi-word gem names.  See
http://guides.rubygems.org/name-your-gem/ for more detailed guidance.

## Versioning

Follow the guidelines on [semver.org](http://semver.org/) for assigning version
numbers.

Versions should only be changed in a commit of their own, in a pull request of
their own. This alerts team members to the new version and allows for
last-minute scrutiny before the new version is released. Also, by raising a
separate pull request, we avoid version number conflicts between feature
branches.

## File layout

We should follow the scheme used by Bundler when creating gems (see [this
railscast](http://railscasts.com/episodes/245-new-gem-with-bundler?view=asciicast)).

Some points to note:

* The version is stored in a file by itself in `lib/<gem_name>/version.rb`.
* The Gemfile references the gemspec for gem dependencies.  All gem
  dependencies should be specified in the gemspec.
* The Gemfile.lock is **never** committed (it should be in the `.gitignore`
  file).

## Releasing gem versions

The default Jenkins build script will automatically detect the presence of a
`gemspec` file and publish the gem to rubygems.org. See the
[Jenkinsfile for govuk-lint](https://github.com/alphagov/govuk-lint/blob/master/Jenkinsfile)
for an example.
