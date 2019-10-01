---
owner_slack: "#govuk-2ndline"
title: Prolonged GC collection times
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-09-28
review_in: 6 months
---

This checks when the Elasticsearch JVM garbage collection times (in
milliseconds) exceeds critical or warning levels. This is collected by graphite
via collectd from the Elasticsearch API.

Currently the check uses graphite function to summarise over a time period of 5
minutes and find the maximum value in that period.

You can find the current value using curl if you create a tunnel to
Elasticsearch then use curl to query the stats API:

```sh
$ ssh -At jumpbox.production.govuk.digital -L 9200:localhost:9200 "ssh -q \`govuk_node_list --single-node -c search\` -L 9200:elasticsearch5.blue.production.govuk-internal.digital:80"
```

```sh
$ curl localhost:9200/_nodes/stats/jvm?pretty
```

You need to look for the `collection_time_in_millis`. There will be two values:
`old` and `young`. Both are checked by Nagios and correspond to different
portions of the JVM heap. The lower these times are, the better. Another
important value is `heap_used_percent`, again this should be low. If it gets
too high it may prevent garbage collection completing.

### Solutions

GOV.UK has a support contract with AWS for the managed Elasticsearch service.
See ['Fixing issues with the cluster'][fixing-issues-with-cluster] for further
information.

[fixing-issues-with-cluster]: /manual/alerts/elasticsearch-cluster-health.html#fixing-issues-with-the-cluster
