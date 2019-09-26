include <../settings/dimensions.scad>
use <../settings/mods.scad>
use <../vitamins/fan.scad>
use <../vitamins/fasteners.scad> // for preview

module enclosure_front() {
    difference() {
        union() {
            difference() {
                // lid inset
                cube([pcb_l+x_clearance,pcb_w+y_clearance,4]);

                // chamfer
                t = 2;
                chamfer_h = 3;
                translate([0,0,((t/2)/cos(45)) + chamfer_h])rotate([0,45,0])cube([t,400,6],center=true);
                translate([pcb_l+x_clearance,0,((t/2)/cos(45)) + chamfer_h])rotate([0,315,0])cube([t,400,6],center=true);

                translate([0,0,((t/2)/cos(45)) + chamfer_h])rotate([0,45,90])cube([t,400,6],center=true);
                translate([0,pcb_w+y_clearance,((t/2)/cos(45)) + chamfer_h])rotate([0,315,90])cube([t,400,6],center=true);

                // Fan holes
                translate([((pcb_l+x_clearance)/2)+10,(pcb_w+y_clearance)-40,-1]){
                    fancut_80mm(depth=6);
                }

                // X axis cable entry
                //translate([125,(8.5/2)+1,-1])cylinder(h=6, d=8.5, $fn=8);

                // Vents
                for (i=[5:5:80]) {
                    translate([5,i,-1])cube([30,3,10]);
                }
                translate([3,3,1.8])cube([34,82,5]);

            }

            // Vent horizontal support bar
            translate([20,3,1])cube([3,82,1.8]);

            // Edges
            translate([-4,-4,0])cube([pcb_l+x_clearance+8,4,2]);
            translate([-4,pcb_w+y_clearance,0])cube([pcb_l+x_clearance+8,4,2]);
            translate([-4,0,0])cube([4,pcb_w+y_clearance,2]);
            translate([pcb_l+x_clearance,0,0])cube([4,pcb_w+y_clearance,2]);
        }

            // Lid Screw Holes
        translate([0,0,-1])cylinder(h=21, d=4);
        translate([pcb_l+x_clearance,0,-1])cylinder(h=21, d=4);
        translate([0,pcb_w+y_clearance,-1])cylinder(h=21, d=4);
        translate([pcb_l+x_clearance,pcb_w+y_clearance,-1])cylinder(h=21, d=4);
    }
}

enclosure_front();