---
owner_slack: "#govuk-developers"
title: Retire a repo
section: Applications
layout: manual_layout
parent: "/manual.html"
---

# Retire a repo

## 1. Update README

Add a note to the top of the README explaining that the repo has been retired and, if applicable, what it has been replaced by.

## 2. Close open issues and pull requests

Once a repository is archived all of its issues and pull requests become read-only and the authors will not be able to close them. We want to avoid giving the impression that these will eventually be acted upon. Leaving them open will also affect metrics we collect such as Dependabot statistics.

## 3. Unpublish the GitHub pages site (if it has one)

Archiving a repo doesn't affect the GitHub Pages site linked to the repository. We should retire the site carefully because it may be possible for someone else to reuse the URL.

- Remove any references to the URL from documentation and code
- Delete any DNS entries for the site if the site uses a custom domain
- Unpublish the GitHub Pages site

## 4. Archive the repo

Go into the repository settings in GitHub, and [archive the repo](https://github.com/blog/2460-archiving-repositories).

## 5. Update the Developer Docs

Mark the application as `retired` in [govuk-developer-docs](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml).

## 6. Remove other references

Do a [search on GitHub](https://github.com/search?q=org%3Aalphagov+panopticon&type=Code) to find any references to the repository and update or remove them.
