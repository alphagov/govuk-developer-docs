---
owner_slack: "#govuk-platform-health"
title: 'Analytics on GOV.UK'
section: Analytics
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-18
review_in: 6 months
related_applications: [govuk_frontend_toolkit static frontend government-frontend]
---

GOV.UK uses Google Analytics to track user journeys through the site. The tracking data is available to anyone with Google Analytics Suite access for GOV.UK. You can request access to this from the analytics team.


## GOV.UK analytics code

The GOV.UK analytics codebase is a collection of JavaScript modules spread through a few different projects:

- [govuk_frontend_toolkit](https://github.com/alphagov/govuk_frontend_toolkit/tree/master/javascripts/govuk/analytics) - Core analytics code, this project is distributed as a gem (see [govuk_frontend_toolkit_gem](https://github.com/alphagov/govuk_frontend_toolkit_gem)).
- [static](https://github.com/alphagov/static/tree/master/app/assets/javascripts/analytics) - Additional and legacy modules.
- [government-frontend](https://github.com/alphagov/government-frontend/blob/master/app/assets/javascripts/modules/track-radio-group.js), [frontend](https://github.com/alphagov/frontend/tree/master/app/assets/javascripts/modules) - Supplementary tracking for application specific cases.


## Tracking overview

User behaviours and journeys can be tracked in a variety of ways, the default method of tracking with Google Analytics is to record _pageviews_ - This is data relating to a page the user has just requested (eg. URL, user-agent, referrer).  
Pageviews are typically recorded as the user visits the page.

Where a page offers the user multiple navigation choices it's often desirable to track _events_, a typical example of this is recoding when a user chooses an option in a group of radio buttons. Event data is usually comprised of a category, a label and a value.

Both pageviews and events can be augmented with _custom dimensions_, additional fragments of data describing the behaviour of the user, eg. which variant of an multivariate test they are assigned.


## Cross domain tracking

Users often come to GOV.UK en route to another service, and there's no combined governmental analytics overview.  
Different departments tend to use their own _GA Property_ (ie. the _UA-xxxxxx-x_ identifier) for their analytics data.

Tracking a user journey across different services with different domains requires additional configuration so that the destination domain (eg. tax.service.gov.uk) can receive analytics data for the portion of the user journey taking place on the source domain (eg. GOV.UK).  
To some extent the referrer value in pageview data will contain some evidence of where the user has arrived from, often this isn't enough information or may be misleading due to authentication redirects.

It's possible to configure GOV.UK analytics to perform cross domain event and pageview tracking, this will send events and pageviews to a different GA property, typically the destination domain belonging to another department.

The javascript function

```javascript
GOVUK.analytics.addLinkedTrackerDomain('UA-43888888-1', 'someServiceTracker', 'some.service.gov.uk')
```

registers a _linked_ (cross domain) tracker and sends a pageview to the tracker.

A common example usage of the above function is transaction start pages, the start button contains the data attributes

```html
<a href="https://some.service.gov.uk"
   data-module="cross-domain-tracking"
   data-tracking-code="UA-43888888-1"
   data-tracking-name="someServiceTracker">Start</a>
```

### Cross domain event tracking

Once the linked tracker is registered, it's also possible to track events using the registered tracker name:

```javascript
GOVUK.analytics.trackEvent('Radio button chosen', 'selected-service-option', { 'trackerName': 'someServiceTracker' })
```


### Cross domain tracking and GOV.UK javascript module loading

The `GOVUK.Modules` library will attempt to initialise and start a module for every `data-module` data attribute it encounters.  
In the case of cross domain tracking this can be undesirable if more than one element contains the `cross-domain-tracking` data-module because the underlying `ga.js` library from Google will not accept multiple calls to register a linked tracker and will throw javascript errors.  
See https://github.com/alphagov/static/commit/c03c11a84f86deb83ed3b7a4d16ad2e6de3f1d95 for how we mitigate against this for multiple govspeak buttons with cross domain tracking enabled.


## Developing and debugging Google Analytics tracking

Google provide an extension [Google Analytics Debugger](https://chrome.google.com/webstore/detail/google-analytics-debugger/jnkmfdileelhofjcijamephohjechhna?hl=en) which logs all GA suite interactions to the console.  
This is useful for testing what is being sent to GA and when.

![Google Analytics Debugger console output](images/google-analytics-debugger-output.png)
