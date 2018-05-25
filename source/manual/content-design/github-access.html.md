---
title: Github Access
parent: "/manual.html"
layout: manual_layout
section: Content Design
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2018-05-25
review_in: 3 months
---

Content designers working on GOV.UK may need GitHub access to edit content
which is stored as code in an application, for example
[smart answers][smart-answers-github]. For this we have a dedicated GitHub team
that content designers can be added to. When added to this team a content
designer can create a branch within a GOV.UK repository and open a pull
request, however a developer will be required to merge the request into the
master branch.

## Adding someone to the GitHub team

When a content designer joins they will need to be added to our monitoring
software and then can be added to the GitHub team. These are the steps to
follow:

1. Edit the [users.yml][] file in [govuk-user-reviewer][] with the designers
   name, GitHub username and role in GOV.UK - [example][user-example]
1. Raise this as a pull request
1. Once PR is merged email gds-github-owners@digital.cabinet-office.gov.uk
   with their GitHub username asking for the user to be added to the "GOV.UK
   Content Designers" GitHub team
1. Once added to the team the content designer will receive an invite that
   they will have to accept to join the team

## Removing someone from the GitHub team

When a content designer leaves GOV.UK they need to be removed from the GitHub
team to revoke their access. These are the steps to follow:

1. Email gds-github-owners@digital.cabinet-office.gov.uk
   with their GitHub username asking for the user to be removed from the
   "GOV.UK Content Designers" GitHub team
1. Edit the [users.yml][] file in [govuk-user-reviewer][] to remove the user
1. Raise this as a pull request
1. Once merged GOV.UK 2nd Line will be alerted if the user continues to have
   access despite having left

[smart-answers-github]: https://github.com/alphagov/smart-answers
[users.yml]: https://github.com/alphagov/govuk-user-reviewer/blob/master/config/users.yml
[govuk-user-reviewer]: https://github.com/alphagov/govuk-user-reviewer
[user-example]: https://github.com/alphagov/govuk-user-reviewer/pull/114/commits/2bfff951faf1eb57b70022f90e926e51605e63a0

