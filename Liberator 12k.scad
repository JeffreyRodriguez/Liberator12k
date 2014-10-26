//$t=0;
include <Trigger Assembly.scad>;
include <Receiver.scad>;



//trigger_pin_offset_back = 0.25;
//trigger_pin_offset_top = 0.4;
//trigger_pin_length = trigger_bar_width + .5;
//trigger_pin_offset_top  = (trigger_height/2);

  grip_base_thickness = 0.25;
  grip_height = sear_length - sear_top_z_compressed + sear_spring_length_compressed + grip_base_thickness;
  grip_diameter = 3_4_tee_rim_od;
//  grip_diameter = (trigger_pin_x_extended + trigger_pin_diameter) * 2;

receiver();



module grip() {




  color("Green", 0.5)
  union() {
//    translate([-3_4_tee_width/2,-3_4_tee_rim_od/2,0])
//    cube([3_4_tee_width, 3_4_tee_rim_od,3_4_tee_height]);

    difference() {
      // Body
      union() {

        rotate([0,180,0])
        cylinder(r=grip_diameter/2, h=grip_height);

        // Head (fits inside the tee)
        translate([0,0,-0.1])
        cylinder(r=3_4_tee_id/2, h=1);
      }

      translate([trigger_assembly_x,0,0])
      trigger_assembly_track();

      // Trigger pin and sear pin tracks
      color("Black")
      translate([trigger_assembly_x,0,0])
      trigger_tracks();

      // Sear
      color("Red") 
      translate([trigger_assembly_x,0,sear_top_z_compressed - sear_length])
      cylinder(r=sear_diameter/2, h=sear_length + sear_travel);

      // Sear Spring
      color("Green")
      translate([trigger_assembly_x,0,-(grip_height - grip_base_thickness)])
      cylinder(r=sear_spring_diameter/2, h=sear_spring_length_extended);
    }
  }
}


// Firing pin
color("Yellow", .25)
translate([breech_face_x + firing_pin_overtravel,0,centerline_z])
rotate([0,-90,0])
cylinder(r=firing_pin_diameter/2, h=firing_pin_length);

translate([sear_diameter + firing_pin_overtravel,0,centerline_z])
rotate([0,-90,0])
cylinder(r=firing_pin_collar_od/2, h=firing_pin_collar_length);

color("Brown", .5)
difference() {
  grip();

  // Cutaway
  translate([-grip_diameter,-(grip_diameter+1),-grip_height -1])
  cube([grip_diameter*2,grip_diameter+1,grip_height + 2]);
}
