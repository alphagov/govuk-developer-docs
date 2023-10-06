---
owner_slack: "#govuk-2ndline-tech"
title: Run commands on many machines
section: AWS
layout: manual_layout
parent: "/manual.html"
---
We used to rely heavily on Fabric scripts to help us do things like running commands on all machines in a class. This approach has been deprecated, but we still need to do those things occasionally.

> **WARNING** Please test your command before unleashing it on production machines.

Imagine you need to enable puppet on all cache machines. Here's one way to do that:

```
for host in $(gds govuk connect ssh -e integration jumpbox -- govuk_node_list -c cache)
do
  gds govuk connect ssh -e integration $host -- govuk_puppet --enable
done
```

All commands in this guide are written to be run from your developer laptop.

## Breaking the script down

### Find out the public DNS names of all `cache` machines

```
gds govuk connect ssh -e integration jumpbox -- govuk_node_list -c cache
```

- For this to work you need to have [set up the GDS command line tools](/manual/get-started.html#3-install-gds-command-line-tools)

- You need to set which environment this command is running on. The example uses integration. Other options include staging and production.

- govuk-puppet holds [a list of the applications hosted on each node type](https://github.com/alphagov/govuk-puppet/blob/main/hieradata_aws/common.yaml#L14).

### Loop over the machines

```
for host in $(<hostnames>)
do
   <something fun>
done
```

### SSH to a host and run a command:

```
gds govuk connect ssh -e integration $host -- govuk_puppet --enable
```

This connects to the current `host` specified in the for loop, via the `integration` jumpbox.

The `--` separator is used to tell govuk-connect to send all the arguments afterwards to `ssh`. The command to run on the remote host is provided after that.

In this example, the command will run in its entirety on each host in turn. Sometimes this can take a while, but has the benefit of the operator being able to watch for any errors.

## StrictHostKeyChecking

Over time machines will be recycled and will eventually reuse their hostnames. If you've previously logged into a different machine with the same host name, then you may run into the SSH known hosts changed issue

To skip this check, then add `-oStrictHostKeyChecking=no` to your command:

```
for host in $(gds govuk connect ssh -e integration jumpbox -- govuk_node_list -c cache)
do
   gds govuk connect ssh -e integration $host -- -oStrictHostKeyChecking=no govuk_puppet --enable
done
```

## Useful commands

### Run Puppet

```
for host in $(gds govuk connect ssh -e integration jumpbox -- govuk_node_list -c cache)
do
   gds govuk connect ssh -e integration $host -- govuk_puppet --test
done
```

### Disable Puppet

```
for host in $(gds govuk connect ssh -e integration jumpbox -- govuk_node_list -c cache)
do
   gds govuk connect ssh -e integration $host -- govuk_puppet --disable \'Han Solo testing a new power inverter\'
done
```

Note the backslashes escaping the quotes in the puppet command.

### Enable Puppet

```
for host in $(gds govuk connect ssh -e integration jumpbox -- govuk_node_list -c cache)
do
   gds govuk connect ssh -e integration $host -- govuk_puppet --enable
done
```

### Flush the ARP cache (on integration frontend machines)

```
for host in $(gds govuk connect ssh -e integration jumpbox -- govuk_node_list -c frontend)
do
   gds govuk connect ssh -e integration $host -- sudo ip neigh flush all
done
```

[Further information on ARP cache](/manual/flush-the-arp-cache.html)

## Run a command on an arbitrary list of machines

Get your list of machines, perhaps from Icinga or maybe collating it from a few govuk_node_list commands. We'll store them in a text file:

```
gds govuk connect ssh -e integration jumpbox -- govuk_node_list -c cache > ./cache-machines.txt
```

Edit the file to list just the machines you want to run the command on.

Run the command using your file as input:

```
for host in $(cat ./cache-machines.txt)
do
   gds govuk connect ssh -e integration $host -- govuk_puppet --enable
done
```
