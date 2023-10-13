---
owner_slack: "#govuk-developers"
title: How to add popular GOV.UK Slack integrations
section: Team tools
layout: manual_layout
type: learn
parent: "/manual.html"
---

## Seal

[Seal](https://github.com/alphagov/seal) is a Slack bot that informs teams which pull requests they have open.

### Configuration

Create a PR which adds some information (including team name and Slack channel) to [alphagov.yml in the Seal repo](https://github.com/alphagov/seal/blob/main/config/alphagov.yml). The Slack channel name does not need to match the team name.

Add the team name to [Morning Seal and Afternoon Seal](https://github.com/alphagov/seal/tree/main/.github/workflows) if you want two notifications a day, otherwise just pick one.

Make sure that the Slack channel name has been set as the 'team' in [repos.yml in the GOV.UK Developer Docs repo](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml). This will [update this JSON endpoint](/repos.json) which is [used by the Seal](https://github.com/alphagov/seal/blob/main/lib/team_builder.rb#L97).

## Dependapanda

Dependapanda is a Slack bot which posts a list of open Dependabot Pull Requests for repos that a team owns.

### Configuration

The process is the same as [configuring the Seal](/manual/slack-integrations.html#configuration). However, the team name will need to be added into [Dependapanda](https://github.com/alphagov/seal/blob/main/.github/workflows/dependapanda.yml) as opposed to the morning/afternoon Seal files.

[More information about the Seal can be found in Seal’s Github Readme](https://github.com/alphagov/seal/tree/main).

## Rotabot

The Rotabot calculates who’s turn it is to do the housekeeping today and tomorrow (usually tasks such as being in charge of Dependabots and Sentry alerts). The tasks in the Slack message are configured using Markdown, so it's fairly flexible.

### Configuration

The Rotabot is configured using the [govuk-rota-announcer repo](https://github.com/alphagov/govuk-rota-announcer/). Add your team config to the [weekday](https://github.com/alphagov/govuk-rota-announcer/blob/main/config/weekday.yml) or [weekly](https://github.com/alphagov/govuk-rota-announcer/blob/main/config/weekly.yml) config depending on how often they want to be notified.

## Release App Badger

The Release App Badger informs the team if there are pull requests that have not been deployed for a while or if environments are out of sync. This was originally configured in a repo called [GOV.UK Deploy Lag Badger](https://github.com/alphagov/govuk-deploy-lag-badger/) but the functionality was moved into the Release app as a result of the move to EKS.

### Configuration

In the Release app, the badger will notify teams [depending on the dependency_team](https://github.com/alphagov/release/pull/1198/files#diff-80e54224c5cd63358602f18016d42c42e208b7269bba5495cbc6a5ac3afac597R34) which is set in [repos.json](/repos.json). The `dependency_team` field in the repos.json file is [pulled from the team field](https://github.com/alphagov/govuk-developer-docs/blob/main/app/repo.rb#L168) in the [repos.yml file](https://github.com/alphagov/govuk-developer-docs/blob/a828a685cb9d475554b7144d0e13d91ac0e41337/data/repos.yml#L270) if dependency_team isn’t set. If dependency_team isn't set, the `team` in [repos.yml file](https://github.com/alphagov/govuk-developer-docs/blob/a828a685cb9d475554b7144d0e13d91ac0e41337/data/repos.yml) would need to be the name of the Slack channel that you want to post to.

## Sentry

[Sentry](/manual/sentry.html) is an error monitoring tool that we use on GOV.UK.

### Configuration

[Please see these docs](/manual/sentry.html#slack-alerts). When creating a rule to send a notification to Slack, you may find that you need to input a channel ID as well as channel name. The ID can be found by clicking on the channel name in Slack and scrolling down until you can see the channel ID.
