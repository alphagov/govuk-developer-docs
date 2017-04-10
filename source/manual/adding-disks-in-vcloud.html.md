---
title: Adding a disk to a vCloud machine
section: howto
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/adding-disks-in-vcloud.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/adding-disks-in-vcloud.md)


# Adding a disk to a vCloud machine

> **note**

> Aligning disk partitions on VMware VMs ensures that disk I/O is not
> negatively affected. If a disk is not partition aligned correctly, I/O
> from each filesystem is being translated in to 2 I/Os to the
> underlying virtual disk, and thus to the SAN itself. Ultimately, it is
> not exactly a doubling - in fact, it leads to about a 20-30% disk I/O
> increase, thus creating further load.
>
> Further details can be found in [this VMware
> PDF](http://www.vmware.com/pdf/esx3_partition_align.pdf), or at [this
> blog
> post](http://blogs.vmware.com/vsphere/2011/08/guest-os-partition-alignment.html).
> VMware performance recommendations can be [found
> here](http://www.vmware.com/pdf/Perf_Best_Practices_vSphere5.0.pdf).

> **warning**

> When adding new disks, be careful to select an appropriate disk
> controller.
>
> There is a known issue whereby adding disks using certain disk
> controllers may alter the BIOS boot order (causing a 'System disk not
> found error' when restarting the VM). Specifically, check the
> compability table (Table 5-4) on page 109 of the [vSphere Virtual
> Machine Administration
> Guide](http://pubs.vmware.com/vsphere-55/topic/com.vmware.ICbase/PDF/vsphere-esxi-vcenter-server-551-virtual-machine-admin-guide.pdf).
>
> Using the 'LSI Logic SAS (SCSI)' avoids this bug as it's also the
> default disk controller used when we provision machines using [vCloud
> Launcher](http://rubygems.org/gems/vcloud-launcher).

## 1) Add the new disk to Hiera

1)  Add the new disk to
    [Hiera](https://github.com/alphagov/govuk-puppet/tree/master/hieradata).

See an [example
here](https://github.com/alphagov/govuk-puppet/commit/73531ea7a7c28cbbb1c04f41ec5da53b4ff591d2).

## 2) Add the extra disk in vCloud Director

1)  Navigate to the VM Properties in the vCloud Director interface and
    select the 'Hardware' tab. From here, hit the add button under
    disks, choose a size and hit save.
2)  Wait for the VM to reconfigure.

## 3) Probe for the new disk on the VM

1)  Run `sudo fdisk -l` and note the output. You should see each disk
    already configured listed separately. Make a note of which are
    already present.
2)  Run the following loop as root to probe for new discs

<!-- -->

    echo '- - -' | sudo tee -a /sys/class/scsi_host/*/scan

3)  Run `sudo fdisk -l` again and note that you have a new disk called
    `/dev/sdX` where X is a letter. This disk *should* be unpartitioned.

## 4) Partition the disk if necessary

You can skip this step if you have configured Puppet to use the whole
disk as an LVM physical volume.

1)  Set an environment variable, replacing `X` with the appropriate
    block device letter

<!-- -->

    export NEW_DISK=/dev/sdX

2)  Create a single partition on that disk

<!-- -->

    sudo parted ${NEW_DISK} mklabel msdos
    sudo parted ${NEW_DISK} mkpart primary 1 100%

We use [LVM](https://wiki.ubuntu.com/Lvm) for disk management. Once a
partition exists as a device file (i.e. `/dev/sdX1`), Puppet will enable
LVM, format the disk and tune the filesystem.

## 5) Run Puppet

1)  Run Puppet, which will configure LVM and tune the filesystem:

<!-- -->

    govuk_puppet --test

2)  Verify that the new disk has been created by running `mount`.

## 6) Extend existing logical volume and filesystem

You can skip this step if you're creating a new disk/machine.

If you're adding an additional physical volume to an existing mount
through Puppet's `govuk::lvm` resource then you'll need to manually
extend the logical volume and filesystem. These are safe online
operations.

1)  Set environment variables for the VG and LV names. Replace `XXX`
    with the appropriate names from `sudo vgs` and `sudo lvs`:

<!-- -->

    export VG=XXX
    export LV=XXX

2)  Extend the logical volume to the full size of the volume group:

<!-- -->

    sudo lvextend -l +100%FREE /dev/${VG}/${LV}

3)  Extend the filesystem to the full size of the logical volume:

<!-- -->

    sudo resize2fs /dev/mapper/${VG}-${LV}

