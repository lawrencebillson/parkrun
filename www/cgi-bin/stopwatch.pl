#!/usr/bin/perl
# Script to generate ParkRun datafiles for upload
# Lawrence Billson, 2015, Creative Commons license
#

# We should kill any other python sessions
system('killall -9 python 2> /dev/null');

print "Upload data from the stopwatch now\n";
$datain = `/www/cgi-bin/readserial.py`;
print "Got the data\n";


# Open a data file, print a headder
#$time = time();
# make it human readable
$time = `date +%a-%b-%d-%H:%M:%S_junsd_stopwatch.txt`;
$file = "/www/files/parkrun_timer\_$time";
open(BARCODEFILE,">$file");


$bogus = "02/07/2001";
open(FOUT,"> $file");
print FOUT "STARTOFEVENT,$bogus 00:00:00,junsd_stopwatch\n0,$bogus 00:00:00\n";



# We've now got the binary data, in an encoded hex form, from the stop watch
# We need now to split it into 2 byte blocks

# The frames are 16 hex bytes long (i.e. 2 real bytes)
$bytes = 16;

# Remove the first six bytes - it's crap
$frag = substr $datain, 6;
@groups = ( $frag =~ /.{1,$bytes}/gs );
foreach $pair (@groups) {
	# Each of these 'pairs' is a data record from the stopwatch

	# The format is
	# 4 bytes - the message code
	# 12 bytes - other info
	$code = substr $pair,0,4;

	if ($code eq "abc3") {
		# This is a laptime frame

		$pla = substr $pair,5,3;
		$place = 0 + $pla;	
			
		$hour = substr $pair,8,2;
		$min = substr $pair,10,2;
		$sec = substr $pair,12,2;
		$dsec = substr $pair,14,2;

		# Round up if they're closer to a second break
		if ($dsec > 50) {
			$sec++;
			}

		# Bug - the above round up could make the seconds = 60 (illegal, need to increment the minute)
		if ($sec == 60) {
			$min++;
			$sec="00";
			}

		# Have we rounded up over an hour?
		if ($min == 60) {
			$hour++;
			$min="00";
			}

		print "$place  time is $hour:$min:$sec --- $pair\n";
		print FOUT "$place,$bogus $hour:$min:$sec,$hour:$min:$sec\n";
		$place++;
		}		
		

	}

# Fake stop time
$min++;
print FOUT "ENDOFEVENT,$bogus $hour:$min:$sec\n";
close(FOUT);
