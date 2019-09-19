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

uSD();