include <Vitamins/Pipe.scad>;
include <Components.scad>;
include <Tee Housing.scad>;
include <Receiver.scad>;
include <TriggerAssembly.scad>;
include <Cylinder.scad>;

wall_thickness        = 3/32;
offset                = revolver_cylinder_wall*2;
foregrip_depth        = 1;     // Length for the 1" pipe
foregrip_extension    = 1; // Length for the 3/4" pipe
foregrip_angle_length = foregrip_depth + foregrip_extension + 10;

// Scale up to metric for printing
rotate([0,0,0])
*scale([25.4,25.4,25.4]) {


  union() {
    difference() {
      union() {
        cylinder(r=cylinder_hole_diameter/2 + wall_thickness*2, h=1);

        translate([-cylinder_hole_diameter/2 - backstrap_offset - 3_4_angle_stock_thickness,0,0])
        rotate([0,0,-45])
        translate([-wall_thickness,-wall_thickness,0])
        cube([3_4_angle_stock_width + 1/3,3_4_angle_stock_width + 1/3,1]);


        translate([cylinder_hole_diameter + offset,0,0])
        cylinder(r=cylinder_hole_diameter/2 + revolver_cylinder_wall*2, h=1.5);
      }

      #cylinder(r=cylinder_hole_diameter/2, h=3);

      translate([0,0,1])
      #cylinder(r=cylinder_hole_diameter/2 + wall_thickness*2, h=2);

      translate([-cylinder_hole_diameter/2 - backstrap_offset - 3_4_angle_stock_thickness,0,0])
      rotate([0,0,-45])
      #3_4_angle_stock(length=1, cutter=true);

      translate([cylinder_hole_diameter + offset,0,0])
      #cylinder(r=cylinder_hole_diameter/2, h=3);
    }

  }
}


// Scale up to metric for printing
scale([25.4,25.4,25.4]) {

  translate([0,0,2])
  %revolver_cylinder(hole=cylinder_hole_diameter, wall=revolver_cylinder_wall, height=2);

  union() {

    // Spinner pipe
    translate([0,0,0])
    %3_4_pipe(length=5.5);

    3_4_pipe_sleeve(length=1.75 - 0.07, wall=7/16);

    translate([0,0,5.5])
    mirror([0,0,1])
    3_4_pipe_sleeve(length=1, wall=wall_thickness);

    translate([revolver_center_offset(),0,0]) {
      134_nested_pipe_sleeve(minor_length=1, major_length=1.75 - 0.07, wall=wall_thickness);

      translate([0,0,-7]) {
        %3_4_pipe(length=8.75);

        mirror([0,0,1])
        %3_4_tee();
      }

      translate([0,0,1])
      %1_pipe(length=1);
    }

    translate([3_4_angle_stock_height + revolver_cylinder_od()/2 + backstrap_offset,0,-2])
    rotate([0,0,90+45])
    %3_4_angle_stock(length=foregrip_angle_length, cutter=false);

    *translate([-backstrap_offset,0,0])
    translate([-3_4_pipe_od/2 - wall_thickness - 3_4_pipe_clearance,0,0])
    rotate([0,0,90*3+45])
    difference() {
      translate([-wall_thickness,-wall_thickness,0])
      cube([3_4_angle_stock_width + 1/3,3_4_angle_stock_width + 1/3,foregrip_angle_length]);
      3_4_angle_stock(length=foregrip_angle_length, cutter=true);
    }
  }

  *difference() {
    union() {
      rotate([0,0,-90])
      translate([wall_thickness + 1_pipe_od/2,0,wall_thickness])
      rotate([0,90,180])
      *ar15_grip(mount_height = wall_thickness, mount_length = 1/8);
    }
  }

}
