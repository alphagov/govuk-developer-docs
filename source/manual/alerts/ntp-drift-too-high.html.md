---
owner_slack: '#2ndline'
review_by: 2017-07-02
title: 'ntp drift too high'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# 'ntp drift too high'

There are tasks in fabric-scripts to make this less painful:

    fab $environment -H jumpbox-1.management ntp.status
    fab $environment -H jumpbox-1.management ntp.resync

