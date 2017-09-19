---
owner_slack: "#2ndline"
title: Use GOV.UK data in a project
section: Basics
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-08-19
review_in: 6 months
related_applications: [rummager, content-store]
---

If you're looking for a way to use the GOV.UK data, for experimentation or analysis, there are a couple of ways of doing that.

## Publishing API

The [publishing-api `/editions` endpoint][pub-api] will allow you to page through all editions (versions) of the content. May be useful for discovering publishing patterns.

[pub-api]: https://docs.publishing.service.gov.uk/apis/publishing-api/api.html#get-v2editions

## Search API

Rummager (our search API) contains most data. It's accessible publicly. For an overview and usage, see [the blog post Tara wrote in 2016][blog]. You can also [read the API documentation][search-docs].

[blog]: https://gdsdata.blog.gov.uk/2016/05/26/use-the-search-api-to-get-useful-information-about-gov-uk-content/
[search-docs]: https://docs.publishing.service.gov.uk/apis/search/search-api.html

## Content store

The content-store contains all the current content of GOV.UK. See [the content-store API docs][cs-docs].

[cs-docs]: http://localhost:4567/apis/content-store.html

## Mirror

If you want to crawl GOV.UK you can, but you will have to respect our rate limits (the server will return `429` if you make too many requests). An alternative is to use a copy of the mirror.

```
ssh mirrorer-1.management.integration
cd /mnt/crawler_worker/www.gov.uk
tar -zcvf ~/all-of-govuk.tar.gz .
```

You might want to use `screen`, because this will take a while.
