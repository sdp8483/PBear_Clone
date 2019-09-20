include <../settings/dimensions.scad>
use <../vitamins/pcb.scad>
use <../vitamins/usb_b.scad>
use <../vitamins/uSD.scad>
use <stepper_stick.scad>

module skrV13() {
    pcb();

    translate([usb_x,usb_y,pcb_t])usb_b_jack();

    translate([uSD_x,uSD_y,pcb_t])uSD();

    for (n = [0:4]) {
        pos = (tmc_l * n) + ((pcb_l - (tmc_l*5))/5)*n;
        translate([(-pcb_l/2) + pos, (pcb_w/2) - 23.4,tmc_offset_from_pcb])stepper_stick();
    }
}

skrV13();