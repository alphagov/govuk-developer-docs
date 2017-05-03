---
owner_slack: "#2ndline"
title: 'Elasticsearch: not receiving syslog from logstash'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2016-11-08
review_in: 6 months
---

# Elasticsearch: not receiving syslog from logstash

The problem behind this warning is that logstash has stopped sending
things. Restart logstash on logging-1.management with:

```
fab <environment> -H logging-1.management app.restart:logstash
```
