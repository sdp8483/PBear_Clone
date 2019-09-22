module m3_square_nut() {
    color("Silver") {
        translate([0,0,1.85/2]) {
            difference() {
                cube([5.45,5.45,1.85]);
                translate([5.45/2,5.45/2,-5])cylinder(d=3, h=10, $fn=30);
            }
        }
    }
}

m3_square_nut();