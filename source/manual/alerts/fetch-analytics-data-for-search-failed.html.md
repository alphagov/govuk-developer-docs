---
owner_slack: "#govuk-2ndline-tech"
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
it to run the next day. If you see in the Jenkins job output:

```sh
$ jenkins.util.io.CompositeIOException: Unable to delete '/var/lib/jenkins/workspace/search-api-fetch-analytics-data'.
```

The job runs a Docker container which uses `root`, and if it fails the
files don't get cleaned up properly. You can check by running the following
command on the machine:

```sh
$ sudo su - jenkins
$ ls -al /var/lib/jenkins/workspace/search-api-fetch-analytics-data
```

```sh
total 20
drwxr-xr-x  5 jenkins jenkins 4096 Dec 31 21:17 .
drwxr-xr-x 78 jenkins jenkins 4096 Feb 15 14:18 ..
drwxr-xr-x  4 jenkins jenkins 4096 Dec 31 21:17 analytics_fetcher
drwxr-xr-x  2 root    root    4096 Dec 23 04:10 cache
drwxr-xr-x  3 jenkins jenkins 4096 Dec 31 21:17 gapy
```

They can be removed by running:

```sh
$ sudo rm -r /var/lib/jenkins/workspace/search-api-fetch-analytics-data
```

The job should hopefully run successfully overnight.

If the job fails or gets stuck in part 2, the search indices may still
be locked.  If that's the case, documents will be missing from search.
First unlock the indices:

```bash
bundle exec rake search:unlock SEARCH_INDEX=all
```

Then see the ["fix out-of-date search indices"](/manual/fix-out-of-date-search-indices.html)
docs.

If the job is failing often, make sure the [team currently responsible for search](/repos/search-analytics.html)
are aware of the problem.
