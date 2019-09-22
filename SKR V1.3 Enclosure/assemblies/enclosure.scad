include <../settings/dimensions.scad>
use <../parts/enclosure_back.scad>
use <../vitamins/skrV13.scad>


enclosure_back();
translate([x_clearance-4.1,0,7])skrV13();