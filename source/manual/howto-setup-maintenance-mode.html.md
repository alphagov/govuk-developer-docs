---
owner_slack: "#govuk-developers"
title: Setup maintenance mode
section: Frontend
layout: manual_layout
parent: "/manual.html"
related_repos: [frontend, government-frontend]
---

## What is maintenance mode?

Maintenance mode is a way of displaying a user-friendly message on a public facing application to inform them that a service is unavailable e.g. due to planned downtime. This is more helpful than routing them to an error page.

The example below uses the [notice component](https://components.publishing.service.gov.uk/component-guide/notice) to display the message.

## Setup maintenance mode

There are three main steps involved:

1. Create a maintenance flag
2. Disable/Enable E2E(end-to-end) tests
3. Enable/Disable the maintenance mode in [govuk-helm-charts](https://github.com/alphagov/govuk-helm-charts)

## 1. Create a maintenance flag

> Note: This is a one-time setup that is done in the application

1. Add the initializer file for e.g. `maintenance.rb` to read the environment variables under `config/initializers/`

    ```erb
    Rails.application.config.maintenance_mode = ENV["MAINTENANCE_MESSAGE"].present?
    Rails.application.config.maintenance_message = ENV["MAINTENANCE_MESSAGE"]
    ```

### In app view template

This is done when only a part of the application requires downtime.

1. Identify the service that would be impacted
2. Wrap the code to be shown/hidden in a conditional statement (e.g. `unless`), and include the notice component which uses the `Rails.application.config.maintenance_message`, see [this commit](https://github.com/alphagov/frontend/pull/5072/commits/709494c2d3dc367cea7afe98b7898ea1e0ee19ae) as an example.

   [Example frontend PR](https://github.com/alphagov/frontend/pull/5072)

### In routes file

When we need to ensure that _all routes_ serve the maintenance page during downtime, we can enable the maintenance flag in `routes.rb`. This diverts all incoming traffic to a dedicated maintenance controller, regardless of the request method (GET, POST, etc.)

1. Add the below line in `routes.rb` file to redirect all incoming requests to the `MaintenanceController`:

    ```erb
    match "*" => "maintenance#show", via: %i[get post] if Rails.application.config.maintenance_mode
    ```

2. Add the notice component in a `maintenance view` page

    [Example email-alert-frontend PR](https://github.com/alphagov/email-alert-frontend/pull/2159)

## 2. Disable/Enable E2E(end-to-end) tests

During planned outages, E2E (end-to-end) tests — if any — should be disabled to prevent CI/CD pipelines from failing or blocking deployments while the application is unavailable.

1. To disable a test from a specific environment add:

    `{ tag: ["@not-<environment"] }`

     See [govuk-e2e-tests](https://github.com/alphagov/govuk-e2e-tests/pull/348) as an example

2. Create/merge a **revert PR** to re-enable them once the system downtime is completed.

## 3. Enable/Disable the maintenance mode in govuk-helm-charts

> Note: This is done right when you are about to make changes and the system becomes unavailable to users.

1. Add the configuration for maintenance mode in `govuk-helm-charts` for that particular environment like Integration, Staging or Production
2. Update the maintenance message optionally with the downtime that the app might need to recover in `charts/app-config/<values-env>.yaml` file of the appropriate environment

    ```erb
    - name: MAINTENANCE_MESSAGE
      value: "The system will be unavailable for essential maintenance until 14:30, please try again later"
    ```

3. If required, scale down any dependent applications and/or workers - _not_ the app in maintenance mode - by setting `appEnabled: false` as in [here](https://github.com/alphagov/govuk-helm-charts/pull/3703/commits/8282ccd526f94bc362af97d0b4f8a8b4a5b44434). This prevents job processing while the app is in maintenance mode.

4. Merge the changes

    [Example helm-charts PR](https://github.com/alphagov/govuk-helm-charts/pull/3632)

5. Navigate to **Argo CD** where we can see [app-config](https://argo.eks.production.govuk.digital/applications/cluster-services/app-config?view=tree&resource=) update and apply the changes

6. _The user facing page now displays the maintenance message!_

7. Create and merge the **Revert PR** once the system changes are done so that the app renders the original content.

   [Example helm-charts PR](https://github.com/alphagov/govuk-helm-charts/pull/3665)
