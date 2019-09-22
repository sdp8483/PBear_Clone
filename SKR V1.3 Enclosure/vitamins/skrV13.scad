include <../settings/dimensions.scad>
use <tmc2130.scad>

module pcb() {
    color("Green") {
        difference() {
            translate([0,0,pcb_t/2])cube([pcb_l, pcb_w, pcb_t], center=true); // PCB

            for (x_quad=[1,-1]) {
                for (y_quad=[1,-1]) {
                    translate([x_quad*hole_x_spacing/2,y_quad*hole_y_spacing/2,-1])cylinder(h=pcb_t+2, d=hole_dia); // Holes
                }
            }
        }
    }
}

module usb_b_plug() {
    // Dimensions - mm
    plug_w = 8.45;
    plug_h = 7.78;
    plug_l = 10.0;

    $fn = 25;

    translate([-plug_w/2,plug_l,-plug_h/2])rotate([90,0,0]) {
        linear_extrude(height=plug_l){
            polygon([[0,0],
                    [plug_w,0],
                    [plug_w,plug_h-1],
                    [plug_w-1,plug_h],
                    [1,plug_h],
                    [0,plug_h-1]]);
        }
    }
}

module usb_b_jack() {
    // Dimensions - mm
    usb_l = 16.3;
    usb_w = 36.09-24.11;
    usb_h = 10.62;

    $fn=25;

    color("Silver")difference() {
        cube([usb_w, usb_l, usb_h]); // main body
        translate([usb_w/2,-1,usb_h/2])usb_b_plug();
    }
}

module uSD() {
    // Dimensions - mm
    sd_w = 57.49-42.46;
    sd_t = 1.85;
    pts = [[0,0],
           [sd_w,0],
           [sd_w,14.5],
           [11.05,14.5],
           [10.05,13.79],
           [0,13.79]];
    color("Silver") {
        translate([0,14.5,sd_t]) {       
            rotate([180,0,0]) {
                linear_extrude(height=sd_t)polygon(pts);
            }
        }
    }
}

module skrV13() {
    translate([pcb_l/2,pcb_w/2,0]) {
        pcb();

        translate([usb_x,usb_y,pcb_t])usb_b_jack();

        translate([uSD_x,uSD_y,pcb_t])uSD();

        for (n = [0:4]) {
            pos = (tmc_l * n) + ((pcb_l - (tmc_l*5))/5)*n;
            translate([(-pcb_l/2) + pos, (pcb_w/2) - 23.4,pcb_t])TMC2130();
        }
    }
}

skrV13();