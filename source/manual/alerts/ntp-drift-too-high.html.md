---
owner_slack: "#2ndline"
title: ntp drift too high
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_at: 2017-01-02
review_in: 6 months
---

# 'ntp drift too high'

There are tasks in fabric-scripts to make this less painful:

    fab $environment -H jumpbox-1.management ntp.status
    fab $environment -H jumpbox-1.management ntp.resync

