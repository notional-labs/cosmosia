
# Ref install LVM on Hetzner Ax101

### installimage:

```console
SWRAID 0

PART swap swap 4G
PART /boot ext3 1G
PART / ext4 32G
```


### fdisk

```console
[root@cosmosia10 ~]# fdisk -l
Disk /dev/nvme1n1: 3.49 TiB, 3840755982336 bytes, 7501476528 sectors
Disk model: SAMSUNG MZQL23T8HCLS-00A07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 131072 bytes / 131072 bytes


Disk /dev/nvme0n1: 3.49 TiB, 3840755982336 bytes, 7501476528 sectors
Disk model: SAMSUNG MZQL23T8HCLS-00A07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 131072 bytes / 131072 bytes
Disklabel type: gpt
Disk identifier: F36B1748-B9A6-4F56-9E1D-E7B3937CE9D3

Device            Start      End  Sectors Size Type
/dev/nvme0n1p1     4096  8392703  8388608   4G Linux swap
/dev/nvme0n1p2  8392704 10489855  2097152   1G Linux filesystem
/dev/nvme0n1p3 10489856 77598719 67108864  32G Linux filesystem
/dev/nvme0n1p4     2048     4095     2048   1M BIOS boot

Partition table entries are not in disk order.

[root@cosmosia10 ~]# fdisk /dev/nvme0n1

Welcome to fdisk (util-linux 2.38.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

This disk is currently in use - repartitioning is probably a bad idea.
It's recommended to umount all file systems, and swapoff all swap
partitions on this disk.


Command (m for help): h
h: unknown command

Command (m for help): m

Help:

  GPT
   M   enter protective/hybrid MBR

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table


Command (m for help): p

Disk /dev/nvme0n1: 3.49 TiB, 3840755982336 bytes, 7501476528 sectors
Disk model: SAMSUNG MZQL23T8HCLS-00A07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 131072 bytes / 131072 bytes
Disklabel type: gpt
Disk identifier: F36B1748-B9A6-4F56-9E1D-E7B3937CE9D3

Device            Start      End  Sectors Size Type
/dev/nvme0n1p1     4096  8392703  8388608   4G Linux swap
/dev/nvme0n1p2  8392704 10489855  2097152   1G Linux filesystem
/dev/nvme0n1p3 10489856 77598719 67108864  32G Linux filesystem
/dev/nvme0n1p4     2048     4095     2048   1M BIOS boot

Partition table entries are not in disk order.

Command (m for help): n
Partition number (5-128, default 5):
First sector (77598720-7501476494, default 77598720):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (77598720-7501476494, default 7501475839):

Created a new partition 5 of type 'Linux filesystem' and of size 3.5 TiB.

Command (m for help): t
Partition number (1-5, default 5):
Partition type or alias (type L to list all): L
  1 EFI System                     C12A7328-F81F-11D2-BA4B-00A0C93EC93B
  2 MBR partition scheme           024DEE41-33E7-11D3-9D69-0008C781F39F
...
 43 Linux LVM                      E6D6D379-F507-44C2-A23C-238F2A3DF928
...
 200 Marvell Armada 3700 Boot partition 6828311A-BA55-42A4-BCDE-A89BB5EDECAE

Aliases:
   linux          - 0FC63DAF-8483-4772-8E79-3D69D8477DE4
   swap           - 0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
   home           - 933AC7E1-2EB4-4F13-B844-0E14E2AEF915
   uefi           - C12A7328-F81F-11D2-BA4B-00A0C93EC93B
   raid           - A19D880F-05FC-4D3B-A006-743F0F84911E
   lvm            - E6D6D379-F507-44C2-A23C-238F2A3DF928
Partition type or alias (type L to list all): 43

Changed type of partition 'Linux filesystem' to 'Linux LVM'.

Command (m for help): w
The partition table has been altered.
Syncing disks.

[root@cosmosia10 ~]# fdisk /dev/nvme1n1

Welcome to fdisk (util-linux 2.38.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
The size of this disk is 3.5 TiB (3840755982336 bytes). DOS partition table format cannot be used on drives for volumes larger than 2199023255040 bytes for 512-byte sectors. Use GUID partition table format (GPT).

Created a new DOS disklabel with disk identifier 0x19f3281a.

Command (m for help): g
Created a new GPT disklabel (GUID: 6BF4EFC8-124F-BA45-831E-3B7CB3C175C2).

Command (m for help): n
Partition number (1-128, default 1):
First sector (2048-7501476494, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-7501476494, default 7501475839):

Created a new partition 1 of type 'Linux filesystem' and of size 3.5 TiB.

Command (m for help): t
Selected partition 1
Partition type or alias (type L to list all): 43
Changed type of partition 'Linux filesystem' to 'Linux LVM'.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

[root@cosmosia10 ~]# fdisk -l
Disk /dev/nvme1n1: 3.49 TiB, 3840755982336 bytes, 7501476528 sectors
Disk model: SAMSUNG MZQL23T8HCLS-00A07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 131072 bytes / 131072 bytes
Disklabel type: gpt
Disk identifier: 6BF4EFC8-124F-BA45-831E-3B7CB3C175C2

Device         Start        End    Sectors  Size Type
/dev/nvme1n1p1  2048 7501475839 7501473792  3.5T Linux LVM


Disk /dev/nvme0n1: 3.49 TiB, 3840755982336 bytes, 7501476528 sectors
Disk model: SAMSUNG MZQL23T8HCLS-00A07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 131072 bytes / 131072 bytes
Disklabel type: gpt
Disk identifier: F36B1748-B9A6-4F56-9E1D-E7B3937CE9D3

Device            Start        End    Sectors  Size Type
/dev/nvme0n1p1     4096    8392703    8388608    4G Linux swap
/dev/nvme0n1p2  8392704   10489855    2097152    1G Linux filesystem
/dev/nvme0n1p3 10489856   77598719   67108864   32G Linux filesystem
/dev/nvme0n1p4     2048       4095       2048    1M BIOS boot
/dev/nvme0n1p5 77598720 7501475839 7423877120  3.5T Linux LVM

Partition table entries are not in disk order.
[root@cosmosia10 ~]#
```

### LVM

```console
[root@cosmosia10 ~]# pvcreate -v /dev/nvme0n1p5 /dev/nvme1n1p1
  Wiping signatures on new PV /dev/nvme0n1p5.
  Wiping signatures on new PV /dev/nvme1n1p1.
  Set up physical volume for "/dev/nvme0n1p5" with 7423877120 available sectors.
  Zeroing start of device /dev/nvme0n1p5.
  Writing physical volume data to disk "/dev/nvme0n1p5".
  Physical volume "/dev/nvme0n1p5" successfully created.
  Set up physical volume for "/dev/nvme1n1p1" with 7501473792 available sectors.
  Zeroing start of device /dev/nvme1n1p1.
  Writing physical volume data to disk "/dev/nvme1n1p1".
  Physical volume "/dev/nvme1n1p1" successfully created.
[root@cosmosia10 ~]# vgcreate -v vg0 /dev/nvme0n1p5 /dev/nvme1n1p1
  Wiping signatures on new PV /dev/nvme0n1p5.
  Wiping signatures on new PV /dev/nvme1n1p1.
  Adding physical volume '/dev/nvme0n1p5' to volume group 'vg0'
  Adding physical volume '/dev/nvme1n1p1' to volume group 'vg0'
  Creating volume group backup "/etc/lvm/backup/vg0" (seqno 1).
  Volume group "vg0" successfully created
[root@cosmosia10 ~]# lvcreate -L 100G -i 2 -I 4k -n lv_data vg0 -v
  Creating logical volume lv_data
  Archiving volume group "vg0" metadata (seqno 1).
  Activating logical volume vg0/lv_data.
  activation/volume_list configuration setting not defined: Checking only host tags for vg0/lv_data.
  Creating vg0-lv_data
  Loading table for vg0-lv_data (254:0).
  Resuming vg0-lv_data (254:0).
  Wiping known signatures on logical volume vg0/lv_data.
  Initializing 4.00 KiB of logical volume vg0/lv_data with value 0.
  Logical volume "lv_data" created.
  Creating volume group backup "/etc/lvm/backup/vg0" (seqno 2).
[root@cosmosia10 ~]# lvextend -l +100%FREE /dev/vg0/lv_data
  Using stripesize of last segment 4.00 KiB
  Rounding size (1821941 extents) down to stripe boundary size for segment (1821940 extents)
  Size of logical volume vg0/lv_data changed from 100.00 GiB (25600 extents) to 6.91 TiB (1812468 extents).
  Logical volume vg0/lv_data successfully resized.
[root@cosmosia10 ~]# mkfs.ext4 /dev/vg0/lv_data
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done
Creating filesystem with 1855967232 4k blocks and 231997440 inodes
Filesystem UUID: f69451e0-5afd-4d3b-92a5-dc6b122cc3fd
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
	102400000, 214990848, 512000000, 550731776, 644972544

Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done

[root@cosmosia10 ~]# lvdisplay /dev/vg0/lv_data -m
  --- Logical volume ---
  LV Path                /dev/vg0/lv_data
  LV Name                lv_data
  VG Name                vg0
  LV UUID                VxVxMx-OhMa-0XDE-ozDR-lqtx-3h2g-0WOX9h
  LV Write Access        read/write
  LV Creation host, time cosmosia10, 2022-09-10 22:27:11 +0200
  LV Status              available
  # open                 0
  LV Size                6.91 TiB
  Current LE             1812468
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0

  --- Segments ---
  Logical extents 0 to 1812467:
    Type		striped
    Stripes		2
    Stripe size		4.00 KiB
    Stripe 0:
      Physical volume	/dev/nvme0n1p5
      Physical extents	0 to 906233
    Stripe 1:
      Physical volume	/dev/nvme1n1p1
      Physical extents	0 to 906233


[root@cosmosia10 ~]# mkdir -p /mnt/data
[root@cosmosia10 ~]# mount /dev/vg0/lv_data /mnt/data
[root@cosmosia10 ~]#
```