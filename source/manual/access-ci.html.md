---
owner_slack: "#2ndline"
title: Get access to CI (Jenkins)
section: Testing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-07-12
review_in: 6 months
---

Our [Jenkins CI environment][ci] uses GitHub Enterprise for authorisation. You need to be given access first, otherwise you won't see any projects, or see a message that you're unauthorised.

If you want access you will have to be added to one of:

- [GOV.UK security-cleared staff][team-1]  
- [GOV.UK non-security-cleared-devs][team-2]

These links will likely 404 for you (because you're not a member). Find a GitHub Enterprise admin to add you. Your tech lead can likely help.

## Further reading

The config that determines that the above teams have access [lives in govuk-puppet][puppet]. Look for the `govuk_jenkins::config::user_permissions` key.

[ci]: /manual/jenkins-ci.html
[team-1]: https://github.digital.cabinet-office.gov.uk/orgs/gds/teams/gov-uk-security-cleared-staff
[team-2]: https://github.digital.cabinet-office.gov.uk/orgs/gds/teams/gov-uk-non-security-cleared-devs
[puppet]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/class/ci_master.yaml
