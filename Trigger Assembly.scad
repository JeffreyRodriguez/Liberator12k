include <Pipe.scad>;
include <Components.scad>;

//
// Component positions
//
// All pin/rod positions are based on the central axis of the cylinder

// Centerline for firing pin and tee body
centerline_z  = 3_4_tee_center_z; // OK

// Trigger block
trigger_top_z            = 3_4_tee_rim_z_min - trigger_top_clearance;                       //
trigger_bottom_z         = trigger_top_z - trigger_height;                                  //
trigger_pin_z            = trigger_top_z - trigger_pin_offset_top;                          //
trigger_pin_x_compressed = (sear_diameter/2) + trigger_pin_offset_back;                     // A
trigger_travel           = trigger_travel(trigger_pin_x_compressed, sear_travel);           // C
trigger_pin_x_extended   = trigger_pin_x_compressed + trigger_travel;                       // A+C
trigger_bar_pin_distance = trigger_bar_pin_distance(trigger_pin_x_compressed, sear_travel); // D

// Sear rod
sear_top_z_extended = centerline_z + sear_undertravel;                                 // TESTED
sear_pin_offset     = sear_top_z_extended + (-trigger_pin_z) + trigger_pin_x_extended; // TESTED
sear_pin_z_extended = sear_top_z_extended - sear_pin_offset;                           // TESTED
sear_length         = sear_pin_offset + (sear_diameter/2) + sear_extra_length;         // TESTED


module trigger(length, width, height, pin_diameter, pin_length, pin_offset_top, pin_offset_back) {
  union() {
    translate([0,-width/2,0])
    cube([length,width,height]);

    rotate([90,0,0])
    translate([pin_offset_back,height - pin_offset_top, 0])
    cylinder(r=pin_diameter/2, h=pin_length, center=true);
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
    cylinder(r=diameter/2, h=length);

    // Pin
    translate([0,0,-pin_offset])
    rotate([90,0,0])
    cylinder(r=pin_diameter/2, h=pin_length, center=true);
  }
}

module trigger_assembly(position = 0) {
  sear_top_z      = sear_top_z_extended - (sear_travel * position);       // TESTED
  trigger_pin_x   = trigger_pin_x_extended - (trigger_travel * position); // TESTED
  sear_pin_z      = sear_pin_z_extended - (sear_travel * position);       // TESTED
  trig_adjacent   = -(sear_pin_z - trigger_pin_z);                        // TESTED
  trig_sear_angle = atan(trigger_pin_x_extended/trig_adjacent);

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
  translate([0,0,sear_pin_z])
  trigger_bar(width=trigger_bar_width,
              pin_distance=trigger_bar_pin_distance,
              pin_diameter=sear_pin_diameter,
              angle=trig_sear_angle);

  color("Red")
  translate([0,0,sear_top_z])
  sear(diameter=sear_diameter,
       length=sear_length,
       pin_diameter=sear_pin_diameter,
       pin_length=sear_pin_length,
       pin_offset=sear_pin_offset);
}


module trigger_assembly_track(iterations = 20) {
  for(n = [0 : iterations]) {
    trigger_assembly(n/iterations);
  }
}

echo("Sear length and pin offset:", sear_length, sear_pin_offset);
echo("Trigger bar length:", trigger_bar_pin_distance + (trigger_pin_diameter*3));
echo("Trigger pin top, back:", trigger_pin_offset_top, trigger_pin_offset_back);

trigger_assembly(position=$t);
