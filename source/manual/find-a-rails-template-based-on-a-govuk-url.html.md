---
owner_slack: "#govuk-developers"
title: Find a rails template based on a GOV.UK URL or vice verca
section: Frontend
layout: manual_layout
type: learn
parent: "/manual.html"
---
When making changes to a template in one of our frontend apps it's often beneficial to see a rendered page with your change so that you can effectively test it. This can be difficult when developing within gov.uk as we have several frontend apps which control different parts of the site, sometimes overlapping in sections that they take responsibility for. This document details ways in which you can bypass this issue.

## Option 1: Use the GOV.UK browser extension

[The GOV.UK browser extension](https://github.com/alphagov/govuk-browser-extension) provides a number of details on a given page on GOV.UK, including the app which renders that page. This can be a good start in working out which template renders a particular page, however doesn't help when you are trying to find a URL based on static analysis of our frontend apps.

## Option 2: Check the routes file in a given app

As our frontend apps are all ruby on rails apps, it can be assumed that most views follow [the typical MVC flow](https://www.sitepoint.com/model-view-controller-mvc-architecture-rails/) of a route being specified in `routes.rb`, this route calling a controller, that controller rendering a view and that view being located in `app/views` of a given application, identified in line with the name of the controller and the action within that controller. For example: a route could be specified that whenever the path `/government/organisations` is hit, it calls the `index` action of the `organisations` controller (shorthanded to `organisations#index`), this controller would then render at `app/views/organisations/index.html.erb`. You can follow this both path to template and template to path.

A downside of this technique is that we allow publishers to set unique slugs for their content, which can't be easily interpreted via static analysis.

## Option 3: Use Kibana to find a controller or path

Kibana is an interface for traversing logs on GOV.UK and includes a lot of useful information, such which controller and which route a given path is rendered by. In order to access it you'll first need access to [logit](/manual/logit.html) (specific instructions on how to successfully sign into logit can be found [here](https://reliability-engineering.cloudapps.digital/logging.html#content), ensure that you're part of the govuk gmail group before following these steps).

You can find a lot of useful tips and instructions on using Kibana, including this particular use case, [here](/manual/kibana.html).
