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

### Low available disk inodes (Jenkins)

If Jenkins is running out of inodes (rather than disk space) then it may be
possible to free some by clearing out old workspaces (on the `ci-agent` machines), or failed jobs (on the `ci-master` machine):

#### Clearing old workspaces

```sh
$ sudo find /var/lib/jenkins/workspace/ -maxdepth 1 -type d -mtime +1 -exec rm -rf {} \;
```

This will find any directories that are older than 1 day and delete them.

#### Clearing failed jobs

```sh
$ sudo find /var/lib/jenkins/jobs/ -mindepth 3 -maxdepth 3 -type d -mtime +30 | grep -v -P "main|master" | xargs -I {} sudo rm -rf {}
```

This will find any job branches that are older than 30 days (except for main and master, which it might be prudent to keep) and delete them. If you want to know how many folders will be affected, you can see with:

```sh
$ sudo find /var/lib/jenkins/jobs/ -mindepth 3 -maxdepth 3 -type d -mtime +30 | grep -v -P "main|master" | wc -l
```

### Low available disk space on Jenkins

One possible cause of this is that the `/var/lib/docker` directory is consuming
a large amount of disk space. This has been found to happen on the `ci-agent`
machines.

Verify this:

```sh
$ cd /var/lib
$ sudo ncdu
```

If `/var/lib/docker` is consuming a large amount of disk space run the
following as root:

```sh
$ docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
$ docker volume rm $(docker volume ls -qf dangling=true)
```

This will remove 'dangling' images and volumes. A comprehensive set of
instructions can be found in this
[Docker resource cleanup gist][docker-cleanup].

[docker-cleanup]: https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430
