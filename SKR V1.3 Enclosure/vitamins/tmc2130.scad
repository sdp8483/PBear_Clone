include <../settings/dimensions.scad>

module tmc2130_pcb() {
    color("DimGrey") {
        cube([tmc_l, tmc_w, tmc_t]);
    }
}

module heatsink() {
    hs_l = 9.0;
    hs_w = 9.0;
    hs_h = 12.0;

    num_fin_x = 5;
    num_fin_y = 3;
    fin_spacing_x = 1;
    fin_thickness_x = (hs_l - ((num_fin_x-1)*fin_spacing_x))/num_fin_x;
    fin_spacing_y = 1;
    fin_thickness_y = (hs_w - ((num_fin_y-1)*fin_spacing_y))/num_fin_y;

    color("Blue") difference() {
        cube([hs_l, hs_w, hs_h]);

        for (x=[0:num_fin_x-2]) {
            translate([(x+1)*fin_thickness_x+x*fin_spacing_x,-1,2])cube([fin_spacing_x,hs_w+2,hs_h]);
        }

        for (y=[0:num_fin_y-2]) {
            translate([-1,(y+1)*fin_thickness_y+y*fin_spacing_y,2])cube([hs_l+2,fin_spacing_y,hs_h]);
        }
    }
}

tmc2130_pcb();
translate([tmc_l+5,0,0])heatsink();