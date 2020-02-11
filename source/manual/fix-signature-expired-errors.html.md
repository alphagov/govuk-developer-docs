---
owner_slack: "#govuk-dev-tools"
title: Fix `Signature expired` errors
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-10-08
review_in: 6 months
---

Sometimes, the time in the Development VM can go out of sync with the time in
the host machine. This can cause errors similar to the following:
```
An error occurred (SignatureDoesNotMatch) when calling the AssumeRole operation: Signature expired: 20190227T113324Z is now earlier than 20190227T113524Z (20190227T115024Z - 15 min.)
error: aws s3 command failed: cp s3://govuk-development-data-test/data-extracts/index.json /home/vagrant/.cache/govuk-guix/development-data/data-extracts/
```

To verify if the time is out of sync, run the `date` command both in your host
machine and in the vm. If the results are different, run the following command
**in the vm** to fix the issue:
```
$ sudo /usr/sbin/VBoxService --timesync-set-start
```
