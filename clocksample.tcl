#!/usr/local/bin/tclsh8.6
#
# $Id:$

puts "Clock test"
puts ""

set fmt "{%H hours %M minutes and %S seconds}"

set o [clock format [clock seconds] -format $fmt]

puts $o

puts ""


# End of File
