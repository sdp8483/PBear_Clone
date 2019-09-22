// render quality settings
$fn = 25;

module single_extrusion_rail_mount(bolt_hole) {
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
                    cylinder(h=10, d=3.2);
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

    // bolt hole
}

cube([109.67+20,84.3+1,7]);

// upper mount
translate([20,84.3+1,0]) {
    rotate([0,270,0]) {
        extrusion_rail_mount();
    }
}

// lower mount
translate([109.67+20,84.3+1,0]) {
    rotate([0,270,0]) {
        extrusion_rail_mount();
    }
}