---
owner_slack: "#2ndline"
title: 'Elasticsearch: not receiving Syslog from Logstash'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-11-22
review_in: 6 months
---

The problem behind this warning is that Logstash has stopped sending
things. Restart Logstash on logging-1.management with:

```
fab <environment> -H logging-1.management app.restart:logstash
```
