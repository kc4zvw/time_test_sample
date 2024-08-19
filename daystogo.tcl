#!/usr/local/bin/tclsh8.6
#
# ******************************************************************
# ***
# ***   Author: David Billsbrough 
# ***  Created: Sunday, August 18, 2024 at 18:22:44 PM (EDT)
# ***  License: GNU General Public License -- version 2
# ***  Version: $Revision: 0.6 $
# *** Warranty: None
# ***  Purpose: Calculate the difference in days between two dates
# ***
# ******************************************************************  
#
# $Id: daystogo.tcl,v 0.6 2024/08/19 18:45:08 kc4zvw Exp kc4zvw $


# Setup global variables and constants

global calendar_file ".calendar"
global os_sep "/"

set spaces ".........." 
global event_date [eval string repeat $spaces 2]
global event_name [eval string repeat $spaces 6]

global Answer(msg) [eval string repeat $spaces 8]
global dayCount 0

# ------------------------------

proc as-days { secs } {
	return truncate (secs / 86400)
}

proc date-to-secs { str } {
	return mktime (strptime "%Y/%m/%d" str)
}

proc formattedDate { d } {
	set my_date ""
	set my_date [string cat d.wday d.mon d.day d.year]

	return $my_date
}

# ------------------------------

proc get_home_dir {} {

	set myHOME $::env(HOME)
	puts [format "My \$HOME directory is %s.\n" $myHOME]

	return $myHOME
}

proc process_line { eventDate eventName } {
	set answer [append "" $eventDate ":" $eventName]
	#puts [format "Result: %s \n" $answer]
	set dayCount [calc-dates ($eventDate $eventName)]
	output-display ($dayCount $eventName)
}

proc output-display { dayCount eventName } {

	set b [string range $dayCount 1 end]
	set c [string range $eventName 0 end-2]
	set daycount2 [expr {abs($b)}]
	set dayCount $b
	set eventName $c

	#puts "$dayCount"
	#puts "$eventName"

	if { $dayCount <= -2 } {
		puts [format "It was %d days ago since %s." $daycount2 $eventName]
	} elseif { $dayCount == -1 } {
		puts [format "Yesterday was %s." $eventName]
	} elseif	{ $dayCount == 0 } {
		puts [format "Today is %s." $eventName]
	} elseif	{ $dayCount == 1 } {
		puts [format "Tomorrow is %s." $eventName]
	} elseif	{ $dayCount >= 2 } {
		puts [format "There are %d days until %s." $dayCount $eventName]
	} else {
		puts [format "No Match for %s.\n" $eventName]
	}
}


# ------------------------------

### set Zone eval (0500 +1)			#-- not used now

### proc date-target (as-days target))
### proc date-today (as-days Now))


proc diff { num1 num2 } {
	incr num1
	incr num2

	set ans [expr { $num2 - $num1 }]
	incr ans

	return $ans
}

proc calc-dates { Date0 eventName } {

	set fmt1 "%s"
	set fmt2 "%D"
	set fmt3 "%Y/%m/%d"

	#puts "Received: $Date0"
	set Tgt [string range $Date0 2 end-1]
	#puts "Changed to: $Tgt"

	set Target [clock scan $Tgt -format $fmt3]
	set Now [clock seconds]
	set Today [clock format $Now -format $fmt1]

	#puts [format "var Now is %s" $Now]
	#puts [format "var Today is %s" $Today]
	#puts [format "var Target is %s" $Target]

	set n1 [expr {$Today / 86400}]
	set n2 [expr {$Target / 86400}]

	set deltaDays 0
	set numDays1 $n1
	set numDays2 $n2
	set deltaDays [expr { $n2 - $n1 }]

	return $deltaDays
}

# --------------------

proc display_banner {} {

	set fmt1 "%A, %B %d, %y at %H:%M:%S (%Z)"
	set fmt2 "  Today's date is %s.\n"
	set dashes [eval string repeat = 60]

	set Now [clock seconds]
	set Today [clock format $Now -format $fmt1]

	puts $dashes
	puts ""
	puts [format $fmt2 $Today]
	puts $dashes
	puts ""
}

proc build_path_name {} {

	set myhome [get_home_dir]
	set sep "/"
	set calendar_file ".calendar"
	set path_name $myhome$sep$calendar_file

	set fmt "Filename: %s\n"
	puts [format $fmt $path_name]

	return $path_name
}

##  Notes: ((getenv "HOME") or "/home/kc4zvw") sep ".calendar"))

# Open text file for reading

proc withOpenFile {filename channelVar script} {

    upvar 1 $channelVar chan
    set chan [open $filename]
    catch {
        uplevel 1 $script
    } result options
    close $chan
    return -options $options $result
}

##  Notes:  set infile [open $calendarFile {RDONLY EXCL}] 
#			puts format ["Couldn't open %s for reading dates.\n"] calendar-file
#			exit 2 


# --------------------- 

# do main loop though the calendar file

proc first-loop {} {

	set filename [build_path_name]

	set f [open $filename "r"]
	
	while {1} {
		set line [gets $f]

		if {[eof $f]} {
			#close $f
			break
		}
		#puts "Read line: $line"

		#puts [format "line: %s\n" $line]

		set part1 [string range $line 0 9]
		set part2 [string range $line 11 end]

		#puts "part1: $part1"
		#puts "part2: $part2"

		upvar eventdate event_date
		upvar eventname event_name

		set eventdate $part1
		set eventname $part2

		# process the line
		process_line ($part1 $part2)
	}
	close $f
}

proc search_for_comments {} {

	#	let ((m (string-match "^[ \t]*#" line)))
	#	if m (format #t "comment: ~a\n" line)))
}

proc main_routine {} {
	display_banner
	first-loop
}


#  ***----------------------------------***
#  **     Main program begins here       ** 
#  ***----------------------------------***

main_routine

puts ""
puts "End of report"

# vim: syntax=tcl tabstop=3 nowrap :

# End of script
