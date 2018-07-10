---
owner_slack: "#govuk-2ndline"
title: Migrate testing from PhantomJS to Selenium/headless Chrome
section: Testing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-12
review_in: 2 months
---

Many GOV.UK apps use PhantomJS for integration and feature testing. PhantomJS development has now been abandoned and there are some outstanding bugs that will not be fixed.

To move to a supported setup for integration and feature testing, Selenium and Chrome along with supporting services are available in the development VM and CI.

You can migrate apps from PhantomJS to Chrome by using the [`govuk_test`](https://github.com/alphagov/govuk_test) gem along with Capybara. This gem configures Capybara to use Chrome via Selenium to conduct browser-based testing. As a bonus, running the app's test suite locally will open a Chrome window so you can view the tests as they run and troubleshoot any issues.

As an example of migrating an app from PhantomJS to Chrome, see the [pull request for the collections app](https://github.com/alphagov/collections/pull/774). This PR predates the `govuk_test` gem but follows the same principles.
