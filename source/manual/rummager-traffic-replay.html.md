---
owner_slack: "#search-team"
title: 'Replay search indexing traffic after restoring a backup'
parent: "/manual.html"
layout: manual_layout
section: Backups
last_reviewed_on: 2017-09-05
review_in: 3 months
---

If the index should fail and we need to [restore from backup](https://docs.publishing.service.gov.uk/manual/elasticsearch-dumps.html) we can then replay this traffic rather than trying to resend from the source applications.

We are using [GOR](https://github.com/buger/goreplay) to store POST and DELETED requests made to the rummager servers.

Data for each of the rummager machine is stored locally on the machine at:

```
/var/log/gor_dumps
```

Traffic will needs to be replayed from each server using the command:

```
sudo GODEBUG="netdns=go" /usr/local/bin/gor --input-file "/var/log/gor_dump/*.log|1000%" --output-http http://localhost:3009 --output-http-timeout 30s
```

You can run the command with debug logging to get a better idea of progress using the below command:

```
sudo GODEBUG="netdns=go" /usr/local/bin/gor --input-file "/var/log/gor_dump/*.log|1000%" --output-http http://localhost:3009 --output-http-timeout 30s --verbose --debug
```

The above command replays the traffic at 10 times (1000%) the speed is was captured, this can be adjusted by changing the percentage value in the command.
