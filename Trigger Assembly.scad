include <Pipe.scad>;
include <Components.scad>;

//
// Component positions
//
// All pin/rod positions are based on the central axis of the cylinder

// Centerline for firing pin and tee body
centerline_z  = 3_4_tee_center_z; // OK

// Trigger block
trigger_top_z            = 3_4_tee_rim_z_min - trigger_top_clearance;
trigger_bottom_z         = trigger_top_z - trigger_height;
trigger_pin_z            = trigger_top_z - trigger_pin_offset_top;
trigger_pin_x_compressed = (sear_diameter/2) + trigger_pin_offset_back;                     // A
trigger_travel           = trigger_travel(trigger_pin_x_compressed, sear_travel);           // C
trigger_pin_x_extended   = trigger_pin_x_compressed + trigger_travel;                       // A+C
trigger_bar_pin_distance = trigger_bar_pin_distance(trigger_pin_x_compressed, sear_travel); // D

// Sear rod
sear_top_z_extended   = centerline_z + sear_undertravel;
sear_top_z_compressed = sear_top_z_extended - sear_travel;
sear_pin_offset       = sear_top_z_extended + (-trigger_pin_z) + trigger_pin_x_extended;
sear_pin_z_extended   = sear_top_z_extended - sear_pin_offset;
sear_length           = sear_pin_offset + (sear_diameter/2) + sear_extra_length;

module firing_pin() {
  color("Yellow", .25)
  translate([breech_face_x + firing_pin_overtravel,0,centerline_z])
  rotate([0,-90,0])
  cylinder(r=firing_pin_diameter/2, h=firing_pin_length);

  translate([sear_diameter + firing_pin_overtravel,0,centerline_z])
  rotate([0,-90,0])
  cylinder(r=firing_pin_collar_od/2, h=firing_pin_collar_length);
}

module trigger(length, width, height, pin_diameter, pin_length, pin_offset_top, pin_offset_back) {
  union() {

    // Block
    translate([0,-width/2,0])
    cube([length,width,height]);

    // Pin
    rotate([90,0,0])
    translate([pin_offset_back,height - pin_offset_top, 0])
    //cylinder(r=pin_diameter/2, h=pin_length, center=true);
    cube([pin_diameter,pin_diameter,pin_length], center=true);
  }
}

module trigger_bar(width, pin_distance, pin_diameter, angle) {
  // Outer radius of the pins and a diameter on each side
  effective_length = pin_distance + (pin_diameter * 3);

  rotate([angle,0,90])
  translate([0,0,(effective_length/2) - (pin_diameter*1.5)])
  color("OrangeRed")
  cube([width,width,effective_length], center=true);
}

module sear(diameter, length, pin_diameter, pin_length, pin_offset) {
  union() {

    // Rod
    translate([0,0,-length])
    cylinder(r=(diameter/2) + sear_clearance, h=length);

    // Pin
    rotate([90,0,0])
    translate([0,-pin_offset,0])
    //cylinder(r=pin_diameter/2, h=pin_length, center=true);
    cube([pin_diameter,pin_diameter,pin_length], center=true);
  }
}

module trigger_assembly(position = 0) {
  trigger_pin_x     = trigger_pin_x_extended - (trigger_travel * position);
  sear_pin_z        = -sqrt(pow(trigger_bar_pin_distance,2) - pow(trigger_pin_x,2)) - sear_pin_diameter;
  sear_top_z        = sear_pin_z + sear_pin_offset + trigger_pin_z + (sear_pin_diameter/2);
  trigger_bar_angle = 270-acos(trigger_pin_x/trigger_bar_pin_distance);
  //echo("Trigger Bar Angle", trigger_bar_angle);

  //union() {
    color("Purple")
    translate([trigger_pin_x - trigger_pin_offset_back, 0, trigger_bottom_z])
    trigger(length=trigger_length,
            width=trigger_width,
            height=trigger_height,
            pin_diameter=trigger_pin_diameter,
            pin_length=trigger_pin_length - 0.02,
            pin_offset_top=trigger_pin_offset_top,
            pin_offset_back=trigger_pin_offset_back);

    color("Orange")
    translate([trigger_pin_x,0,trigger_pin_z])
    trigger_bar(width=trigger_bar_width + trigger_bar_clearance,
                pin_distance=trigger_bar_pin_distance,
                pin_diameter=sear_pin_diameter,
                angle=trigger_bar_angle);

    color("Red", .25)
    translate([0,0,sear_top_z])
    sear(diameter=sear_diameter,
         length=sear_length,
         pin_diameter=sear_pin_diameter,
         pin_length=sear_pin_length,
         pin_offset=sear_pin_offset);


    // Sear Spring
    color("Green")
    translate([0,0,sear_top_z_extended - sear_length - sear_spring_length_extended])
    cylinder(r=sear_diameter/2, h=sear_spring_length_extended);
  //}
}

// There are more precise ways to build this track, but this is awfully easy.
module trigger_assembly_track(iterations = 20) {
  for(n = [0 : (iterations-1)]) {
    trigger_assembly(n/(iterations-1));
  }
}

echo("Sear length and pin offset:", sear_length, sear_pin_offset);
echo("Trigger bar length:", trigger_bar_pin_distance + (trigger_pin_diameter*3));
echo("Trigger pin top, back:", trigger_pin_offset_top, trigger_pin_offset_back);


translate([trigger_assembly_x,-0.01,0]) {
  //trigger_assembly($t);
  //trigger_assembly(0);
  //trigger_assembly(1);
  //trigger_assembly_track(20);
}
