include <../settings/dimensions.scad>
use <enclosure.scad>
use <pb_frame.scad>

pb_frame();

translate([15-y_clearance,47,200])rotate([0,90,270])enclosure();

// X stepper movment zone
color("Red", alpha=0.5) {
    translate([106-12,-42-5,0])cube([37,42,359+20]);
}