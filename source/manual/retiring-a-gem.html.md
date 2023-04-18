---
owner_slack: "#govuk-developers"
title: Retire a gem
section: Applications
layout: manual_layout
parent: "/manual.html"
---

## 1. Ensure the gem is not used by any apps

Search for references to the gem in our codebase to see if any apps are still using it:

[example](https://github.com/search?q=org%3Aalphagov+rack-logstasher+filename%3AGemfile+filename%3A*.gemspec&type=Code&ref=advsearch&l=&l=)

For any repos which are found to have the gem as a dependency, you should confirm that the gem _is_ actually being used and that it's not simply a leftover artefact that is no longer in use.
Check the usage instructions in the gem's README and then search for the corresponding code in the repo (e.g. `use Rack::Logstasher::Logger`). Alternatively, find the commits where the gem was added and used, and see if the corresponding code that uses the gem still exists.

If the gem is being used you will either need to replace it with a different gem or your own code before you can archive it.

If removing the gem from an app, take the usual measures of due diligence (e.g. ensuring tests pass, monitoring the release for Sentry errors, etc).

## 2. Update gem's README and archive it

When the gem's repo is ready to be archived, push a commit explaining the reasons for archiving it.

[Example](https://github.com/alphagov/govuk_taxonomy_helpers/pull/27)

Go into the repository settings in GitHub, and
[archive the repo](https://github.com/blog/2460-archiving-repositories).

## 3. Remove references and update docs

Do a [code search on GitHub][https://github.com/search?q=org%3Aalphagov+panopticon&type=Code] to find any references to the gem
and update or remove them.

Mark the gem as `retired` in [govuk-developer-docs][https://github.com/alphagov/govuk-developer-docs].

## 4. Yank the gem (optional)

Once the gem has been archived you may want to [yank it from Rubygems](https://guides.rubygems.org/removing-a-published-gem/) if it was published there. You can find the Rubygems credentials in [govuk-secrets](https://github.com/alphagov/govuk-secrets).

You should only really do this if the gem was published in error or contains a security vulnerability. If it's simply that the gem is no longer maintained, it's fine to leave it published.
