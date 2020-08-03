---
owner_slack: "#re-govuk"
title: Add a disk to a vCloud machine (Carrenza only)
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

> **Note**
>
> This process is only applicable to Carrenza environments.
> For AWS environments, disk space can be expanded by changing
> and deploying the appropriate Terraform configuration
> [(example for backend machines)](https://github.com/alphagov/govuk-aws/blob/master/terraform/projects/app-backend/main.tf#L204).

New disks are added to machines to add or increase the size of a
[logical volume (LV)][logical-volume-wiki].

## 1) Add the new disk to Puppet Hieradata

Add the new disk to
[Hiera data](https://github.com/alphagov/govuk-puppet/tree/master/hieradata)
([example](https://github.com/alphagov/govuk-puppet/commit/73531ea7a7c28cbbb1c04f41ec5da53b4ff591d2)).

You can deploy Puppet once the changes have been merged in. However, until the
disk is configured, Puppet runs on the machine will result in errors.

## 2) Add the extra disk in vCloud Director

1. Navigate to the VM Properties in the vCloud Director interface and
   select the 'Hardware' tab. From here, click the add button under
   disks, choose a size and click Save.
2. Wait for the VM to reconfigure.

Please view this [page](connect-to-vcloud-director.html) for details on how to access Carrenza. The appropriate credentials are in `govuk-secrets`.

> **Note**
>
> In the link above, you will see a link format similar to https://vcloud.carrenza.com/tenant/{environment}, where {environment} is the value of the `Org` key you get from decrypting secrets. It will look something like `Org: XXXX-govuk-staging-london`.
>
> **Note**
>
> Aligning disk partitions on VMware VMs ensures that disk I/O is not
> negatively affected. If a disk is not partition aligned correctly, I/O
> from each filesystem is being translated into 2 I/Os to the
> underlying virtual disk, and thus to the SAN itself. Ultimately, it is
> not exactly a doubling. In fact, it leads to about a 20-30% disk I/O
> increase, thus creating further load.
>
> Further details can be found in [this VMware
> PDF](http://www.vmware.com/pdf/esx3_partition_align.pdf), or at [this
> blog
> post](http://blogs.vmware.com/vsphere/2011/08/guest-os-partition-alignment.html).
> VMware performance recommendations can be [found
> here](http://www.vmware.com/pdf/Perf_Best_Practices_vSphere5.0.pdf).
>
> **WARNING**
>
> When adding new disks, be careful to select an appropriate disk
> controller.
>
> There is a known issue whereby adding disks using certain disk
> controllers may alter the BIOS boot order, causing a 'System disk not
> found error' when restarting the VM. Specifically, check the
> compability table (Table 5-4) on page 109 of the [vSphere Virtual
> Machine Administration
> Guide](http://pubs.vmware.com/vsphere-55/topic/com.vmware.ICbase/PDF/vsphere-esxi-vcenter-server-551-virtual-machine-admin-guide.pdf).
>
> Using the 'LSI Logic SAS (SCSI)' avoids this bug as it's also the
> default disk controller used when we provision machines using [vCloud
> Launcher](http://rubygems.org/gems/vcloud-launcher).

## 3) Update the GOV.UK provisioning repository

The [GOV.UK provisioning](https://github.com/alphagov/govuk-provisioning)
repository contains all the configuration of the hosts needed for provisioning
GOV.UK environments. It's important that this remains in sync with the
configuration in vCloud Director.

See an [example](https://github.com/alphagov/govuk-provisioning/pull/17/files).

## 4) Probe for the new disk on each VM

1. Run `sudo fdisk -l` and note the output. You should see each disk
   already configured listed separately. Make a note of which are
   already present.
2. Run the following loop as root to probe for new discs

```bash
echo '- - -' | sudo tee -a /sys/class/scsi_host/*/scan
```

3. Run `sudo fdisk -l` again and note that you have a new disk called
   `/dev/sdX` where X is a letter. This disk *should* be unpartitioned.

## 5) Partition the disk if necessary

You can skip this step if you have configured Puppet to use the whole
disk as an LVM physical volume.

1. Set an environment variable, replacing `X` with the appropriate
   block device letter

```bash
export NEW_DISK=/dev/sdX
```

2. Create a single partition on that disk

```bash
sudo parted ${NEW_DISK} mklabel msdos
sudo parted ${NEW_DISK} mkpart primary 1 100%
```

We use [LVM](https://wiki.ubuntu.com/Lvm) for disk management. Once a
partition exists as a device file (i.e. `/dev/sdX1`), Puppet will enable
LVM, format the disk and tune the filesystem.

## 6) Run Puppet

1. Run Puppet, which will configure LVM and tune the filesystem:

```bash
govuk_puppet --test
```

2. Verify that the new disk has been created by checking the output of
   `sudo fdisk -l` which will no longer say the disk is unpartitioned. For a
   new logical volume, you can also check `mount` for its existence

## 7) Extend existing logical volume and filesystem

You can skip this step if you're creating a new disk/machine.

If you're adding an additional physical volume to an existing mount
through Puppet's `govuk::lvm` resource then you'll need to manually
extend the logical volume and filesystem. These are safe online
operations.

1. Set environment variables for the VG and LV names. Replace `XXX`
   with the appropriate names from `sudo vgs` and `sudo lvs`:

```bash
export VG=XXX
export LV=XXX
```

2. Extend the logical volume to the full size of the volume group:

```bash
sudo lvextend -l +100%FREE /dev/${VG}/${LV}
```

3. Extend the filesystem to the full size of the logical volume:

```bash
sudo resize2fs /dev/mapper/${VG}-${LV}
```

[logical-volume-wiki]: https://en.wikipedia.org/wiki/Logical_volume_management
