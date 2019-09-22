include <../settings/dimensions.scad>
use <../settings/mods.scad>

module single_extrusion_rail_mount(bolt_hole) {
    union() {
        difference() {
            union() {
                cube([7,26.49,20]);

                // extrusion inset locator
                translate([7,12.77,0]){
                    linear_extrude(height=20){
                        polygon([[0,0],[0.22,0],[1.4,1.17],[1.4,7.27],[0.22,8.45],[0,8.45]]);
                    }
                }
            }

            // bolt hole
            if (bolt_hole == 1) {
                translate([-1,16.925,10]) {
                    rotate([0,90,0]) {
                        cylinder(h=10, d=5.3);  // bolt through hole
                        cylinder(h=2, d=9.2);   // head counter sink
                    }
                }
            }

            // cut corners
            translate([4,26.49,20]) {
                rotate([45,0,0]) {
                    cube([10,4,4], center=true);
                }
            }
            translate([4,26.49,0]) {
                rotate([45,0,0]) {
                    cube([10,4,4], center=true);
                }
            }
        }

        // thin layer to bridge countersink
        if (bolt_hole == 1) {
            translate([1,16.925,10]) {
                rotate([0,90,0]) {
                    cylinder(h=0.2, d=10);   // head counter sink
                }
            }
        }
    }
}

module extrusion_rail_mount() {
    difference() {
        union() {
            single_extrusion_rail_mount(bolt_hole=1);
            mirror([0,1,0])rotate(270)single_extrusion_rail_mount(bolt_hole=0);
        }
        // corner notch
        translate([6.9,6.9,-1]) {
            rotate(45) {
                linear_extrude(height=22){
                    polygon([[0,0],[(0.63/2)/tan(30),0.63/2],[(0.63/2)/tan(30),-0.63/2]]);
                }
            }
        }
    }
}

module enclosure_back() {
    union() {
        difference() {
            union() {
                cube([pcb_l+x_clearance,pcb_w+y_clearance,7]);

                // upper mount
                translate([20,pcb_w+y_clearance,0]) {
                    rotate([0,270,0]) {
                        extrusion_rail_mount();
                    }
                }

                // lower mount
                translate([pcb_l+x_clearance,pcb_w+y_clearance,0]) {
                    rotate([0,270,0]) {
                        extrusion_rail_mount();
                    }
                }

                // PCB standoffs
                for (pos=pcb_mnt_pattern) {
                    translate([pos.x+x_clearance,pos.y+((pcb_w-hole_y_spacing)/2),7])cylinder(h=2.5,d=6);
                }
            }

            // PCB mount holes
            for (pos=pcb_mnt_pattern) {
                translate([pos.x+x_clearance,pos.y+((pcb_w-hole_y_spacing)/2),-1])cylinder(h=12,d=m3_clearance_dia);
            }

            // M3 hex nut inserts
            for (pos=pcb_mnt_pattern) {
                translate([pos.x+x_clearance,pos.y+((pcb_w-hole_y_spacing)/2),-1])cylinder_outer(height=5,radius=5.5/2,fn=6);
                translate([pos.x+x_clearance,pos.y+((pcb_w-hole_y_spacing)/2),-1])cylinder_outer(height=2,radius=5.7/2,fn=6);
            }
        }

        // thin layer to bridge hex nut insets
        for (pos=pcb_mnt_pattern) {
            translate([pos.x+x_clearance,pos.y+((pcb_w-hole_y_spacing)/2),4])cylinder(h=0.2,d=6);
        }
    }
}

enclosure_back();