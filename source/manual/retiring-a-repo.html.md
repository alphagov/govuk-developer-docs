---
owner_slack: "#govuk-developers"
title: Retire a repo
section: Applications
layout: manual_layout
parent: "/manual.html"
---

## 1. Update README

Add a note to the top of the README explaining that the repo has been retired and, if applicable, what it has been replaced by.

## 2. Update the Developer Docs

Mark the application as `retired` in [govuk-developer-docs](https://github.com/alphagov/govuk-developer-docs).

## 3. Remove other references

Do a [search on GitHub](https://github.com/search?q=org%3Aalphagov+panopticon&type=Code) to find any references to the repository and update or remove them.

## 4. Archive the repo

Go into the repository settings in GitHub, and [archive the repo](https://github.com/blog/2460-archiving-repositories).
