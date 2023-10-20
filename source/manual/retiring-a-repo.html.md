---
owner_slack: "#govuk-developers"
title: Retire a repo
section: Applications
layout: manual_layout
parent: "/manual.html"
---

## 1. Update the README

Add a note to the top of the README explaining that the repo has been retired and, if applicable, what has replaced it.

In some cases it _may_ be appropriate to skip this step if:

- the repo is already disused and has been for a long time
- the repo is private and not widely known within the organisation
- there isn't a replacement, so there's no need to point the reader towards something else

## 2. Close all issues and pull requests

This is necessary because GitHub does not automatically close or archive PRs/issues when archiving a repo. For example, if an old PR is still open when the repo is archived, its author will be unable to close it and it will forever remain on their `github.com/pulls` page.

If there are more than a handful of open issues/PRs, consider using the [GitHub CLI tool](https://cli.github.com/) (`gh pr`, `gh issue`).

## 3. Unpublish the GitHub pages site (if it has one)

Archiving a repo does not remove its GitHub Pages site (if any). The site stays up but the settings become read-only.

⚠️ Take care when unpublishing a GitHub Pages site which has a custom domain. If you leave a dangling DNS record pointing at GitHub, it will likely be hijacked by spammers (or worse).

1. Check whether the site has any custom domains configured. This is under Settings, Pages, Custom domain in the GitHub web UI. **Do not remove the custom domain.**
1. Remove any [DNS records](/manual/dns.html) that point to the site, if the site uses a custom domain.
1. [Unpublish the GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/unpublishing-a-github-pages-site).

## 4. Archive the repo

Go into the repository settings in GitHub, and [archive the repo](https://github.com/blog/2460-archiving-repositories).

## 5. Update the Developer Docs

If the repo is listed in [govuk-developer-docs](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml), mark the application as `retired`.

If the repo wasn't already listed in Developer Docs then don't add it.

([#4259](https://github.com/alphagov/govuk-developer-docs/issues/4259) would eliminate this toil if fixed.)

## 6. Remove references

[Search GitHub](https://github.com/search?q=org%3Aalphagov+panopticon&type=Code) for any references to the repository and update or remove them as appropriate.

You should search for:

- the repo name
- links to the GitHub Pages site, if there was one
