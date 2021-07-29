---
owner_slack: "#govuk-data-labs"
title: Start a new project
section: Data Labs Team Manual
layout: manual_layout
parent: "/manual.html"
---

When starting a new data science project, you should:

- store your project in GitHub
- set up your project using `govcookiecutter`
- organise your workload using Trello

## Store your projects in GitHub

You must store all your projects in GitHub repositories (repos).

See the [GOV.UK developer documentation on setting up your GitHub account](https://docs.publishing.service.gov.uk/manual/get-started.html#2-set-up-your-github-account) for information on how to get access to GitHub.

You should follow best practice when storing projects in GitHub:

- store GOV.UK projects in [`alphagov` organisation](https://github.com/alphagov) repos
- store non-GOV.UK projects in [`ukgovdatascience` organisation](https://github.com/ukgovdatascience) repos
- do not store repos under your GitHub username
- set your repo to public where possible as the GOV.UK Data Labs team likes to code in the open
- when naming your repo, use hyphens instead of underscores to separate words.
- to make sure colleagues have access to repo if the repo owner leaves, grant the following GitHub teams access to your `alphagov` repositories:
  - admin access: `gov-uk-production`
  - write access: `gov-uk-data-scientists`
- for `ukgovdatascience` repos, grant the following GitHub teams access:
  - write access: `gdsdatascience`

By default, GitHub organisation owners have admin access to all repos. If you cannot access a repo, speak to the owner for access.

See the [GitHub documentation on access permissions](https://docs.github.com/en/get-started/learning-about-github/access-permissions-on-github) for more information.

### Add branch protection rules

You must add branch protection rules to the `main` branch of your repo to prevent unwanted actions to this branch. At a minimum, set that all pull requests require at least one approved review.

1. Go to your GitHub repo.
1. Select __Settings__ and then select __Branches__ in the left-hand navigation.
1. In __Branch protection rules__, select __Add rule__.
1. Enter "main" into the __Branch name pattern__ field.
1. In __Protect matching branches__, select the __Require pull request reviews before merging__ checkbox. By default this requires one approving review.
1. Change any other options as necessary.
1. Select __Save changes__.

## Set up your project using `govcookiecutter`

You should use `govcookiecutter` to set up your data science project.

[`govcookiecutter`](https://github.com/ukgovdatascience/govcookiecutter) is a template for data science projects in HM Government and the wider public sector.

`govcookiecutter` was designed by the GDS Data Science team to:

- make sure data science projects use Agile approaches to adhere to AQA standards
- prevent data leakage by enforcing data version control and cleaning Jupyter notebook outputs
- centralise documentation local to code so documentation is kept up to date and changes made are visible to reviewers
- make sure secrets and credentials are usable locally, but kept out of version control
- implement a consistent folder structure to reduce onboarding time

If you use `govcookiecutter` to set up a data science project, `govcookiecutter` automatically covers most of these needs.

For more information, see the:

- [`govcookiecutter` documentation](https://github.com/ukgovdatascience/govcookiecutter)
- [July 2021 blog on govcookiecutter](https://dataingovernment.blog.gov.uk/2021/07/20/govcookiecutter-a-template-for-data-science-projects/)

## Organise your workload using Trello

GOV.UK Data Labs adopts [Agile ways of working](https://agilemanifesto.org/). We use Trello to maintain a team-wide [Kanban-style way of working](https://en.wikipedia.org/wiki/Kanban_(development)), although specific projects may adopt other methodologies such as [Scrum](https://scrumguides.org/index.html).

To make sure all projects are visible to the team, you should write and update cards on Trello. GOV.UK Data Labs has two Trello boards:

- the [Data Labs doing board](https://trello.com/b/FMptFIIw/data-labs-doing-board), a Trello board for all tasks in the current sprint
- the [Data Labs planning board](https://trello.com/b/s6TGpjeA/data-labs-planning-board), a Trello board for all planned tasks for future sprints

For new epics, create an epic using the __Epic template__ card and summarise the epic.

For new and existing projects, create stories using the __Story template__ card.

Stories should cover a specific task that has a valid acceptance criteria. Acceptance criteria are your “definition of done”. You should make the minimum developments to meet this criteria.

Draft any further work over and above this acceptance criteria as new stories.

### Label and estimate Trello cards

For both epics and stories, make sure you label the Trello cards appropriately. If relevant, you should also try to label stories with a time estimate.

Try to include time for colleagues to review your work. If stories are sufficiently small and discrete, reviewing should take a reasonable length of time.

You should include time for colleagues to review because:

- explicitly providing review time ensures reviewers have dedicated time for them
- not planning sufficient review time may lead to poorer quality reviews due to non-story related pressures
- any unused review time is never lost as reviewers can start other stories

Try to make your stories manageable, and doable within a sprint (usually two weeks). This makes sure the story completion rate (otherwise known as velocity) is fast enough, and means that your stories are targeted to meet a need.

If a story is not well defined, split up that story into smaller stories to make it easier to complete them.

If it is difficult to estimate how long a story should take, consider running that story as a spike. A spike is a set time interval to explore and report back on a task.
