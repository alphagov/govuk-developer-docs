---
owner_slack: '#govuk-frontenders'
title: The component system
section: Frontend
type: learn
layout: manual_layout
parent: "/manual.html"
---

Components are packages of template, style, behaviour and documentation. Components live in your application unless needed by multiple applications, then they are shared using the [govuk_publishing_components gem](https://github.com/alphagov/govuk_publishing_components).

## Component guides

Components in applications are documented in component guides using the [govuk_publishing_components gem](https://github.com/alphagov/govuk_publishing_components). It mounts a component guide at the path `/component-guide`.

Find components in these guides:

* [govuk_publishing_components component guide](https://components.publishing.service.gov.uk/component-guide)
* [government-frontend component guide](https://govuk-government-frontend.herokuapp.com/component-guide)
* [collections component guide](https://govuk-collections.herokuapp.com/component-guide/)
* [finder-frontend component guide](https://govuk-finder-frontend.herokuapp.com/component-guide)
* [frontend component guide](https://govuk-frontend.herokuapp.com/component-guide)

## Building components

A component must:

* [meet the component principles](https://github.com/alphagov/govuk_publishing_components/blob/master/docs/component_principles.md)
* [follow component conventions](https://github.com/alphagov/govuk_publishing_components/blob/master/docs/component_conventions.md)

The [govuk_publishing_components gem](https://github.com/alphagov/govuk_publishing_components) provides a generator to stub the files you’ll need in each component:

```
bundle exec rails generate govuk_publishing_components:component [component_name]
```

For example, a lead paragraph component would be included in a template like this:

```erb
<%= render 'components/lead-paragraph', text: "A description is one or two leading sentences" %>
```
