---
owner_slack: "#govuk-developers"
title: Rate Limiting
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

Rate limiting on GOV.UK is largely handled at the infrastructure level, with one exception at the app level for finer control.

## Infrastructure

At the infrastructure level, the nginx instances on the cache machines have a rate limit of 6 rpm / IP address in a GET/POST pair (ie one that returns a form on a GET, and submits that form with a POST)

Note that the free nginx instances used on GOV.UK cannot share state, so this rate limit is actually much higher, theoretically 6 * the number of caches for a set of fast requests spread around the caches perfectly by the load balancer.

## App-level rate limits on Feedback

The feedback app has in-app rate limiting provided by the Rack::Attack gem and uses an elasticache instance to share state between the various instances of the app, which allows much closer control. This is to control the contact us form, which needs a much lower rate limit. Currently this is set to 1 rpm / IP *or* 1 rpm / email address if the user enters an email address to respond to.

## Further reading

* Tech Fortnightly Presentation [Rate Limiting in the Feedback App](https://beisgov.sharepoint.com/:p:/r/sites/GOVUKTechnologyCommunity-TechnologyCommunity/Shared%20Documents/Tech%20Fortnightly%20Talks/Tech%20fortnightly%20talk%20-%20Rate%20Limiting%20in%20the%20Feedback%20App.pptx?d=w2f8aa8eccba549ae8631ac9a3a027b55&csf=1&web=1&e=x0rWIP) (GDS only)
