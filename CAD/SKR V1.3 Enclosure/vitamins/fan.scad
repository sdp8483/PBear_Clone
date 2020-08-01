module fan_80mm() {
    color("DarkSlateGray")difference() {
        // main body
        translate([-40,-40,0]) {
            hull() {
                translate([2.8,2.8,0])cylinder(h=25, r=2.8);
                translate([80-2.8,2.8,0])cylinder(h=25, r=2.8);
                translate([2.8,80-2.8,0])cylinder(h=25, r=2.8);
                translate([80-2.8,80-2.8,0])cylinder(h=25, r=2.8);
            }
        }

        // fan hole
        translate([0,0,-1])cylinder(h=25+2, d=75);

        // mount holes
        translate([71.5/2,71.5/2,-1])cylinder(h=25+2, d=4);
        mirror([1,0,0])translate([71.5/2,71.5/2,-1])cylinder(h=25+2, d=4);
        mirror([0,1,0])translate([71.5/2,71.5/2,-1])cylinder(h=25+2, d=4);
        mirror([1,1,0])translate([71.5/2,71.5/2,-1])cylinder(h=25+2, d=4);
    }
}

module fancut_80mm(depth) {
    cylinder(h=depth, d=78);
    translate([71.5/2,71.5/2,0])cylinder(h=depth, d=4);
    mirror([1,0,0])translate([71.5/2,71.5/2,0])cylinder(h=depth, d=5);
    mirror([0,1,0])translate([71.5/2,71.5/2,0])cylinder(h=depth, d=5);
    mirror([1,1,0])translate([71.5/2,71.5/2,0])cylinder(h=depth, d=5);
}

fan_80mm();