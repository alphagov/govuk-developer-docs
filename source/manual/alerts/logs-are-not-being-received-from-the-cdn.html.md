---
owner_slack: "#govuk-2ndline"
title: Logs are not being received from the CDN
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-02-18
review_in: 6 months
---

Sometimes, we stop receiving either GOV.UK or Bouncer logs from Fastly
to `monitoring-1.management`. We run Rsyslog on this machine, and Fastly
send us logs using Syslog on their side to a port we have previously
specified.

Firstly, look at how old and how large `/var/log/cdn/cdn-govuk.log` or
`/var/log/cdn/cdn-bouncer.log` is. In GOV.UK's case, the file should
be created each hour, and the file size should be positive and greater
than 0 bytes. These log files rotate once per hour, with the previous
hour gzipped up.

To fix, try (in order):

-   if you have access to Fastly, check if Fastly have recorded an error
    when writing to our rsyslog endpoint by logging in to the [Fastly
    control panel](https://app.fastly.com/) and open the following URL
    in your browser:

        https://app.fastly.com/service/<service-id>/logging_status

    You can find the service ID in the
    [deployment](https://github.com/alphagov/govuk-secrets/blob/8a85170d639fb82f0f86653aba2e536655811741/puppet/hieradata/production.yaml#L15-L18)
    repository.

    In particular, notice the `BrokenNow` boolean which indicates if
    Fastly are currently unable to log to our endpoint.

-   restarting Rsyslog on the box: `sudo service rsyslog restart`, then
    `sudo tail -f /var/log/cdn-govuk.log`, or
    `/var/log/cdn-bouncer.log`, to check that logs are being
    streamed in to us. You'll be able to see when they are, as the
    file size increases and human-readable log lines are entered in to
    that file. It can take as long as 45 minutes for logs to start
    coming through, so acknowledge the alert and come back to it later.
-   redeploying the existing Fastly service configuration using [this
    Jenkins
    job](https://deploy.publishing.service.gov.uk/job/Deploy_CDN/).
    Authenticate with the 2nd Line user, details of which can be found
    in the `infra` password store. If you don't have access, ask one of
    GOV.UK's senior technologists, or Reliability Engineering, to deploy
    it for you.
-   tailing Syslog - `sudo tail -f /var/log/syslog` for the current file,
    and `sudo zless syslog.x.gz` for any gzipped files replacing x with
    the number from the file itself. It's pretty verbose, and might not
    be much use, but it's worth a look.
-   contacting Fastly
