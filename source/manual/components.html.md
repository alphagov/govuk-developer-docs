---
owner_slack: '#publishing-frontend'
title: Components
section: Frontend
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-09-01
review_in: 6 months
---

Components are packages of template, style, behaviour and documentation that live in your application or in static.

## Component guides

Components in applications are documented in component guides using the [govuk_publishing_components gem](https://github.com/alphagov/govuk_publishing_components). This mounts a component guide at the path `/component-guide` in development, test and on Heroku review apps.

Find components in these guides:

* [static component guide](https://govuk-static.herokuapp.com/component-guide/)
* [government-frontend component guide](https://government-frontend.herokuapp.com/component-guide/)
* [collections component guide](https://govuk-collections.herokuapp.com/component-guide/)
* [finder-frontend component guide](https://finder-frontend.herokuapp.com/component-guide/)

## Building components

A component must:

* [meet the component principles](https://github.com/alphagov/govuk_publishing_components/blob/master/docs/component_principles.md)
* [follow component conventions](https://github.com/alphagov/govuk_publishing_components/blob/master/docs/component_conventions.md)

The [govuk_publishing_components gem](https://github.com/alphagov/govuk_publishing_components) provides a generator to stub the files you’ll need in each component:

```
bundle exec rails generate govuk_publishing_components:component [component_name]
```

A lead paragraph component would be included in a template like this:

```erb
<%= render 'components/lead-paragraph', text: "A description is one or two leading sentences" %>
```
