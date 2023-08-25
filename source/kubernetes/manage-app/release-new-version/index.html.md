---
title: How a new version of an app is released
weight: 45
layout: multipage_layout
---

# How a new version of an app is released

A new release of an app automatically occurs when:

- a user adds a new merge commit to the main branch of an app
- that app successfully passes all [pre-release tests](/manage-app/access-ci-cd/#continuous-deployment-of-a-release-of-a-gov-uk-app)

Jenkins automatically adds a Git tag with the release number to that merge commit. The release tag is a number, incremented by one from the number of the previous release tag.
