---
owner_slack: "#2ndline"
title: Monitoring screens
parent: "/manual.html"
layout: manual_layout
section: Tools
last_reviewed_on: 2017-03-14
review_in: 6 months
---

Most teams in GOV.UK have screens set up to show data about pull requests and
releases.

Most often displayed are the [deploy lag radiator][deploy-lag] and the [fourth wall](https://github.com/alphagov/fourth-wall).

## Search screen

![Screen shot of the search screen](images/search-screen.png)

The [search screen][search-screen] displays live data from GOV.UK. Includes number of people on GOV.UK, latest searches, trending and recent content. It's not publicly accessible because there's sometimes personal data in the latest searches.

It runs on a TV on the 6th floor of Aviation House.

[search-screen]: https://github.com/alphagov/govuk-display-screen

## 2nd line screen

![Photo of the 2nd line monitoring screen](images/monitoring.jpg)

There is a screen by the 2ndline desks. [Credentials on the Wiki][wiki].

The screen is a webpage running [David Singleton's Frame Splits][splits] with 4 splits:
production health, icinga alert summary per environment, upcoming
releases, deployment status of puppet.

[wiki]: https://gov-uk.atlassian.net/wiki/display/PLOPS/2nd+line+tv+screen

### Production health

This screen contains [a dashboard giving an overview of health for the
platform](https://grafana.publishing.service.gov.uk/#/dashboard/file/2ndline_health.json),
a list of upcoming releases, and a dashboard showing the alerts for each
environment

This dashboard contains 2 graphs, one of origin 4xx and 5xx, and one of
edge 4xx and 5xx. It's worth keeping an eye on this and looking for any
anomalies, as this may indicate issues on production. It's likely due to
our caching behaviour that the top graph of origin errors will indicate
issues before they are visible in the 2nd graph, and to end users.

### Troubleshooting

Sometimes the 'EDGE' graphs may disappear. These are obtained by the
[collectd-cdn plugin](https://github.com/gds-operations/collectd-cdn) on
`monitoring-1.management.production`. If the graphs disappear, they
should write errors to `/var/log/syslog`. They may look something like
this:

```sh
Nov 10 11:37:17 monitoring-1.management collectd[32764]: cdn_fastly plugin: Failed to query service: govuk

Nov 10 11:37:17 monitoring-1.management collectd[32764]: cdn_fastly plugin: Failed to query service: tldredirect

Nov 10 11:37:17 monitoring-1.management collectd[32764]: cdn_fastly plugin: Failed to query service: assets

Nov 10 11:37:17 monitoring-1.management collectd[32764]: cdn_fastly plugin: Failed to query service: redirector
```

If this happens, restarting collectd on the monitoring server may kick
things into life.

```
sudo service collectd restart
```

### Icinga alert summary per environment

This screen shows a summary of the critical and warning alerts for our
three environments (production, staging, integration) in a colour coded
box (red for criticals, yellow for warnings, green for all ok).

This is powered by [blinken](https://github.com/alphagov/blinken), an
instance of which is running on the localhost on port 8080. This is run with `~/blinken/run.sh`.

### Upcoming Releases

This shows the list of upcoming releases.

This is powered by the [departure-lounge][departure-lounge] application, which
reads from the release calendar.

[departure-lounge]: https://github.com/issyl0/departure-lounge

### Deployment status of puppet

This shows the difference between the commits on master and the commits
on the release tag for puppet. Letting us know if lots of Puppet stuff
hasn't been deployed.

This is powered by [David Singleton's deploy-lag radiator][deploy-lag] and is
configured to look at the release tag on the Puppet repo.

[deploy-lag]: https://github.com/dsingleton/deploy-lag-radiator
[splits]: https://github.com/dsingleton/frame-splits
