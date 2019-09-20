include <../settings/dimensions.scad>

case_height = 45;
wall_thickness = 2;

module main_body() {
    // base
    cube([pcb_l+5, pcb_w+5, wall_thickness]);

    // sides
    cube([pcb_l+5,wall_thickness,case_height]);
    translate([0,pcb_w+5-wall_thickness,0])cube([pcb_l+5,wall_thickness,case_height]);
    cube([wall_thickness,pcb_w+5,case_height]);
    translate([pcb_l+5-wall_thickness,0,0])cube([wall_thickness,pcb_w+5,case_height]);

    // USB puchout
    translate([-usb_x,0,wall_thickness+4])cube([8.45,7.78,wall_thickness+2]);

}

main_body();