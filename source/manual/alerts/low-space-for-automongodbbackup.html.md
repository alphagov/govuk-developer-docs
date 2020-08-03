---
owner_slack: "#govuk-2ndline"
title: Running out of space for automongodbbackup
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

### Running out of space for `automongodbbackup`

The box where the backups are stored by `automongodbbackup` can sometimes run out of space.
The `automongodbbackup` script can fail ungracefully when zipping the backup if it runs out of space. If it does, it will fail to clean up after itself so it will leave the half-zipped backup lying around. In addition to this, if it fails it won't clear older backups. You will have to remove an older backup manually as well as re-zip the latest backup.
Another cause of us running out of space is that we keep backups around for the past 7 days which can occupy a lot of space.

In order to clear some space you have to do the following steps:

1. SSH into the box
2. Run `df -h`. The output should look something like this:

```
Filesystem                   Size  Used Avail Use% Mounted on                                                                  │
/dev/mapper/os-root           47G  2.7G   42G   6% /                                                                           │
none                         4.0K     0  4.0K   0% /sys/fs/cgroup                                                              │
udev                         3.9G   12K  3.9G   1% /dev                                                                        │
tmpfs                        799M  732K  798M   1% /run                                                                        │
none                         5.0M     0  5.0M   0% /run/lock                                                                   │
none                         3.9G     0  3.9G   0% /run/shm                                                                    │
none                         100M     0  100M   0% /run/user                                                                   │
/dev/sda1                    464M   69M  367M  16% /boot                                                                       │
/dev/mapper/backup-mongodb    32G   17G   16G  52% /var/lib/automongodbbackup                                                  │
/dev/mapper/mongodb-data      63G   45G   19G  71% /var/lib/mongodb                                                            │
/dev/mapper/mongo-s3backups   50G   52M   50G   1% /var/lib/s3backup
```

3. The number next to `/var/lib/automongodbbackup` is probably 100% if you're getting out of space alerts in Icinga.
4. Go to `/var/lib/automongodbbackup` and visit the `daily` folder
5. Check the size of the backups in that folder: `ls -ls`. The latest zipped backup should be smaller than the rest. You should also have an unzipped version of the backup lying around. Remove the zipped version and start zipping again. In order to be sure you are doing the compression the right way, you need to check what the script currently does and respect the [naming convention][backup-script].
6. You can also remove an older backup to clear some space.

[backup-script]: https://github.com/alphagov/govuk-puppet/blob/master/modules/mongodb/templates/automongodbbackup#L364
