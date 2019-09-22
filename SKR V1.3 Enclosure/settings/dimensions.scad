// Defualt Quality
$fn = 25;

// PCB Dimensions - mm
pcb_l = 109.67;
pcb_w = 84.30;
pcb_t = 1.6;

hole_dia = 3.2;
hole_x_spacing = 101.85;
hole_y_spacing = 76.10;

// PCB Component Locations - mm from center
usb_x = (-pcb_l/2) + 24.11;
usb_y = (-pcb_w/2);

uSD_x = (-pcb_l/2) + 42.46;
uSD_y = (-pcb_w/2) - 0.71;

// TMC2130 Dimensions - mm
tmc_l = 20.32;
tmc_w = 15.24;
tmc_t = 1.6;
tmc_offset_from_pcb = 11.05;


// Global Enclosure Settings
pcb_mnt_pattern = [[0,0],[hole_x_spacing,0],[0,hole_y_spacing],[hole_x_spacing,hole_y_spacing]];
x_clearance = 25;
y_clearance = 3;
m3_clearance_dia = 3.2;