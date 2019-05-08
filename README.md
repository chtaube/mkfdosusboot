FreeDOS image file generator script
===================================

This is an attempt to write a shell script which creates an image file holding a minimal FreeDOS
installation. Writing this image file onto a USB flash drive should boot right into FreeDOS.
This could be used to update firmware, play old DOS games or whatever.

This script tries to automate the rather complex steps involved in making a bootable image.


Current dependencies
--------------------

These tools are required for the script to run:

* /bin/sh (tested with dash on Debian 9.2)
* unzip (for unpacking FreeDOS distribution sets)
* awk
* kpartx (access partitions within image files)
* parted
* syslinux
* sudo (script needs root for mounting and unmounting)

Please note that this script barely checks for errors yet!


Goals (to be implemented)
-------------------------

* Be portable. Don't expect a specific shell. While I wrote this for my Debian system, it should work on other Linux distributions, too. I'd llove to add support for FreeBSD but there are still some tools missing.
 * Problem: kpartx is only available on Linux platform. For FreeBSD, see mdconfig(8).
* Try to be user friendly.
* Fail gracefully. Unmount and clean up temporary files.
* Auto-download FreeDOS distribution from server if not found locally.
 * Maybe drop iso support and just look for the required FreeDOS base package.
* Include FDNPKG package manager.


Bugs
----

A lot!

This script is still in an very early state and definitely not yet ready for an average user.

* No checking is done whether required tools are installed.
* Won't run on anything else than Linux (tested on Arch Linux and Debian).
* For ODIN boot disks to work, we need `img/memdisk`.

And finally: It's badly written code! I am using this to learn writing *good and portable* shell scripts.


Screenshot
----------


```
 ==> OS: Linux
 ==> Creating temporary directories in /tmp/tmp.8wQrfGw9UE ...
 ==> Creating image file, 500M bytes...
500+0 records in
500+0 records out
524288000 bytes (524 MB, 500 MiB) copied, 0.322425 s, 1.6 GB/s
 ==> Running parted to create partition table...
WARNING: You are not superuser.  Watch out for permissions.
GNU Parted 3.2
Using /home/chtaube/freedos/mkfdosusboot/usbimage-500M.img
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) unit %
(parted) mklabel msdos
(parted) mkpart primary fat16 0 100%
(parted) set 1 boot on
(parted) q
 ==> kpartx returned 'add map loop0p1 (253:21): 0 1021952 linear 7:0 2048', using '/dev/mapper/loop0p1'
 ==> Making filesystem on /dev/mapper/loop0p1
mkfs.fat 4.1 (2017-01-24)
 ==> Installing syslinux...
 ==> Mounting image 'sudo mount -o uid=1000 ...'
 ==> Creating directory structure on image...
 ==> Mounting FreeDOS ISO
 ==> Unzipping files to temporary location...
 ==> Copying FreeDOS files to image...
 ==> Copying syslinux modules...
 ==> Copying files from overlay overlay...
 ==> Cleaning up...
loop deleted : /dev/loop0
```

Hints
-----

* Add a symlink from `overlay/boot/FD12CD.iso` pointing to your FreeDOS 1.2 distribution ISO. The ISO-image will be included on the USB stick and, upon boot, the contents is available as a virtual CD-ROM drive within FreeDOS.
* The syslinux bootloader is preconfigured to boot Odin 0.6 and 0.7 boot images. Just put the image files into `overlay/boot/fdodin06.144` (from [Odin 0.6](http://odin.fdos.org/)) or `overlay/boot/odin2880.img` (from [Odin 0.7](http://odin.fdos.org/odin2005/)) and run the script.
* Boot menu items for [Memtest86+](http://www.memtest.org/) and [Hardware Detection Tool](http://hdt-project.org/) have been added. For Memtest86+, download the "Pre-Compiled package for Floppy (DOS - Win)", unzip the file and copy `memtestp.bin` to `overlay/boot/memtestp` (remove the .bin extension).

