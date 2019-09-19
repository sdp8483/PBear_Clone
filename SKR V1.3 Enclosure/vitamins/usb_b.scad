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

usb_b_jack();