#!/usr/bin/env tclsh8.6
#
# $Id:$

set gvar "abc"

proc justTest {} {
    global gvar
    puts $gvar
}

justTest
