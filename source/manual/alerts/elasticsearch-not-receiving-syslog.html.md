---
title: 'Elasticsearch: not receiving syslog from logstash'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# Elasticsearch: not receiving syslog from logstash

The problem behind this warning is that logstash has stopped sending
things. Restart logstash on logging-1.management with:

```
fab <environment> -H logging-1.management app.restart:logstash
```
