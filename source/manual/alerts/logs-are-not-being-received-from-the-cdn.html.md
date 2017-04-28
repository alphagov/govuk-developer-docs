---
owner_slack: "#2ndline"
title: Logs are not being received from the CDN
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_at: 2016-11-05
review_in: 6 months
---

# Logs are not being received from the CDN

Sometimes, we stop receiving either GOV.UK or Bouncer logs from Fastly
to logs-cdn-1.management. We run Rsyslog on this machine, and Fastly
send us logs using Syslog on their side to a port we have previously
specified.

Firstly, look at how old and how large /mnt/logs\_cdn/cdn-govuk.log or
/mnt/logs\_cdn/cdn-bouncer.log is. In GOV.UK's case, the file should be
created early in the morning each day, and the filesize should be
positive and greater than 0 bytes. At the end of each day, a file is
created for the following day, the previous day's file is gzipped up.
Bouncer's logs rotate once per hour.

To fix, try (in order):

-   if you have access to Fastly, check if Fastly have recorded an error
    when writing to our rsyslog endpoint by logging in to the [Fastly
    control panel](https://app.fastly.com/) and open the following URL
    in your browser:

        https://app.fastly.com/service/<service-id>/logging_status

    You can find the service ID in the
    [deployment](https://github.gds/gds/deployment/blob/8a85170d639fb82f0f86653aba2e536655811741/puppet/hieradata/production.yaml#L15-L18)
    repository.

    In particular, notice the `BrokenNow` boolean which indicates if
    Fastly are currently unable to log to our endpoint.

-   restarting Rsyslog on the box: sudo service rsyslog restart, then
    sudo
    tail -f /mnt/logs\_cdn/cdn-govuk.log, or
    /mnt/logs\_cdn/cdn-bouncer.log, to check that logs are being
    streamed in to us. You'll be able to see when they are, as the
    filesize increases and human-readable log lines are entered in to
    that file. It can take as long as 45 minutes for logs to start
    coming through, so acknowledge the alert and come back to it later.
-   redeploying the existing Fastly service configuration using [this
    Jenkins
    job](https://deploy.publishing.service.gov.uk/job/Deploy_CDN/).
    Authenticate with the 2nd Line user, details of which can be found
    in the infra\_team cred store. If you don't have access, ask someone
    on the Infrastructure team to deploy it for you.
-   tailing syslog - sudo tail -f /var/log/syslog for the current file,
    and sudo zless syslog.x.gz for any gzipped files replacing x with
    the number from the file itself. It's pretty verbose, and might not
    be much use, but it's worth a look.
-   contacting Fastly

