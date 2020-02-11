---
owner_slack: "#govuk-dev-tools"
title: Content store times out in VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-22
review_in: 12 months
related_applications:
  - content-store
---

If requests to your development VM are timing out and requests to the content
store throw an error message along the lines of "Timed out attempting to dequeue
connection after 1 sec." then you should check that your mongo database (where
the data for the content-store is held) has the correct indexes.

You can run the following commands from your VM to check:

```
$ mongo
MongoDB shell version: 2.4.9
connecting to: test
development:PRIMARY> use content_store_development
switched to db content_store_development
development:PRIMARY> db.content_items.getIndexes()
[
  {
    "v" : 1,
    "key" : {
      "_id" : 1
    },
    "ns" : "content_store_development.content_items",
    "name" : "_id_"
  }
]
```

If you only see the `_id_` index as in the above example you need to run another
command to create the indexes for all models stored in mongo:

```
$ cd /var/govuk/content-store
$ rake db:mongoid:create_indexes
```

This command will take a minute or two to complete.

Your indexes for the content_items collection should then look more like this:

```
[
  {
    "v" : 1,
    "key" : {
      "_id" : 1
    },
    "ns" : "content_store_development.content_items",
    "name" : "_id_"
  },
  {
    "v" : 1,
    "key" : {
      "routes.path" : 1,
      "routes.type" : 1
    },
    "ns" : "content_store_development.content_items",
    "name" : "routes.path_1_routes.type_1"
  },
  {
    "v" : 1,
    "key" : {
      "redirects.path" : 1,
      "redirects.type" : 1
    },
    "ns" : "content_store_development.content_items",
    "name" : "redirects.path_1_redirects.type_1"
  }
]
```
