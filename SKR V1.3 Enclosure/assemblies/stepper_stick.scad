include <../settings/dimensions.scad>
use <../vitamins/tmc2130.scad>

module stepper_stick() {
    tmc2130_pcb();
    translate([7.6,4,tmc_t])heatsink();

    color("Black") {
        translate([0,0,-tmc_offset_from_pcb+pcb_t])cube([tmc_l, 2.5, tmc_offset_from_pcb-pcb_t]);
        translate([0,tmc_w-2.5,-tmc_offset_from_pcb+pcb_t])cube([tmc_l, 2.5, tmc_offset_from_pcb-pcb_t]);
    }
}

stepper_stick();