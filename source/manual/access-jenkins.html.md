---
owner_slack: "#govuk-developers"
title: Get access to Jenkins
section: Accounts
layout: manual_layout
parent: "/manual.html"
---

Our Jenkins installations ([deploy](https://deploy.integration.publishing.service.gov.uk/) and [CI](https://ci.integration.publishing.service.gov.uk/)) use GitHub for authentication and authorisation.

- For integration admin access, you need to be added to the [GOV.UK team][]
- For [staging][] and [production][] [deploy access](/manual/rules-for-getting-production-access.html#production-deploy-access), you need to be added to the [GOV.UK Production Deploy team][]
- For [staging][] and [production][] [admin access](/manual/rules-for-getting-production-access.html#production-admin-access), you need to be added to the [GOV.UK Production Admin team][]

Without this you won't see any projects or you'll see a message that says you are unauthorised.

Usually your tech lead or a member of senior tech can add you to the right team in GitHub. Try asking in the `#govuk-tech-leads` Slack channel if you're struggling to find someone.

[GOV.UK team]: https://github.com/orgs/alphagov/teams/gov-uk
[GOV.UK Production Admin team]: https://github.com/orgs/alphagov/teams/gov-uk-production
[GOV.UK Production Deploy team]: https://github.com/orgs/alphagov/teams/gov-uk-production-deploy
[staging]: https://deploy.blue.staging.govuk.digital/
[production]: https://deploy.blue.production.govuk.digital/
