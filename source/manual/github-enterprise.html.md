---
owner_slack: "#2ndline"
title: GitHub Enterprise
section: Tools
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/github-enterprise/index.md"
last_reviewed_on: 2017-05-09
review_in: 2 months
---

Our GitHub Enterprise installation lives at [https://github.digital.cabinet-office.gov.uk]() and is managed by the GDS service desk.

It's used for:

- [Backups](github-unavailable.html) of our [public repositories](https://alphagov.github.io/gds-tech/source-code.html)
- Older private repositories that haven't been moved to github.com
- Authentication with Jenkins CI ([ci.integration.publishing.service.gov.uk](https://ci.integration.publishing.service.gov.uk))

GOV.UK data on GitHub Enterprise should be encrypted in the repository (for example
using a list of GOV.UK GPG keys).

GitHub Enterprise should not be used for new repositories or OAuth authentication.
