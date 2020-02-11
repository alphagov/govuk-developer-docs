---
owner_slack: "#govuk-dev-tools"
title: Can't connect to Mongo in VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-10-17
review_in: 6 months
---

This is probably happening because your VM didn't shut down cleanly.
You should be running `vagrant halt` or `vagrant suspend` but if you had to
kill your VM or restart your machine MongoDB won't be able to connect. You can
fix this by deleting your `mongod.lock` and restarting MongoDB.

```shell
$ sudo rm /var/lib/mongodb/mongod.lock
$ sudo service mongodb start
```
