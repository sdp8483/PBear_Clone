$fn = 25;

module alExt_2040(l) {
    translate([l/2,20,10]) {
        color("DimGray") {
            difference() {
                // main body
                cube([l,40,20], center=true);

                // slots
                translate([0,-(40/2)+(6.2/2)-1])cube([l+2,6.2,6.2], center=true);
                mirror([0,1,0])translate([0,-(40/2)+(6.2/2)-1])cube([l+2,6.2,6.2], center=true);

                translate([0,10,(20/2)-(6.2/2)+1])cube([l+2,6.2,6.2], center=true);
                mirror([0,0,1])translate([0,10,(20/2)-(6.2/2)+1])cube([l+2,6.2,6.2], center=true);
                mirror([0,1,0])translate([0,10,(20/2)-(6.2/2)+1])cube([l+2,6.2,6.2], center=true);
                mirror([0,1,1])translate([0,10,(20/2)-(6.2/2)+1])cube([l+2,6.2,6.2], center=true);

                // holes
                translate([0,10,0])rotate([0,90,0])cylinder(h=l+2, d=3, center=true);
                mirror([0,1,0])translate([0,10,0])rotate([0,90,0])cylinder(h=l+2, d=3, center=true);
            }
        }
    }
}

module angle_corner() {
    color("DimGrey") {
        translate([0,20,0]){
            rotate([90,0,0]) {
                linear_extrude(height=20)polygon([[0,0],[20,0], [0,20]]);
            }
        }
    }
}

module joining_plate() {
    color("DimGray") {
        union() {
            cube([60,20,4]);
            cube([20,60,4]);

            translate([20,20,0]) {
                linear_extrude(height=4)polygon([[0,0],[40,0],[0,40]]);
            }
        }
    }
}

// Sample of parts
joining_plate();
translate([0,80,0])angle_corner();
translate([0,130,0])alExt_2040(200);