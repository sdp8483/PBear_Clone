include <../settings/dimensions.scad>

module pcb() {
    color("Green") {
        difference() {
            translate([0,0,pcb_t/2])cube([pcb_l, pcb_w, pcb_t], center=true); // PCB

            for (x_quad=[1,-1]) {
                for (y_quad=[1,-1]) {
                    translate([x_quad*hole_x_spacing/2,y_quad*hole_y_spacing/2,-1])cylinder(h=pcb_t+2, d=hole_dia); // Holes
                }
            }
        }
    }
}

pcb();