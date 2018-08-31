---
owner_slack: "#govuk-2ndline"
title: es-rotate
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

This alert triggers when the [es-rotate](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/templates/usr/local/bin/es-rotate-passive-check.erb)
hasn't completed successfully.

es-rotate is part of [es-tools](https://github.com/alphagov/estools).

Its job is to rotate the Elasticsearch alias for the current day's logs,
and to delete old indexes.

If it doesn't run, it's fine to rerun manually on the affected host,
using:

    sudo -u nobody /usr/local/bin/es-rotate-passive-check

If there is a problem you can find out more information by checking the
[Elasticsearch cluster health](/manual/alerts/elasticsearch-cluster-health.html).
