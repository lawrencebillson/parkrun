#!/usr/bin/perl

# A script that looks for barcode scanners, executes and kills monitoring processes
# 

while (1) {
	# Get a list of HID event files in /dev
	@hiddevs = `ls /dev/hidraw* 2> /dev/null`;

	
	# Clear out the 'thisround' values
	foreach $clearkey (sort keys %known) {
		$thisround{$clearkey} = 0;
		}


	# Process our list - determine if we've got any new devices
	foreach $dev (@hiddevs) {
		chomp($dev);	
		# If we didn't know about it - let's report it	
		if (!$known{$dev}) {
			system("echo ./usbbarcode.pl $dev &");
			system("./usbbarcode.pl $dev &");
			$known{$dev} = $dev;
			}
		$thisround{$dev} = 1;
		}

	# Compare the 'known' with the 'thisround' values - are we missing any
	foreach $findkey (sort keys %known) {
		if (!($thisround{$findkey})) {
			print "REMOVED!!! $findkey has been removed\n";
			delete $known{$findkey};
			}
		}

	sleep 1;
	}


