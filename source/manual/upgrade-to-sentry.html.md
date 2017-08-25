---
title: Upgrade to Sentry
parent: "/manual.html"
layout: manual_layout
section: Monitoring
owner_slack: "@tijmen"
last_reviewed_on: 2017-08-21
review_in: 1 month
---

We are [migrating all apps][trello] to use Sentry.

## 1. Make the application changes

To upgrade make a PR that does the following:

1. Remove the `airbrake` gem from the app
2. Add `govuk_config` gem
3. Upgrade `govuk_sidekiq` to at least `2.0.0` to maintain error reporting
4. Remove the Airbrake initialiser `rm config/initializers/airbrake.rb`
5. Change any manual calls to Airbrake with new-style error logs:

  ```rb
  GovukError.notify("My message here")
  ```

  More about this in [govuk_app_config's README][rm].

  [rm]: https://github.com/alphagov/govuk_app_config#usage

## 2. Test that error reporting works

The deploy script will attempt to run the old Airbrake notification rake task. This task doesn't exist anymore, so it will send an error to Sentry. If you can see it on Sentry, then you've successfully upgraded. Well done! ✊

You can also trigger a test exception manually by [running the sentry: rake task][test-sentry].

Don't forget to [mark your Trello ticket as done][trello].

[test-sentry]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild?RAKE_TASK=raven:test
[trello]: https://trello.com/b/aZ0OD1qJ/sentry-migration
