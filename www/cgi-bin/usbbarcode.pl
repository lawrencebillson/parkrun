#!/usr/bin/perl
# 
# Script to read barcodes from a USB HID
# Lawrence Billson, 2016

# what's the filename
$processid = $$;
$filename = "/www/files/usbbarcode-$processid.txt";


my %native = (
    "4",  "a",
    "5",  "b",
    "6",  "c",
    "7",  "d",
    "8",  "e",
    "9",  "f",
    "10",  "g",
    "11",  "h",
    "12",  "i",
    "13",  "j",
    "14",  "k",
    "15",  "l",
    "16",  "m",
    "17",  "n",
    "18",  "o",
    "19",  "p",
    "20",  "q",
    "21",  "r",
    "22",  "s",
    "23",  "t",
    "24",  "u",
    "25",  "v",
    "26",  "w",
    "27",  "x",
    "28",  "y",
    "29",  "z",

    "30",  "1",
    "31",  "2",
    "32",  "3",
    "33",  "4",
    "34",  "5",
    "35",  "6",
    "36",  "7",
    "37",  "8",
    "38",  "9",
    "39",  "0",
    "40",  "Newline",
);


open(FIN,"$ARGV[0]");

while ($a = getc(FIN)) {
	$raw = ord($a);

	if ($raw == 2) {
		$shift = 1;
		$raw = "";
		} 

	if ($raw == 40) {
		open(FOUT,">>$filename");



		# First job - work out the time
		($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

		# Fix up the year, add leading zeros to hours and minutes
		$min = sprintf("%02d", $min);
		$sec = sprintf("%02d", $sec);
		$year += 1900;		

		# 24 hour to 12 hour conversion
		if ($hour > 12) {
			$hour = $hour - 12;
			$pdate = "$mday/$mon/$year $hour:$min:$sec PM";
			}
		else {
			$pdate = "$mday/$mon/$year $hour:$min:$sec AM";
			}




		# If a line begins with an A, we stash it
		if ($build =~ /^A/) {
			if ($athelete) {
				# We've already got athelete data, dump the place
				print FOUT "$athelete,,$pdate\n";
				}
			$athelete = $build;
			}
		if ($build =~ /^P/) {
			# Is there athelete data?, if not, print some stuff
			print FOUT "$athelete,$build,$pdate\n";
			$athelete = "";
			}



		close(FOUT);
		$build = "";
		$raw = "";
		}


	if ($raw) { 
		if ($shift) {
			$upper = uc($native{$raw});
			$shift = 0;
			$build = $build . $upper
			}
		else {
			$build = $build . $native{$raw}
			}

		}

}
