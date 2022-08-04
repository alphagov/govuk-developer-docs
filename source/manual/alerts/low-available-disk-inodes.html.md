---
owner_slack: "#govuk-2ndline-tech"
title: Low available disk inodes
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

See also: [low available disk space](low-available-disk-space.html)

This alerts means that a machine's filesystem has too many files or directories.

An inode is a data structure used on unix filesystems to store metadata about files and dirs. On a given filesystem the number of inodes is limited, so a machine may run out if it creates too many files -- even if there's plenty of disk space left. The solution is therefore to remove unused files or dirs.

The inode usage on a machine can be checked using:

```sh
$ df -i
```

which will give output like:

```
Filesystem           Inodes  IUsed   IFree IUse% Mounted on
/dev/mapper/os-root 3121152 151646 2969506    5% /
```

with a row for each filesystem currently mounted.

### Locating high inode usage

The following command will print out a list of directories prefixed with the number of files they contain, sorted low to high. The largest are therefore most likely candidates for removal.

```sh
{ find / -xdev -printf '%h\n' | sort | uniq -c | sort -k 1 -n; } 2>/dev/null
```

Change the `find /` to `find /some-other-path` if the `df -i` command identified some other filesystem as being the full one.

Note that if the `/tmp` directory is on the full filesystem `sort` may be unable to create a tempfile. In that case, add the `-T /some-other-path` parameter to both of the `sort` commands in the above one-liner.

### Low available disk inodes (Jenkins)

If Jenkins is running out of inodes (rather than disk space) then it may be
possible to free some by clearing out old workspaces (on the `ci-agent` machines), or failed jobs (on the `ci-master` machine):

#### Clearing old workspaces

We have a [process which deletes old workspaces automatically](https://github.com/alphagov/govuk-puppet/pull/11760/files). The threshold is [90 days by default](https://github.com/alphagov/govuk-puppet/blob/16d467705ce60befee568a77ab943e3059c1465d/modules/govuk_ci/manifests/cleanup.pp#L11), and [30 days for CI agents](https://github.com/alphagov/govuk-puppet/blob/16d467705ce60befee568a77ab943e3059c1465d/hieradata_aws/class/integration/ci_agent.yaml#L10).

If the number of workspaces is still too high on a particular machine, you can delete workspaces manually with the command below. However, you should also consider lowering the thresholds above (and updating this documentation) so that manual intervention is not required again.

```sh
# Delete any workspaces older than 1 day
$ sudo find /var/lib/jenkins/workspace/ -maxdepth 1 -type d -mtime +1 -exec rm -rf {} \;
```

#### Clearing failed jobs

```sh
$ sudo find /var/lib/jenkins/jobs/ -mindepth 3 -maxdepth 3 -type d -mtime +30 | grep -v -P "main|master" | xargs -I {} sudo rm -rf {}
```

This will find any job branches that are older than 30 days (except for main and master, which it might be prudent to keep) and delete them. If you want to know how many folders will be affected, you can see with:

```sh
$ sudo find /var/lib/jenkins/jobs/ -mindepth 3 -maxdepth 3 -type d -mtime +30 | grep -v -P "main|master" | wc -l
```
