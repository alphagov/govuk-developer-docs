---
owner_slack: '#taxonomy'
title: Use the side-by-side browser
section: Transition
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-07-14
review_in: 6 months
---

The side-by-side browser is a tool to preview redirections for sites that are
being transitioned to GOV.UK.

- [Github repo](https://github.com/alphagov/side-by-side-browser)
- [View the side-by-side browser](http://www.apho.org.uk.side-by-side.alphagov.co.uk/__/#/)

## Deploying the side-by-side browser on AWS

[Instructions on the Wiki](https://gov-uk.atlassian.net/wiki/display/GOVUK/Bouncer+and+Transition) under 'Deploying the side-by-side browser on AWS'.

## Update the app

```
$ ssh side-by-side
$ cd /data/side-by-side-browser
```

There’s an `etc/hosts.json` file in the repo, but it’s periodically updated, so for now:

```
$ sudo git stash
$ sudo git pull
$ sudo git stash pop
```

Restart the service:

```
$ sudo /etc/init.d/side-by-side restart
```

Note the command `service` doesn't seem to work with the forever script.

Follow the logs, which are a bit too verbose:

```
$ tail -f /var/log/side-by-side
```

There’s a root cron job to check and fetch the `hosts.json` file every 15 minutes:

```
0,15,30,45 * * * * cd /data/side-by-side-browser/etc && curl -s -o temp-hosts.json https://transition.publishing.service.gov.uk/hosts.json && mv temp-hosts.json hosts.json >> /var/log/side-by-side-curl 2>&1
```
