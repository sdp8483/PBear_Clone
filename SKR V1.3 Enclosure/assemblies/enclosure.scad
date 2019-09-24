include <../settings/dimensions.scad>
use <../parts/enclosure_back.scad>
use <../vitamins/skrV13.scad>

module enclosure() {
    enclosure_chamfered();
    translate([x_clearance-4.1,0,7+2.5])skrV13();
}

enclosure();