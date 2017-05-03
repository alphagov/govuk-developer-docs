---
owner_slack: "#2ndline"
title: Unicorn Herder
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2016-12-30
review_in: 6 months
---

# Unicorn Herder

### 'app unicornherder running'

This alert means the Unicorn Herder process has disappeared for the
named app, so the app is still running but we don't know about it and
can't control it.

At the moment, the fix is to run the fabric task vm.bodge\_unicorn for
that app. (The name of the task should give a clue as to why I say "At
the moment".)

Within fabric-scripts repo, make sure you have a virtualenv and it is
activated. If you don't have one, do this:

    virtualenv .
    . bin/activate

virtualenv is installed with pip - if you don't have it, install it as
such:

    pip install virtualenv

You'll also need a username in a .fabricrc file, if you haven't already
got one:

    echo 'user = YOURNAME' >> ~/.fabricrc

Then, depending on the alert, look at which machine and which app it is
that needs "bodging". For example, if the machine was
whitehall-backend-1 and the app is whitehall, then the command you would
run is:

    fab $environment -H whitehall-backend-1.backend vm.bodge_unicorn:whitehall

Job done. The Nagios alert should clear within a few minutes.

