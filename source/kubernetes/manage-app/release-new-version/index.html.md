---
title: How a new version of an app is released
weight: 45
layout: multipage_layout
---

# How a new version of an app is released

A new release of an app automatically occurs when:

- a user merges a PR to the main branch of an app's GitHub repo
- the merge commit passes all [pre-release tests](/manage-app/access-ci-cd/#continuous-deployment-of-a-release-of-a-gov-uk-app)

The [`release.yml` shared workflow](https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/release.yml) runs automatically in GitHub Actions and adds a Git tag for the release. Release tags are of the form `v` followed by a sequential number.
