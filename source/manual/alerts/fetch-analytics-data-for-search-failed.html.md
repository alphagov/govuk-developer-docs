---
owner_slack: "#govuk-2ndline"
title: Fetch analytics data for search failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This checks the latest build state of [a job in production
Jenkins](https://deploy.blue.production.govuk.digital/job/search-api-fetch-analytics-data/)
which runs every night and updates all documents in the search index with pageview data from
Google Analytics.

The only downside of this not running is that the popularity data is slightly
out of date.  This job should not be run in working hours.

This job has two parts:

1. Page view data is fetched from Google Analytics.  This process
   seems to sometimes hang, resulting in stuck jobs.
2. The search index is locked and popularity score of every page is
   updated.

If the job fails or gets stuck in part 1, you can cancel it and leave
it to run the next day.

If the job fails or gets stuck in part 2, the search indices may still
be locked.  If that's the case, documents will be missing from search.
First unlock the indices:

```bash
bundle exec rake search:unlock SEARCH_INDEX=all
```

Then see the ["fix out-of-date search indices"](/manual/fix-out-of-date-search-indices.html)
docs.

If the job is failing often, make sure the team currently responsible for search
are aware of the problem (or Platform Health).
