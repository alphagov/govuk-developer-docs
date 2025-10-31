---
owner_slack: "#govuk-developers"
title: Setup maintenance mode
section: Frontend
layout: manual_layout
parent: "/manual.html"
related_repos: [frontend, government-frontend]
---

## What is maintenance mode?

During phases when an application requires to be shut down temporarily for maintenance purposes like upgrading a database from older version to newer version, especially for public facing apps such as government-frontend and frontend, it is good to provide a message mentioning about the maintenance instead of displaying error pages to the users

## Setup maintenance mode

There are 2 steps for setting up maintenance mode:

1. Create a maintenance flag in the app views
2. Enable/Disable the maintenance mode

## Create a maintenance flag in the app views

1. Identify the form/forms that would be impacted
2. Set the maintenance flag for the whole form in the particular views
3. Place the below notice component in the else part i.e when maintenance flag is set

<% unless Rails.application.config.maintenance_mode %>
[The actual form]
else
<%= render "govuk_publishing_components/components/notice", {
    description_govspeak: sanitize(Rails.application.config.maintenance_message),
  } %>

4. Set up the initializer file to read the environment variables

Rails.application.config.maintenance_mode = ENV["MAINTENANCE_MESSAGE"].present?
Rails.application.config.maintenance_message = ENV["MAINTENANCE_MESSAGE"]

[Example PR][https://github.com/alphagov/frontend/pull/5072]

## Enable/Disable the maintenance mode

Note: This is done right when you are about to make changes and the system becomes unavailable to users

1. Add the configuration for maintenance mode in govuk-helm-charts for that particular environment like Integration, Staging or Production
2. Update the maintenance message optionally with the downtime that the app might need to recover in app-config/<values-env>.yaml file of the appropriate environment [env could be integration,staging or production]

- name: MAINTENANCE_MESSAGE
  value: "The system will be unavailable for essential maintenance from 11:10-11:30, please try again later"
3. Merge the changes

Example PR [https://github.com/alphagov/govuk-helm-charts/pull/3632]

The user facing page now displays the maintenance message

4. Create Revert PR once the system changes are done

Example PR [https://github.com/alphagov/govuk-helm-charts/pull/3665]
