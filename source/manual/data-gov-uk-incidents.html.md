---
owner_slack: "#datagovuk-tech"
title: Incidents for data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-30
review_in: 3 months
---

[static-page]: /manual/data-gov-uk-common-tasks.html#put-up-a-static-error-page
[paas-support]: https://www.cloud.service.gov.uk/support

## Data loss

If data is lost in the various services, here’s what can be done:

**Postgres**

Restore the data from the [PaaS nightly backups](https://docs.cloud.service.gov.uk/#restoring-a-postgresql-service-snapshot) or contact [PaaS Support](https://docs.cloud.service.gov.uk/#postgresql-service-backup).

**Elasticsearch**

Contact [PaaS Support][paas-support]. Alternatively, while Legacy is still used the Elasticsearch index can be repopulated from the [legacy CKAN nightly dumps](/manual/data-gov-uk-common-tasks.html#import-data-from-legacy).

## The application breaks

If data.gov.uk doesn't respond or shows an error page, check if the error page is a 500 page with DGU styling or a bare nginx error page.

**It's an application 500 page**

If Legacy is still around, switch back to Legacy while you fix the problem.  This is done by ssh’ing on prod3, editing `/etc/nginx/sites-enabled/nginx.conf` and removing all the lines that point specific URLs to `find-data-beta.cloudapps.digital`. If Legacy is gone, there’s nothing you need to do before fixing the issue.

**It's a nginx 500 page**

There’s a problem with Legacy. Unless you can fix the issue very quickly, you should [put up a static 500 page][static-page]:

**The site is taking a very long time to respond and then shows a timeout error**

Log in on `legacy/prod3`, check nginx logs in `/var/log/nginx/error.logs`. If it appears that nginx has a problem with upstream servers, restart it: `sudo service nginx restart`.

## PaaS goes down

1. Activate the [static error page][static-page].
2. Contact [PaaS support][paas-support].

## Legacy goes down

Get in touch with Bytemark support support@bytemark.co.uk

## AWS goes down

**Before Legacy is decommissioned**

1. Log in to legacy/prod3 and remove all redirects to Find Data in the nginx configuration.
2. Restart nginx.
3. Users will be able to see the old legacy site, hosted on Bytemark.

**After Legacy is decommissioned**

There’s not much you’ll be able to do if AWS goes down. Given that half of the web will be unavailable it’s unlikely that anyone will be worrying about data.gov.uk much.

## Find Data goes down

Make sure that the user sees [a friendly error page][static-page] before investigating.

**Before Legacy is decommissioned**

1. Log in to legacy/prod3 and remove all redirects to Find Data in the nginx configuration.
2. Restart nginx.
3. Users will be able to see the old legacy site.
4. Check the PaaS logs, legacy nginx logs etc. to find the problem.

**After Legacy is decommissioned**

Check the PaaS logs, monitoring etc. to find the problem.

## Publish Data goes down

Make sure that the user sees [a friendly error page][static-page] before investigating.

Check the PaaS logs, monitoring etc. to find the problem.

## Publish worker goes down

If you see that Find doesn’t update with either manual or harvested changes made on Legacy, this probably means the worker is down. Check if the PaaS app is still working, check the cf logs, or on Logit. It should give you information about what happened. See also the [Data loss](#data-loss) section.

## Redis goes down

Check if the Redis server is working. SSH into it and run `redis-cli`. Look at the Graphite dashboard and restart the server if need be. If you suspect changes were lost:

* For change over 24 hours old, [reimport all datasets](/manual/data-gov-uk-common-tasks.html#import-data-from-legacy) from a daily dump.
* For changes less than 24 hours old, hit the legacy-sync API by going to [](https://publish-data-beta-production.cloudapps.digital/api/sync-beta).

## Elasticsearch goes down

Find Data should show a [500 page][static-page]. If Legacy is still around, [remove the redirects to Find Data](#find-data-goes-down) and users will see Legacy instead. [Contact PaaS][paas-support] about fixing Elasticsearch and recovering data.

## Postgres goes down

Find Data should still work, but Publish Data and the worker will fail. That’s acceptable while Postgres is fixed. [Contact PaaS][paas-support] for that.

## DDoS

If a denial of service attack brings the site down, notify the GOV.UK team on Slack to mitigate it using the GDS-wide firewall. If that doesn’t help, put up the [static 500 page][static-page] until proper mitigation is implemented.

## High application traffic

If the site gets very slow but still responds, check Graphite or Logit. If either shows that there’s lot of traffic:

1. If you suspect it’s a DDoS, [see above](#ddos).
2. If not, you can [scale up](/manual/data-gov-uk-common-tasks.html#scale-the-application) the number of instances of the app.

## High Redis load

This would be noticed if exporting data from Legacy takes a lot of time, and confirmed by looking at Graphite. Reasons include many datasets being created or modified by a harvester. If the queue doesn’t flush after a long time, it’s better to restart the server and hit the sync endpoint.

## High Elasticsearch load

This would be noticed if exporting data from Legacy takes a lot of time, and confirmed by looking at graphite. Reasons include many datasets being created or modified by a harvester, or [high website load](#high-application-traffic).

## Network is slow

Check traffic, or which of PaaS, AWS or Bytemark is slow. Contact the responsible party as appropriate.
