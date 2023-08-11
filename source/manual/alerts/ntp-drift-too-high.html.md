---
owner_slack: "#govuk-2ndline-tech"
title: ntp drift too high
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# ntp drift too high

The [Network Time Protocol (NTP) daemon](http://doc.ntp.org/4.1.0/ntpd.htm) (`ntpd`) is responsible for keeping system
time synchronised with standard time servers on the Internet.

The `ntpd.drift` file records the latest estimate of clock frequency error. If this value gets too high, this can be
an indicator of large error between the system clock and the real time.

SSH to the affected machine, then run:

```bash
sudo service ntp stop
sudo ntpdate -B ntp.ubuntu.com
sudo service ntp start
```

> **Note**
>
> `ntpdate -B` will try to slew the time offset, which means continually adding/subtracting little bits of time until
> the clock is in sync. This is in contrast to a step change, where the clock's time is just changed. Step changes
> can cause - for example - log timestamp inconsistencies.
>
> According to the [`ntpdate` man page](https://www.freebsd.org/cgi/man.cgi?query=ntpdate&sektion=8), the slew can take
> **hours** to gradually take effect.
>
> Additionally, the `ntpdate` functionality has been made available in the `ntpd` program. To resync an offset bigger than
> 1000, you can run `sudo service ntp stop; sudo ntpd -gq; sudo service ntp start`.
