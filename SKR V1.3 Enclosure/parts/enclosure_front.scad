include <../settings/dimensions.scad>
use <../settings/mods.scad>
use <../vitamins/fan.scad>
use <../vitamins/fasteners.scad> // for preview

module enclosure_front() {
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
        translate([((pcb_l+x_clearance)/2),(pcb_w+y_clearance)-40,-1]){
            fancut_80mm(depth=6);
        }
    }

    translate([-4,-4,0])cube([pcb_l+x_clearance+8,4,2]);
    translate([-4,pcb_w+y_clearance,0])cube([pcb_l+x_clearance+8,4,2]);
    translate([-4,0,0])cube([4,pcb_w+y_clearance,2]);
    translate([pcb_l+x_clearance,0,0])cube([4,pcb_w+y_clearance,2]);
}

enclosure_front();