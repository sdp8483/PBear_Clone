include <../settings/dimensions.scad>
use <skr_v1-3.scad>
use <../parts/skrv13_back.scad>

main_body();
translate([pcb_l/2+(5/2),pcb_w/2+(5/2),pcb_t+4])skrV13();