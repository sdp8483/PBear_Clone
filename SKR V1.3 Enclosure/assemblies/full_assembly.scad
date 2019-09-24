include <../settings/dimensions.scad>
use <enclosure.scad>
use <pb_frame.scad>

pb_frame();

translate([12,47,200])rotate([0,90,270])enclosure();