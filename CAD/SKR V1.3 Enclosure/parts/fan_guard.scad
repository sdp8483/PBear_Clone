include <../settings/dimensions.scad>
use <../settings/mods.scad>
use <../vitamins/fan.scad>

module fan_guard() {
    thickness = 1.2;
    radius = 2.5;
    x = 40-radius;
    y = 40-radius;

    translate([0,0,thickness/2])union() {
        // main body
        difference() {
            hull() {
                for (i=[-1,1]) {
                    for (j=[-1,1]) {
                        translate([x*i, y*j,0])cylinder(h=thickness,r=radius,center=true);
                    }
                }
                
            }
            translate([0,0,-1])fancut_80mm(2);
        }
        // radial arms
        for (i=[0:22.5:180]) {
            rotate(i)cube([80,1.2,thickness],center=true);
        }

        // support circles
        for (j=[20:20:80]) {
            difference() {
                cylinder(h=thickness,d=j,center=true);
                cylinder(h=2,d=j-1.2*2,center=true);
            }
        }
    }
}

fan_guard();