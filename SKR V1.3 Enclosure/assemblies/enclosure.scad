include <../settings/dimensions.scad>
use <../parts/enclosure_back.scad>
use <../parts/enclosure_front.scad>
use <../vitamins/skrV13.scad>
use <../vitamins/fan.scad>

module enclosure() {
    enclosure_chamfered();
    translate([x_clearance-4.1,0,7+2.5])skrV13();

    translate([0,pcb_w+y_clearance,wall_height+2])rotate([180,0,0])enclosure_front();

    translate([((pcb_l+x_clearance)/2),40,wall_height+2])fan_80mm();
}

enclosure();