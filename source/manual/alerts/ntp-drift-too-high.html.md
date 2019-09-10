---
owner_slack: "#govuk-2ndline"
title: ntp drift too high
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-09-10
review_in: 6 months
---

The [Network Time Protocol (NTP) daemon](http://doc.ntp.org/4.1.0/ntpd.htm) (`ntpd`) is responsible for keeping system
time synchronised with standard time servers on the Internet.

The `ntpd.drift` file records the latest estimate of clock frequency error. If this value gets too high, this can be
an indicator of large error between the system clock and the real time.

If the system clock is out of sync on a Vmware host, first make sure the synchronisation between guest and host has been
disabled. This is enabled by default in the image configuration and could cause issues when ntpd is running on the same box.

To check the status, enable or disable Vmware periodic time synchronization, we can use the `vmware-toolbox-cmd` program:

    $ sudo vmware-toolbox-cmd timesync status
      Enabled
    $ sudo vmware-toolbox-cmd timesync disable
      Disabled
    $ sudo vmware-toolbox-cmd timesync status
      Disabled

If the Vmware timesync is disabled, we can use [fabric-scripts](https://github.com/alphagov/fabric-scripts) tasks to help resynchronise the system clock:

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
>
> Additionally, the `ntpdate` functionality has been made available in the `ntpd` program. To resync an offset bigger than
> 1000, you can run `sudo service ntp stop; sudo ntpd -gq; sudo service ntp start`.
