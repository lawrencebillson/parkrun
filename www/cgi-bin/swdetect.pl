#!/usr/bin/perl

# A script that looks for barcode scanners, executes and kills monitoring processes
# Modified again - parkrunPortable 1.6 - detects pl2303 devices and kicks off the stopwatch download
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
			system("/www/cgi-bin/usbbarcode.pl $dev &");
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

	# While we're at it, let's see if we've got stopwatch
        $usbstat = `ls /dev/ttyUSB*`;                                                                                          
        if (($usbstat =~ ttyUSB0) && (!($usbstat =~ ttyUSB1))) {                                                               
                # We only have a single USB device, check that it's a pl2303                                                   
                $driver = `dmesg | grep ttyUSB0 | tail -1`;                                                                    
                }                                                                                                              
               
	                                                                                                                
        if ($driver =~ /pl2303/) {                                                                                             
		# Are we already running?
        	$bgps = `ps | grep bgstopwatch | grep -v grep`;      
	        chomp($bgps);                                         
	        if (!($bgps =~ /perl/)) {     
			# We're not already running
                	`sh -c /www/cgi-bin/bgstopwatch.sh`;                                                                           
			}
                }                                        


	$driver = "";


	sleep 1;
	}


