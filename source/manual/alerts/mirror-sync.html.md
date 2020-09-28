---
owner_slack: "#govuk-2ndline"
title: Mirror sync
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This is [a script that runs hourly](https://github.com/alphagov/govuk-puppet/blob/99486124689b198120800572b331b38b87a18a6c/modules/govuk_crawler/manifests/init.pp#L220-L227) to sync the mirror contents to S3.

## WARNING: GOV.UK mirror synchronisation failed.

Check the logs for any errors.

```
grep govuk_sync_mirror /var/log/syslog
```

Try running the script manually. It doesn't normally produce any output; you will need to check `/var/log/syslog` for this. You may want to run the following in a `screen` session (can take ages).

```
# Switch to the right user
sudo su - govuk-crawler

# Double check the command
crontab -l

# Run the command from the output
...
```
