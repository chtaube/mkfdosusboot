Boot FreeDOS from USB
======================

This is an attempt to write a shell script which creates an image file holding a minimal FreeDOS
installation. Writing this image file onto a USB flash drive should boot right into FreeDOS.
This could be used to update firmware, play old DOS games or whatever.

Please note that I already offer *prebuilt* images on
[my website](http://chtaube.eu/computers/freedos/bootable-usb/).
Just download and write one of those image files onto your USB flash drive
and it will boot right into FreeDOS.

This script tries to automate the rather complex steps involved in making a bootable image.
A description on how to manually generate an image file can be found
[here](http://chtaube.eu/computers/freedos/bootable-usb/image-generation-howto/).


Current dependencies
--------------------

These tools are required for the script to run:

* sh
* unzip (for unpacking FreeDOS distribution sets)
* awk
* kpartx (access partitions within image files)
* parted
* syslinux
* sudo (script needs root for mounting and unmounting)

Please note that this script does barely check for errors yet!

Goals (to be implemented)
-------------------------

* Be portable. Don't expect a specific shell. I want it to run on Linux, FreeBSD, MacOS X and maybe other operating systems which can run shell scripts (this means Windows will not be unsupported, sorry guys).
 * Problem: kpartx is only available on Linux platform. For FreeBSD, see mdconfig(8).
* Try to be user friendly.
* Fail gracefully. Unmount and clean up temporary files.
* Auto-download FreeDOS distribution from server if not found locally.

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
% ./mkfdosusboot -v
 ==> TODO: check_dependencies()
 ==> Creating temporary directories in /tmp/tmp.7uJSWbbnOZ …
 ==> Creating image file, 250M bytes…
250+0 records in
250+0 records out
262144000 bytes (262 MB) copied, 2.07355 s, 126 MB/s
 ==> Creating partition table…
WARNING: You are not superuser.  Watch out for permissions.
GNU Parted 3.2
Using /home/ct/freedos/usbootimg/usbimage-250M.img
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) unit %                                                           
(parted) mklabel msdos                                                    
(parted) mkpart primary fat16 0 100%                                      
(parted) set 1 boot on                                                    
(parted) q                                                                
 ==> kpartx returned 'add map loop0p1 (254:0): 0 509952 linear /dev/loop0 2048', using 'loop0p1'
 ==> Making filesystem on /dev/mapper/loop0p1
mkfs.fat 3.0.26 (2014-03-07)
unable to get drive geometry, using default 255/63
 ==> Installing syslinux…
 ==> Mounting image
 ==> Mounting FreeDOS ISO
 ==> Unzipping files to temporary location…
 ==> Copying files to image…
 ==> Copying chain.c32…
 ==> Copying files from overlay overlay…
 ==> Unmounting /tmp/tmp.7uJSWbbnOZ/iso
 ==> Unmounting /tmp/tmp.7uJSWbbnOZ/image
ioctl: LOOP_CLR_FD: No such device or address
 ==> Removing /tmp/tmp.7uJSWbbnOZ …
./mkfdosusboot -v  1.77s user 3.54s system 71% cpu 7.458 total
```

