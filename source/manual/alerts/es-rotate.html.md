---
owner_slack: "#2ndline"
title: es-rotate
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-01-05
review_in: 6 months
---

This alert triggers when the es-rotate hasn't completed successfully.

es-rotate is part of [es-tools](https://github.com/alphagov/estools).

Its job is to rotate the elasticsearch alias for the current day's logs,
and to delete old indexes.

If it doesn't run, it's fine to rerun manually on the affected host,
using:

    sudo -u nobody /usr/local/bin/es-rotate-passive-check

If there is a problem you can find out more information using the
elasticsearch-head plugin (see "Elasticsearch cluster health" alert for
more details).

