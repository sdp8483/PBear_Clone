include <../settings/dimensions.scad>

module m3_bolt_hole() {
    translate([-(5.55/2),(28/2)-(5.55/2)-1,(-10/2)+(5.55/2)+((9/2)+10-2.5)]) {
        rotate([0,270,0]) {
            cylinder(h=25,d=m3_clearance_dia, center=true);
            hull() {
                cylinder(h=10, d=5.75);
                translate([-5.75/2, 9, 0])cube([1,1,10]);
                translate([9, -5.75/2, 0])cube([1,1,10]);
                translate([9, 9, 0])cube([1,1,10]);
            }
        }
    }
}

module extruder_clamp() {
    difference() {
        union() {
            // base shape
            difference() {
                union() {
                    cylinder(h=12,d=28);
                    translate([0,0,12])cylinder(h=4, d1=28, d2=15);
                }

                // cut some of the bottom off
                translate([-20,-20,-1])cube([21,40,5]);
            }
            
            // inset 
            translate([-15,-15.5/2,0.2])cube([15,15.5,4.5]);
            translate([-15,-19.5/2,2])cube([15,19.5,2]);
        }

        // cable hole
        translate([0,0,-5])cylinder(h=25, d=12);

        // m3 bolt holes
        m3_bolt_hole();
        mirror([0,1,0])m3_bolt_hole();

        // Split in half
        translate([0,-20,-0.1])cube([20,40,40]);

        // cut off some of the back
        translate([-27.8,-20,-1])cube([20,40,20]);

        // clean up around coutersink
        translate([-14.5,-19,7.2])cube([10,10,10]);
    }

    // cable ribbing for grip
    for (z=[6:3:12]) {
        translate([-6,-6,z])cube([1.5,12,1]);
    }
}

extruder_clamp();