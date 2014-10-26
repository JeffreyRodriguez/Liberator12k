include <Pipe.scad>;
include <Components.scad>;

//
// Component positions
//
// All pin positions are based on the center of the pin
//
// Trigger trigonometry - isosceles right triangle on X,Z), relative to x=0,z=trigger_pin_z
//                      - inverted along the Z axis

// Centerline for firing pin and tee body
centerline_z  = 3_4_tee_center_z; // OK

// Trigger and pin vertical position
trigger_top_z              = 3_4_tee_rim_z_min - trigger_top_clearance; // TESTED
trigger_bottom_z           = trigger_top_z - trigger_height;            // TESTED
trigger_pin_z              = trigger_top_z - trigger_pin_offset_top;    // TESTED

// Sear top vertical position
sear_top_z_extended        = centerline_z + sear_undertravel;           // TESTED
sear_top_z_compressed      = sear_top_z_extended - sear_travel;         // TESTED
sear_top_z                 = sear_top_z_extended - (sear_travel * $t);  // TESTED

// Trigger and trigger pin horizontal position
trigger_back_x_compressed  = sear_diameter/2;                                     // TESTED
trigger_pin_x_compressed   = trigger_back_x_compressed + trigger_pin_offset_back; // TESTED

trig_opposite_compressed   = trigger_pin_x_compressed;                            // A TESTED

// ((A+B) * sqrt(2))^2 = A^2+(A+B+D)^2 solve for B
trigger_travel             = sqrt(pow(trigger_pin_x_compressed,2)
                                 + (2 * pow(sear_travel,2)))
                             - trigger_pin_x_compressed + sear_travel;            // B TESTED

trig_opposite_extended     = trig_opposite_compressed + trigger_travel;           // E TESTED
trigger_pin_x_extended     = trig_opposite_extended;                              // TESTED

trig_opposite              = trig_opposite_extended - (trigger_travel * $t);      // TESTED
trigger_pin_x              = trig_opposite;                                       // TESTED

// Sear pin vertical position; top face to pin center
sear_pin_offset          = sear_top_z_extended + (-trigger_pin_z) + trig_opposite_extended; // TESTED

sear_pin_z_extended      = sear_top_z_extended - sear_pin_offset;    // TESTED
sear_pin_z_compressed    = sear_pin_z_extended - sear_travel;        // TESTED
sear_pin_z               = sear_pin_z_extended - (sear_travel * $t); // TESTED

sear_length              = sear_pin_offset + (sear_diameter/2) + sear_extra_length; // TESTED

// Trigger trigonometry: Back
trig_adjacent            = -(sear_pin_z - trigger_pin_z);            // TESTED
trig_adjacent_compressed = -(sear_pin_z_compressed - trigger_pin_z); // TESTED
trig_adjacent_extended   = -(sear_pin_z_extended - trigger_pin_z);   // TESTED

// Trigger trigonometry: Trigger bar
trig_hypotenuse          = sqrt(pow(trig_adjacent,2)
                                + pow(trig_opposite,2));

trigger_bar_pin_distance = trig_hypotenuse;

trig_sear_angle          = atan(trig_opposite/trig_adjacent);

// Trigger trigonometry
module trigger_trig(width) {

  echo("Trigonometry: adjacent/opposite/hypotenuse",
       trig_adjacent,
       trig_opposite,
       trig_hypotenuse);

  trig_hypotenuse_compressed = sqrt(pow(trig_adjacent_compressed,2)
             + pow(trig_opposite_compressed,2));

  trig_hypotenuse_extended = sqrt(pow(trig_adjacent_extended,2)
             + pow(trig_opposite_extended,2));

  trig_trigger_angle = atan(trig_opposite/trig_adjacent);
  trig_trigger_angle_compressed = atan(trig_opposite_compressed/trig_adjacent_compressed);
  trig_trigger_angle_extended = atan(trig_opposite_extended/trig_adjacent_extended);


  trig_sear_angle_compressed = atan(trig_opposite_compressed/trig_adjacent_compressed);
  trig_sear_angle_extended   = atan(trig_opposite_extended/trig_adjacent_extended);

  color("Blue", 0.1)
  translate([0,-sear_diameter/2,sear_pin_z])
  cube([trig_opposite,sear_diameter,trig_adjacent]);

  // Hypotenuse
  color([$t,1-$t,0], 1)
  translate([-0.005,-width/2,sear_pin_z])
  rotate([0,trig_sear_angle,0])
  cube([.01,width,trig_hypotenuse]);

  // Extended angle
  color("Green", .1)
  translate([-0.005,-width/2,sear_pin_z_extended])
  rotate([0,trig_sear_angle_extended,0])
  cube([.01,width,trig_hypotenuse_extended]);

  // Compressed angle
  color("Red", .1)
  translate([-0.005,-width/2,sear_pin_z_compressed])
  rotate([0,trig_sear_angle_compressed,0])
  cube([.01,width,trig_hypotenuse_compressed]);
}

module sear(diameter, length, pin_diameter, pin_length, pin_offset) {

  union() {
    // Sear
    translate([0,0,-length])
    cylinder(r=diameter/2, h=length);

    // Sear pin
    translate([0,0,-pin_offset])
    rotate([90,0,0])
    cylinder(r=pin_diameter/2, h=pin_length, center=true);
  }
}

module trigger(length, width, height, pin_diameter, pin_length, pin_offset_top, pin_offset_back) {
  //translate([-pin_offset_back,0,(height/2) - pin_offset_top])
  union() {
    translate([0,-width/2,0])
    cube([length,width,height]);

    rotate([90,0,0])
    translate([pin_offset_back,height - pin_offset_top, 0])
    cylinder(r=pin_diameter/2, h=pin_length, center=true);
  }
}

module trigger_tracks() {

  // Trigger pin track
  color("Green", 0.25)
  translate([trigger_pin_x_compressed - (trigger_pin_diameter/2),
             -trigger_pin_length/2,
            trigger_pin_z - (trigger_pin_diameter/2)])
  cube([trigger_travel + trigger_pin_diameter,
        sear_pin_length,
        trigger_pin_diameter]);

  // Sear pin track
  color("Green", 0.25)
  translate([-sear_pin_diameter/2,
             -sear_pin_length/2,
             sear_pin_z_compressed - (sear_pin_diameter/2)])
  cube([sear_pin_diameter,sear_pin_length,sear_travel + sear_pin_diameter]);
}

module trigger_bar(width, pin_distance, pin_diameter, angle) {
  // Outer radius of the pins and a diameter on each side
  effective_length = pin_distance + (pin_diameter * 3);

  rotate([angle,0,90])
  translate([0,0,(effective_length/2) - (pin_diameter*1.5)])
  difference() {
    color("OrangeRed")
    cube([width,width,effective_length], center=true);

    // Upper Hole
//    translate([0,0,pin_distance/2])
//    rotate([0,90,0])
//    cylinder(r=pin_diameter/2, h=width + 1, center=true);

    // Lower Hole
//    translate([0,0,-pin_distance/2])
//    rotate([0,90,0])
//    cylinder(r=pin_diameter/2, h=width + 1, center=true);
  }
}

module trigger_bar_track(clearance, iterations) {
  color("Orange")
  for(n = [0 : iterations]) {
    translate([0,0,sear_pin_z_extended - (sear_travel * n / iterations)])
    trigger_bar(width=trigger_bar_width + clearance,
                pin_distance=trigger_bar_pin_distance,
                pin_diameter=sear_pin_diameter,
                angle=atan(
                  trig_opposite_extended - (trigger_travel * n / iterations) // Opposite
                  /
                  -((sear_pin_z_extended - (sear_travel * n / iterations)) - trigger_pin_z) // Adjacent
                ));
  }
}

module trigger_assembly(travel = 0) {

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
