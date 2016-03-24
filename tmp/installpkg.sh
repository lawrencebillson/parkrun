#!/bin/sh 

echo *** parkrun portable automatic installer - Lawrence Billson
echo *** Installing packages from the Internet
opkg update
opkg install unzip
opkg install perl-cgi
opkg install kmod-usb-serial-pl2303
opkg install python-pyserial
opkg install python-codecs
opkg install uhttpd
opkg install kmod-usb-storage block-mount block-hotplug kmod-fs-ext4 kmod-fs-vfat kmod-nls-cp437 kmod-nls-iso8859-1
#
echo *** Downloading parkrun portable software from GitHub
wget -qO- http://github.com/lawrencebillson/parkrun/archive/master.tar.gz | (cd /tmp ; tar -xvzf -)
# 
echo *** Installing the Opticon barcode drvier
opkg install /tmp/parkrun-master/tmp/kmod-usb-serial-opticon_3.18.23-1_ramips_24kec.ipk
# 
echo *** Copying the portable parkrun software into its final location
cd /tmp/parkrun-master ; tar -cf - . | (cd /home/lawrence/target ; tar -xvf -)
echo *** Done - Rebooting in 20 seconds
sleep 20
reboot


