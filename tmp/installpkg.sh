#!/bin/sh 

echo 111 parkrun portable automatic installer - Lawrence Billson
echo 111 Installing packages from the Internet
opkg update
opkg install unzip
opkg install perl-www
opkg install kmod-usb-serial-pl2303
opkg install python-pyserial
opkg install python-codecs
opkg install uhttpd
opkg install kmod-usb-storage block-mount block-hotplug kmod-fs-ext4 kmod-fs-vfat kmod-nls-cp437 kmod-nls-iso8859-1
#
echo 111 Downloading parkrun portable software from GitHub
wget --no-check-certificate -qO- http://github.com/lawrencebillson/parkrun/archive/master.tar.gz | (cd /tmp ; tar -xvzf -)
# 
echo 111 Installing the Opticon barcode drvier
opkg install -nodeps /tmp/parkrun-master/tmp/kmod-usb-serial-opticon_3.18.23-1_ramips_24kec.ipk
# 
echo 111 Copying the portable parkrun software into its final location
cd /tmp/parkrun-master ; tar -cf - . | (cd / ; tar -xvf -)
echo 111 Done - Rebooting in 20 seconds
sleep 20
reboot


