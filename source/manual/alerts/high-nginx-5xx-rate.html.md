---
owner_slack: "#govuk-2ndline-tech"
title: High Nginx 5xx rate
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

You can view the 5xx logs across all machines on this dashboard:

- [Nginx 5xx Requests (AWS)][nginx-5xx-grafana-aws]

Change the hostname to view different apps.

## Spikes

The alert should link to a graphite graph - often certain applications
such as Whitehall can have spikes - if you can determine this is a spike
it is best to acknowledge the alert and let a team that is working on the app
know (or alert Platform Security and Reliability).

## Multiple applications reporting errors

If multiple applications are reporting 5xx errors, there is likely to be a common
cause. The first thing to check is whether [content store is erroring][content-store dashboard].
If content-store is not reporting any errors, but the dependent frontend apps are
(see the bottom of the dashboard), it could be that the [ARP cache needs to be flushed][arp cache flushing].

## Scaling up

Sometimes a high 5xx rate can be because of a sudden increase in traffic to the
site. You can use the [Nginx Requests (AWS)][nginx-requests] dashboard to see
if there are an unusually high number of requests to a particular machine
class. If there are, you may want to consider
[scaling up the number of machines available][scaling-up] to handle the requests.

[nginx-5xx-grafana-aws]: https://grafana.blue.production.govuk.digital/dashboard/file/nginx_requests.json?refresh=1m&orgId=1&var-Machines=All&var-Hostname=All&var-Status=5xx
[nginx-requests]: https://grafana.production.govuk.digital/dashboard/file/nginx_requests.json?refresh=1m&orgId=1&from=now-30m&to=now
[scaling-up]: /manual/auto-scaling-groups.html#manually-scaling
[content-store dashboard]: https://grafana.production.govuk.digital/dashboard/file/content-store.json?refresh=5s&orgId=1&from=now-6h&to=now
[arp cache flushing]: /manual/flush-the-arp-cache.html
