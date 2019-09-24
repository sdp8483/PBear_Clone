use <../vitamins/alExtrusion.scad>

$fn = 25;

module bottom_frame() {
    // bottom Y length rails
    alExt_2040(l=331);
    translate([0,370-40,0])alExt_2040(l=331);

    // bottom X length rails
    mirror([1,0,0])rotate([90,0,90])alExt_2040(l=370);
    translate([331,0,0])rotate([90,0,90])alExt_2040(l=370);

    // angle corners
    translate([0,0,20])angle_corner();
    translate([0,370-20,20])angle_corner();
    translate([331,20,20])rotate(180)angle_corner();
    translate([331,370,20])rotate(180)angle_corner();
}

module z_frame() {
    rotate([0,90,0]) {
        translate([-359,0,0]) {
            // Z rails
            alExt_2040(l=359);
            translate([0,290+40,0])alExt_2040(l=359);
            // Top Rail
            translate([40,40,0])rotate([0,0,90])alExt_2040(l=290);
        }
    }

    translate([20,0,-20])rotate([90,270,0])joining_plate();
    translate([20,40+4,-20])rotate([90,270,0])joining_plate();

    translate([20,290+40,-20])rotate([90,270,0])joining_plate();
    translate([20,290+40+40+4,-20])rotate([90,270,0])joining_plate();
}

module pb_frame() {
    bottom_frame();
    translate([106,0,20])z_frame();
}

pb_frame();