include <../settings/dimensions.scad>

module m3_bolt_hole() {
    translate([-(5.55/2),(28/2)-(5.55/2)-1,(-10/2)+(5.55/2)+((9/2)+10-2.5)]) {
        rotate([0,270,0])cylinder(h=25,d=m3_clearance_dia, center=true);
        rotate([0,270,0])cylinder(h=10, d=5.75);
    }
}
module y_clamp() {
    mirror([1,0,0]) {
        difference() {
            //main body
            union() {
                cylinder(h=12, d=28);
                translate([0,0,12])cylinder(h=4, d1=28, d2=15);
                translate([-10,-27.5/2,0])cube([10,27.5,6]);
            }

            // Split
            translate([0,-20,-20])cube([40,40,40]);

            // 8mm cable hole
            rotate([315,0,0])translate([0,-3,-20])cylinder(h=40, d=8);

            // bolt holes
            mirror([0,1,0])translate([-1,-1,0])m3_bolt_hole();
            translate([-1,-1,12])mirror([0,0,1])m3_bolt_hole();

            // cut of some of the back
            translate([-10-8,-20,-1])cube([10,40,20]);
        }
    }
}

y_clamp();