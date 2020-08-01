module m3_square_nut() {
    color("Silver") {
        translate([0,0,1.85/2]) {
            difference() {
                cube([5.45,5.45,1.85]);
                translate([5.45/2,5.45/2,-5])cylinder(d=3, h=10);
            }
        }
    }
}

module plastic_screw() {
    color("Grey") translate([0,0,-16]){
        cylinder(h=16, d=4);
        translate([0,0,16])cylinder(h=2.5, d=8.2);
    }
}

plastic_screw();

translate([10,0,0]) m3_square_nut();