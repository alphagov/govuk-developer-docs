---
owner_slack: "#govuk-dev-tools"
title: SSH into your VM directly
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-17
review_in: 6 months
---

Consider using `vagrant ssh` to SSH into your VM directly, as it'll always do
the right thing.

If you need direct access (for `rsync`, `scp` or similar), you'll need to
manually configure your SSH configuration:

1. Run `vagrant ssh-config --host dev`
2. Paste the output into your `~/.ssh/config`
3. SSH into this using `ssh dev`

### Reverse port forwarding
If you need access to a specific port outside your VM, you can add a reverse port option when SSHing into the VM.

For example, if you have a Docker image running on your host machine on port `5678`, use the following option to allow an app inside the VM to access it on port `1234`:

`vagrant ssh -- -R 1234:localhost:5678`
