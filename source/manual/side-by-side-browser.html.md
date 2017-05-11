---
owner_slack: '#navigation'
title: Side by Side Browser
section: Transition
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual:  "https://github.digital.cabinet-office.gov.uk/pages/gds/opsmanual/infrastructure/side-by-side.html"
last_reviewed_on: 2017-05-03
review_in: 6 months
---

The side-by-side browser is a tool to preview redirections for sites that are
being transitioned to GOV.UK.

[Github README]([https://github.com/alphagov/side-by-side-browser](https://github.com/alphagov/side-by-side-browser))

[View the Side by Side Browser](http://www.apho.org.uk.side-by-side.alphagov.co.uk/__/#/)

## Deploying the side-by-side browser on AWS

[Instructions on the Wiki](https://gov-uk.atlassian.net/wiki/display/GOVUK/Bouncer+and+Transition) under 'Deploying the side-by-side browser on AWS'.

## Update the app

```
$ ssh side-by-side
$ cd /data/side-by-side-browser
```

There’s an etc/hosts.json file in the repo, but it’s periodically updated, so for now:

```
$ sudo git stash
$ sudo git pull
$ sudo git stash pop
```

Restart the service:

```
$ sudo /etc/init.d/side-by-side restart
```

note, the command “service” doesn’t seem to work with the forever script :-(

Follow the logs, which are a bit too verbose:

```
$ tail -f /var/log/side-by-side
```

There’s a root cron job to check and fetch the hosts.json file every 15 minutes:

```
0,15,30,45 * * * * cd /data/side-by-side-browser/etc && curl -s -o temp-hosts.json https://transition.publishing.service.gov.uk/hosts.json && mv temp-hosts.json hosts.json >> /var/log/side-by-side-curl 2>&1
```
