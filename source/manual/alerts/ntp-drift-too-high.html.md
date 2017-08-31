---
owner_slack: "#2ndline"
title: ntp drift too high
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-08-31
review_in: 6 months
---

The [Network Time Protocol (NTP) daemon](http://doc.ntp.org/4.1.0/ntpd.htm) (`ntpd`) is responsible for keeping system
time synchronised with standard time servers on the Internet.

The `ntpd.drift` file records the latest estimate of clock frequency error. If this value gets too high, this can be
an indicator of large error between the system clock and the real time.

There are tasks in fabric-scripts to help resynchronise the system clock:

    fab $environment -H jumpbox-1.management ntp.status
    fab $environment -H jumpbox-1.management ntp.resync
    
> **Note**
>
> The fab script will try to slew the time offset, which means continually adding/subtracting little bits of time until
> the clock is in sync. This is in contrast to a step change, where the clock's time is just changed. Step changes
> can cause - for example - log timestamp inconsistencies.  
>
> According to the [`ntpdate` man page](https://www.freebsd.org/cgi/man.cgi?query=ntpdate&sektion=8), the slew forced
> by the `-B` flag can take **hours** to gradually take effect.
