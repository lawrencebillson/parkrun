#!/usr/bin/perl
# Script to generate ParkRun datafiles for upload
# Lawrence Billson, 2015, Creative Commons license
# 
# Reset the USB modules
system("killall -9 python");
system("rmmod -f opticon; rmmod -f usbserial");
system("modprobe opticon");
#


# Barcode routine 
# Need to generate a date stamp for our barcode file
#$time = time();
$time = `date +%a-%b-%d-%H:%M:%S.txt`;
$barcodefile = "/www/files/parkrun_barcode_$time";
open(BARCODEFILE,">$barcodefile");


@data =  `/www/cgi-bin/cs1504.py`;
foreach $line (@data) {
	chomp($line);
	($code, $data, $date)  = split(',',$line);

	# Convert the date into some AM / PM times, match the regular format
	($dateline,$timeline) = split(' ',$date);
	($year,$mon,$day) = split('-',$dateline);
	($hour,$min,$sec) = split(':',$timeline);
	# Need to remove the leading zero from the hour
	$thour = 0 + $hour;
	
	# 24 hour to 12 hour conversion
	if ($hour > 12) {
		$hour = $hour - 12;
		$pdate = "$day/$mon/$year $thour:$min:$sec PM";
		}

	else {
		$pdate = "$day/$mon/$year $thour:$min:$sec AM";
		}

	
	# If a line begins with an A, we stash it
	if ($data =~ /^A/) {
		if ($athelete) {
			# We've already got athelete data, dump the place
			print BARCODEFILE "$athelete,,$pdate\n";
			}
		$athelete = $data;
		}
	if ($data =~ /^P/) {
		# Is there athelete data?, if not, print some stuff
		print BARCODEFILE "$athelete,$data,$pdate\n";
		$athelete = "";
		}
	}
close(BARCODEFILE);

# delete any zero length files left behind
`find /www/files/ -size 0 -type f -exec rm {} \\; > /tmp/rm 2>&1`;


exit(0);

