---
owner_slack: "#govuk-2ndline"
title: Can't connect to Elasticsearch in VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-26
review_in: 6 months
---

If you're seeing errors similar to `java.lang.IllegalStateException: Could not load plugin descriptor for existing plugin [cloud-aws]. Was the plugin built before 2.0?` in the Elasticsearch log files then you should run the `[fix-elasticsearch-2.4.sh][fix-elasticsearch-script]` script

```shell
$ /var/govuk/govuk-puppet/development-vm/fix-elasticsearch-2.4.sh
```

[fix-elasticsearch-script]: https://github.com/alphagov/govuk-puppet/blob/master/development-vm/fix-elasticsearch-2.4.sh
