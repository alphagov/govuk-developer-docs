---
owner_slack: "#govuk-2ndline"
title: Nginx requests too low
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

We monitor the number of requests reaching our Nginx servers. We expect that
there will be a minimum number of requests occurring and a check will alert if
this falls below a threshold.

[View the Nginx logs in Kibana][nginx_logs] or view the impacted application dashboard on
Grafana.

There are a few things to check when this occurs:

- On Staging and Integration, this alert may appear while production
  data is being copied to the environment. This is because production
  traffic replay is paused during the copying job.
- It could be a genuine low number of requests. The threshold is
  configurable in hieradata so we can tweak for environments where we
  expect to see lower traffic levels.
- It could be indicative of a bigger problem. A previous cause for this has
  been misconfigured firewall configs on our vSE load balancer.

[nginx_logs]: https://docs.publishing.service.gov.uk/manual/kibana.html#nginx-logs
