---
title: 'nginx requests too low'
parent: /manual.html
layout: manual_layout
section: Alerts
---

# 'nginx requests too low'

-   An Icinga check that alerts when the number of Nginx requests drops
    below a critical threshold.
-   We have seen misconfigured firewall configs on our vSE.
-   It could be a genuine low number of requests or it may be indicative
    of a bigger problem as described above. The threshold is
    configurable in hieradata so we can tweak for environments where we
    expect to see lower traffic levels.

