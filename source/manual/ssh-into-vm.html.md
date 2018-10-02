---
owner_slack: "#govuk-2ndline"
title: SSH into your VM directly
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-02
review_in: 6 months
---

Consider using `vagrant ssh` to SSH into your VM directly, as it'll always do
the right thing.

If you need direct access (for `rsync`, `scp` or similar), you'll need to
manually configure your SSH configuration:

1. Run `vagrant ssh-config --host dev`
2. Paste the output into your `~/.ssh/config`
3. SSH into this using `ssh dev`
