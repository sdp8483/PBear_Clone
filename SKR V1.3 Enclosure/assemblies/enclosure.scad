include <../settings/dimensions.scad>
use <../parts/enclosure_back.scad>
use <../parts/enclosure_front.scad>
use <../parts/extruder_clamp.scad>
use <../parts/y_clamp.scad>
use <../vitamins/skrV13.scad>
use <../vitamins/fan.scad>
use <../vitamins/fasteners.scad>

module enclosure() {
    // enclosure back
    enclosure_back();

    // SKR V1.3 PCB
    translate([x_clearance-4.1,0,7+2.5])skrV13();

    // enclosure front
    translate([0,pcb_w+y_clearance,wall_height+2])rotate([180,0,0])enclosure_front();

    // 80mm fan
    translate([((pcb_l+x_clearance)/2)+10,40,wall_height+2])fan_80mm();

    // enclosure screws
    translate([0,0,wall_height+2])plastic_screw();
    translate([0,pcb_w+y_clearance,wall_height+2])plastic_screw();
    translate([pcb_l+x_clearance,0,wall_height+2])plastic_screw();
    translate([pcb_l+x_clearance,pcb_w+y_clearance,wall_height+2])plastic_screw();

    // extruder clamp
    translate([-0.2,40,30])rotate([0,90,180])extruder_clamp();

    // y clamp
    translate([pcb_l+x_clearance-35,0,30])rotate([0,270,90])y_clamp();
}

enclosure();