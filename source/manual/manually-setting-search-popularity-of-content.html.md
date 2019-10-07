---
owner_slack: "#govuk-developers"
title: Manually setting the search popularity of content
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-03-26
review_in: 6 months
---

To look up the popularity of an item you can query Elasticsearch by creating a
tunnel to the cluster:

```
ssh -At jumpbox.production.govuk.digital -L 9200:localhost:9200 "ssh -q \`govuk_node_list --single-node -c search\` -L 9200:elasticsearch6.blue.production.govuk-internal.digital:80"
```

To looking up popularity of a particular item you will need its `base_path` URL
encoded and then look it up with a `curl` command:

```shell
$ curl localhost:9200/government/generic-document/%2Fgovernment%2Fpublications%2Fdraft-capital-requirements-amendment-eu-exit-regulations-2018?stored_fields=popularity
```

Once popularity is determined we can then update with the new popularity using
the following command:

```shell
$ curl -XPOST
localhost:9200/government/generic-document/%2Fgovernment%2Fpublications%2Fdraft-capital-requirements-amendment-eu-exit-regulations-2018/_update
-d '{"doc": {"popularity": 10}}'
```
