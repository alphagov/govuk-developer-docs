---
owner_slack: "#govuk-2ndline"
title: Replay traffic to correct an out-of-sync search index
parent: "/manual.html"
layout: manual_layout
section: Backups
last_reviewed_on: 2019-04-17
review_in: 3 months
---

If the data in the search index is out-of-sync with the Publishing API,
(for example, after [restoring a backup][restore-backups]), then any `publish`
and `unpublish` messages that have not been processed need to be resent.

## `govuk` index

Content in the `govuk` index is populated from the [Publishing API message queue][queue].
Missing documents can be recovered by resending the content to the message queue. In the
Publishing API, run the following rake task (including the quotes) to replay traffic between
two datestamps:

    bundle exec rake 'represent_downstream:published_between[2018-12-17T01:02:30, 2018-12-18T10:20:30]'

[Other replay options are available](https://github.com/alphagov/publishing-api/blob/master/lib/tasks/represent_downstream.rake), for example replaying all traffic for a single publishing app or doctype.
Be aware that these options will replay the entire Publisher API history for that app or doctype, and may take some time.

## `government`/`detailed` indexes

**This will not be neccessary after whitehall content has been moved to the
`govuk` index.**

These indexes are populated by whitehall calling an HTTP API in Search API.
Missing documents can be recovered by resending the content to Search API directly. In
Whitehall, run the following rake task (including the quotes) to replay traffic between
two datestamps:

    bundle exec rake 'rummager:index:published_between[2018-12-17T01:02:30, 2018-12-18T10:20:30]'

Another option is [Gor][gor], which logs  `POST` and `GET` requests to Search API.
The logs are stored on the Search API servers. You will need to run the replay on
each server.

The location of the logs is:

```
/var/log/gor_dump
```

You must copy the file for the restore, as the restore requests
will be logged to the file.

The following command can be used to run the restore:

```bash
$ sudo goreplay -input-file "20171031.log|1000%" -stats -output-http-stats -output-http "http://localhost:3233/|6000%" -verbose
```

This runs the restore at 10x the speed it was saved so each hour of logs takes
6 minutes to process.

[restore-backups]: https://docs.publishing.service.gov.uk/manual/elasticsearch-dumps.html
[queue]: https://github.com/alphagov/search-api/blob/master/doc/new-indexing-process.md
[gor]: https://github.com/buger/goreplay
