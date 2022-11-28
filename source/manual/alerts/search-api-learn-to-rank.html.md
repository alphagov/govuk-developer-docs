---
owner_slack: "#govuk-2ndline-tech"
title: Train and deploy LTR model for Search API
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

[Search API](/repos/search-api.html) uses a machine learning tool called Learn to Rank (LTR) to improve search result relevance. This uses the TensorFlow Ranking module.

On occassion the current ranking becomes out of date and the tool needs to be re-trained. There are [several rake tasks](/repos/search-api/learning-to-rank.html) to accomplish this.
