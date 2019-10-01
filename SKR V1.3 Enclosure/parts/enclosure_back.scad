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

module nut_slot() {
    union() {
        translate([-(5.55/2),(28/2)-(5.55/2)-1,(9/2)+10-2.5]) {
            translate([0,0,0.75])cube([2,5.55,12], center=true);
            translate([0,0,(-10/2)+(5.55/2)])rotate([0,270,0])cylinder(h=25,d=m3_clearance_dia, center=true);
        }
    }
}

module extruder_cable_holder() {
    difference() {
        // base shape
        union() {
            cylinder(h=12,d=28);
            translate([0,0,12])cylinder(h=4, d1=28, d2=15);

            mirror([0,0,1])cylinder(h=4,d1=24,d2=15);
        }

        // cable hole
        translate([0,0,-5])cylinder(h=25, d=12);

        // Square M3 Nut Slots
        nut_slot();
        mirror([0,1,0])nut_slot();

        // Split in half
        translate([0,-20,-0.1])cube([20,40,40]);
        translate([0,-4,-6])cube([20,8,20]);
        translate([8,-10,-10])cube([10,20,20]);

        // Hole for 3mm nylon
        translate([-2,-11,-5])rotate([315,0,0])cylinder(h=20, d=3);
    }

    // overhang print support
    mirror([1,0,0]) {
        translate([(28/2)-0.5,3,3])rotate([90,0,0]) {
            linear_extrude(height=6){
                polygon([[0,0], [9,0], [0,9]]);
            }
        }
    }
}

module y_cable_holder() {
    difference() {
        //main body
        union() {
            cylinder(h=12, d=28);
            translate([0,0,12])cylinder(h=4, d1=28, d2=15);
            translate([0,0,-1])cylinder(h=1,d=30);
            translate([0,0,-5])cylinder(h=4, d1=20, d2=30);
        }

        // Split
        translate([0,-20,-20])cube([40,40,40]);

        // 8mm cable hole
        rotate([315,0,0])translate([0,-3,-20])cylinder(h=40, d=8);

        // nut slots
        mirror([0,1,0])translate([-1,-1,0])nut_slot();
        translate([-1,-1,12])mirror([0,0,1])nut_slot();
    }
}

module cable_tie_anchors() {
    difference() {
        // main body
        translate([0,2.5,0]) {
            rotate([90,0,0])linear_extrude(height=5)polygon([[0,-2.5],[3,-0.5],[3,2],[0,3]]);
        }

        // tie holes
        translate([0.5,-1.5,0])cube([1.5,3,5]);
        translate([0.5,-1.5,0])cube([10,3,1.5]);
    }
}

module enclosure_body() {
    union() {
        difference() {
            union() {
                cube([pcb_l+x_clearance,pcb_w+y_clearance,7]);

                // upper mount
                translate([20-4,pcb_w+y_clearance,0]) {
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

    // add extruder cable grip
    translate([-0.2,40,30]){
        rotate([0,270,0])extruder_cable_holder();
    }

    // top wall
    difference() {
        translate([-4,0,0])cube([4,pcb_w+y_clearance,wall_height]);
        translate([-5,40-(16/2),22])cube([6,16,20]);
        translate([-8,40-(20/2),22])cube([6,20,20]);
    }

    // bottom wall
    translate([pcb_l+x_clearance,0,0])cube([4,pcb_w+y_clearance,wall_height]);

    // add y cable grip
    translate([pcb_l+x_clearance-35,0,30])rotate([0,270,90])y_cable_holder();

    // USB/uSD side wall
    difference() {
        translate([-4,-4,0])cube([pcb_l+x_clearance+4+4,4,wall_height]);

        // cuts for cable grip
        translate([pcb_l+x_clearance-35-(28/2),-5,30])cube([28,6,10]);
        translate([pcb_l+x_clearance-35-(24/2),-5,25])cube([24,6,10]);

        // cuts for USB/uSD
        translate([x_clearance-3.91+24.11-2,-5,9.5])cube([36.09-24.11+4,6,14]);
        translate([x_clearance-3.91+42.46-2,-5,9.5])cube([57.49-42.46+4,6,5]);
    }

    // stepper driver side wall
    translate([-4,pcb_w+y_clearance,0])cube([pcb_l+x_clearance+4+4,4,wall_height]);

    // upper wall cable tie anchors
    translate([0,20,25])cable_tie_anchors();
    translate([0,70,25])cable_tie_anchors();
    // stepper driver wall cable tie anchors
    for (i=[20:30:pcb_l+x_clearance-20]) {
        translate([i,pcb_w+y_clearance,25])rotate(270)cable_tie_anchors();
    }
    // usb wall cable tie anchors
    for (i=[36:30:pcb_l+x_clearance]) {
        translate([i,0,25])rotate(90)cable_tie_anchors();
    }
    /*// bottom wall cable tie anchors
    for (i=[15:30:pcb_w+y_clearance]) {
        translate([pcb_l+x_clearance,i,25])rotate(180)cable_tie_anchors();
    }*/
    // base cable tie anchors
    for (i=[10:30:pcb_w+y_clearance]) {
        translate([x_clearance/2,i,8])rotate([0,270,0])cable_tie_anchors();
    }
}

module enclosure_chamfered() {
    difference() {
        enclosure_body();

        // top wall chamfer
        translate([0,45,wall_height+6])rotate([0,45,0])cube([5,100,20],center=true);

        // bottom wall chamfer
        translate([pcb_l+x_clearance,45,wall_height+6])rotate([0,315,0])cube([5,100,20],center=true);

        // usb wall chamfer
        translate([45,0,wall_height+6])rotate([315,0,0])cube([200,5,20],center=true);

        // stepper driver wall chamfer
        translate([45,pcb_w+y_clearance,wall_height+6])rotate([45,0,0])cube([200,5,20],center=true);

    }

}

module enclosure_back() {
    difference() {
        union() {
            enclosure_chamfered();

            // Screw supports
            for (x=[0,pcb_l+x_clearance]) {
                for (y=[0,pcb_w+y_clearance]) {
                    translate([x,y,wall_height-21-3])cylinder(h=21, d=6);
                    translate([x,y,wall_height-21-3])sphere(d=6);
                }
            }
        }

        // Power cable, yaxis/ zaxis entry
        translate([pcb_l+x_clearance-1,10,20])cube([8,pcb_w+y_clearance-20,30]);

        // Lid Screw Holes
        translate([0,0,wall_height-20])cylinder(h=21, d=3);
        translate([pcb_l+x_clearance,0,wall_height-20])cylinder(h=21, d=3);
        translate([0,pcb_w+y_clearance,wall_height-20])cylinder(h=21, d=3);
        translate([pcb_l+x_clearance,pcb_w+y_clearance,wall_height-20])cylinder(h=21, d=3);
    }

}

enclosure_back();