include <Components.scad>;
include <Shell.scad>;

primer_rim_od = 0.309;
primer_rim_height = 0.01;
primer_height = 0.3;
primer_major_od = 0.248;
primer_minor_od = 0.242;
primer_clearance = 0.021;

rim_od     = 1.046;
rim_height = 0.1;
od     = 0.785;
id     = 0.6;
height = 3 - primer_height;
charge_height = 3/8;
wad_height = 4/16;

//slug_diameter = 1/2 + 0.005; // Extra clearance
slug_diameter = 1/4 + 0.02; // Extra clearance
slug_depth = 1.2;
fin_width = 5/32;
//fin_wall = 4/64;
fin_taper = 3/16;

module speed_loader(floor_height=rim_height) {

union() {

  // Floor Plate
  difference() {
    cylinder(r=revolver_center_offset + rim_od/1.9, h=floor_height);

    translate([0,0,-0.1])
    cylinder(r=revolver_center_offset - rim_od/2, h=floor_height + 0.2);

    for (i=[0:5])
    rotate([0,0,360/6*i])
    translate([revolver_center_offset,0,-0.1])
    cylinder(r=primer_rim_od, h=rim_height+0.2);
  }

  // Shell
  for (i=[0:5])
  rotate([0,0,360/6*i])
  translate([revolver_center_offset,0,0])
  shell_slug();
  //shell_shot();
}
}

scale([25.4, 25.4, 25.4]) {
  speed_loader();
}