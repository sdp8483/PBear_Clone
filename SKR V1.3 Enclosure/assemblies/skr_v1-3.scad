include <../settings/dimensions.scad>
use <../vitamins/pcb.scad>
use <../vitamins/usb_b.scad>
use <../vitamins/uSD.scad>

module skrV13() {
    pcb();

    translate([usb_x,usb_y,pcb_t])usb_b_jack();

    translate([uSD_x,uSD_y,pcb_t])uSD();
}

skrV13();