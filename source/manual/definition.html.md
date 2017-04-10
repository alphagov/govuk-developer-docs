---
title: Definition of Incident
section: incidentreports
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/incidentreports/definition.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/incidentreports/definition.md)


# Definition of Incident

> **note**
>
> This is a working definition - please feel free to update it!

ISO 20000 defines an incident ([section 1, part
3.10](https://www.iso.org/obp/ui/#iso:std:iso-iec:20000:-1:ed-2:v1:en))
as:

> **unplanned interruption to a service, a reduction in the quality of a
> service or an event that has not yet impacted the service to the
> customer**.

We are required to report incidents (of both a technical and a security
nature) per the [HMG Security Policy
Framework](https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/255910/HMG_Security_Policy_Framework_V11.0.pdf).
Aside from this, we are often asked to provide incident reports for
internal use or to meet the needs of certain stakeholders.

## Useful Links

-   [Incident Severity
    Levels](https://gov-uk.atlassian.net/wiki/display/PLOPS/Incident+severity+levels)
-   [Appication Health
    Dashboard](https://grafana.publishing.service.gov.uk/dashboard/file/application_health.json)
-   [Edge Health
    Dashboard](https://grafana.publishing.service.gov.uk/dashboard/file/edge_health.json)
-   [Origin Health
    Dashboard](https://grafana.publishing.service.gov.uk/dashboard/file/origin_health.json)

## Interruption

An interruption may be defined as:

> -   part of the site being unavailable for 15 minutes or longer. The
>     unavailability does not have to affect users.
> -   service provided by GOV.UK being unavailable for 15 minutes
>     or longer.
> -   an event that affects more than 1000 users.

There are some legal obligations that departments must meet, and any
event that causes an obstruction to this, even if it doesn't meet the
other criteria, counts as an incident (for an example, see the incident
report from [19th November
2012](https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/122k4x7vYqc_3LRnkxdARENjguHhRwhBVtjgzpS9hJTM).)

## Degradation

Degradation of service may mean one, or both, of the following:

> -   any event where HTTP 5xx status codes (server errors) are over
>     15%. [This
>     graph](https://graphite.publishing.service.gov.uk/render?width=624&from=-24hours&until=-&height=450&fontBold=true&yMin=0&target=alias%28movingAverage%28asPercent%28divideSeries%28stats.cache-1_router.nginx_logs.www-origin.http_5xx%2Csum%28stats.cache-1_router.nginx_logs.www-origin.http_*xx%29%29%2C1%29%2C%2012%29%2C%22cache-1%22%29&target=alias%28movingAverage%28asPercent%28divideSeries%28stats.cache-2_router.nginx_logs.www-origin.http_5xx%2Csum%28stats.cache-2_router.nginx_logs.www-origin.http_*xx%29%29%2C1%29%2C12%29%2C%22cache-2%22%29&target=alias%28movingAverage%28asPercent%28divideSeries%28stats.cache-3_router.nginx_logs.www-origin.http_5xx%2Csum%28stats.cache-3_router.nginx_logs.www-origin.http_*xx%29%29%2C1%29%2C12%29%2C%22cache-3%22%29&target=alias%28dashed%28drawAsInfinite%28removeBelowValue%28sum%28stats.govuk.app.*.all.deploys%29%2C0.00001%29%29%29%2C%22all%20deploys%22%29&title=HTTP_error_percentage&fontSize=14&lineWidth=1.5&xFormat=%25H%3A%25M&yMax=&_uniq=0.511430696118623)
>     may be useful.
> -   any event where average response times are more than a second for
>     five minutes.

## Security incident

In addition, security incidents require incident reports. A security
incident is any situation where one or more of the following has taken
place:

> -   an attacker has gained or attempted to gain unauthorised access to
>     one of our environments.
> -   a clear and actionable vulnerability is identified in one of our
>     environments or a piece of software.
> -   protectively-marked data has accidentally been made public, for
>     example early publishing of budget data.
> -   there has been exposure of user data.

At GDS, we consider a DDoS attack (regardless of whether such an attack
was successful or not) to be a security incident.

