---
owner_slack: "#govuk-developers"
title: READMEs for GOV.UK applications
section: Documentation
layout: manual_layout
type: learn
parent: "/manual.html"
---

This is a guide to writing and maintaining README documents for GOV.UK's public repositories. It's based on [guidance we have in the GDS Way for READMEs](https://gds-way.digital.cabinet-office.gov.uk/manuals/readme-guidance.html#writing-readmes).

READMEs are for a technical audience. This could be a new starter or an existing developer. Using the following template will help to ensure each README is consistent, correct, short and actionable.

Unless it helps someone to get started, any other content should be a separate file in the `docs/` directory for a repository. This also makes the content easier to discover in external search.

## Template for new READMEs

```markdown
# App name

One or more paragraphs describing the app: what it's used for and how it relates to the rest of GOV.UK. Try to link to existing documentation and other READMEs to help keep the description concise.

## Live examples

(Only applies to frontend apps.)

A list of links to example pages rendered by the app.

## Nomenclature

A list of definitions for unusual terms in the code.

## Technical documentation

What goes here depends on the type of app.

See the links below for example content to put here.

### Before running the app (if applicable)

Anything that's not done automatically by the development environment:

- Dependencies that need to be installed manually.
- One-off commands that need to be run manually.

### Running the test suite

Give one command to run all the tests, linting, etc.

You can also suggest other commands e.g. to run JS tests, run ...

### Further documentation

A list of links to key files in docs/.

You can also just link to the docs/ directory itself.

## Licence

Link to your LICENCE file.
```

Examples READMEs that follow the above structure:

- [Frontend app: Collections](https://github.com/alphagov/collections/blob/13e53b7b63b2a9c1e618ba309756523341befc5b/README.md#technical-documentation)

- [General app: Email Alert API](https://github.com/alphagov/email-alert-api/blob/451481ce0b6335bb1f640ef52fa0e8305f38d09c/README.md#technical-documentation)

## GitHub repo description

These appear in [search results](https://github.com/alphagov/). A good description should use simple language and make it clear the repository is part of GOV.UK. Example: "GOV.UK filtered search of public content".

Use the GitHub link field to link to the developer docs page for the repository, or otherwise the live service (if it's public facing).

## CONTRIBUTING.md

**Don't add this unless the repository gets a lot of external contributions.**

Use GitHub's [CONTRIBUTING.md](https://help.github.com/articles/setting-guidelines-for-repository-contributors/) guidelines for this. Always link to the [GOV.UK pull request style guide](https://github.com/alphagov/styleguides/blob/master/pull-requests.md).

## LICENCE

Follow [GitHub convention](https://help.github.com/articles/open-source-licensing/#where-does-the-license-live-on-my-repository).
