---
owner_slack: "#govuk-data-labs"
title: Use GOV.UK Knowledge Graph
section: Data Labs Team Manual
layout: manual_layout
parent: "/manual.html"
---

The [GOV.UK Knowledge Graph](https://github.com/alphagov/govuk-knowledge-graph), also known as govGraph, is a knowledge graph tool that allows us to:

- explore graph databases and knowledge graphs for GOV.UK applications
- collaborate with other teams and communities to help them find content more easily
- build products and apps that allow further insights about our content such as the journey visualisation app
- upskill colleagues and drive culture change to make better use of data and improve data literacy in GOV.UK
- provide early adopters with access and training to help scale use of our data apps and product

One of the most common uses is that GOV.UK Knowledge Graph provides a queryable platform for content designers to answer common content questions.

There are two versions of the graph:

- a [stable graph](https://knowledge-graph.integration.govuk.digital:7473/browser/) for content designers to query
- an [experimental graph](https://knowledge-graph-lab.integration.govuk.digital:7473/browser/) for the Data Labs team which includes extra NLP derived features

The graph connects siloed data from analytics (the functional network) to content data metadata such as the title, body, or which organisations publish content. We also use graph algorithms to derive new features, such as the popularity of content with the weighted PageRank algorithm.

Complete this [introduction lesson](https://docs.google.com/document/d/1R8vati8E5aPJk_p0RYxu2yw2gJK_y6ikvi5VReV4YVs/edit) to understand more about how GOV.UK Knowledge Graph works.

For more information, see the following:

- this [blog post on Knowledge Graph](https://insidegovuk.blog.gov.uk/2020/08/07/one-graph-to-rule-them-all/)
- the [GOV.UK developer documentation Knowledge Graph page](https://docs.publishing.service.gov.uk/manual/knowledge-graph.html)
- [example queries](https://github.com/alphagov/govuk-knowledge-graph/tree/master/src/neo4j/favourite_queries) in the repo
- [example requests](https://drive.google.com/drive/u/0/folders/1uh7tKgHDkQF12pXS9-q7rUa2pHq8fGdo) from content designers

If you have questions, you can contact:

- the [GOV.UK Data Labs team on Slack](https://gds.slack.com/archives/CHR4UQKU4)
- [Esther Woods](mailto:esther.woods@digital.cabinet-office.gov.uk) in the content community
