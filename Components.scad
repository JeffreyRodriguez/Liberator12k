include <Pipe.scad>;

//
// Component Dimensions
//
$fn=60;



// Pythagorean Theorem
function pyth_A_B(a,b) = sqrt(pow(a, 2) + pow(b, 2));

// Centerline for firing pin and tee body
centerline_z  = 3_4_tee_center_z; // OK

breech_face_x = (3_4_tee_width/2) + 3_4_x_1_8_bushing_depth;


module circle_cutter(diameter,length, width, height, xp=0, xn=0, yp=0, yn=0) {
  difference() {
    // Outer Box
    cube([length, width, height], center=true);

    // Center Hole
    cylinder(r=(diameter/2), h=height + 0.2, center=true);

    // Legs - X-Positive
    translate([0,-diameter/2,(-height/2) - 0.1])
    cube([xp, diameter, height + 0.2]);

    // Legs - X-Negative
    translate([-xn,-diameter/2,(-height/2) - 0.1])
    cube([xn, diameter, height + 0.2]);

    // Legs - Y-Positive
    translate([-diameter/2,0,(-height/2) - 0.1])
    cube([yp, diameter, height + 0.2]);

    // Legs - Y-Negative
    translate([-diameter/2,-yn,(-height/2) - 0.1])
    cube([yn, diameter, height + 0.2]);
  }
}



// Configurable Settings
tee_overlap             = 1/16;
alignment_pin_diameter  = 3/16;
alignment_pin_length    = 3/16;
sear_block_padding      = 5/32;
sear_collar_padding     = 1/16;
trigger_padding         = 1/8;
trigger_wing_height     = 1/8;
trigger_wing_width      = 1/4;
trigger_wing_length     = 1/2;
trigger_protrousion     = 0;
trigger_overtravel      = 1/32;
sear_spring_height      = 1/8;
trigger_housing_length_extra = 1/4;

// Vitamin measurements
firing_pin_diameter        = 1/4;
firing_pin_collar_diameter = 1/2;
firing_pin_collar_height   = 1/4;
sear_diameter              = 1/4;
sear_collar_diameter       = 1/2;
sear_collar_height         = 0.27;
grip_width                 = 0.85;
grip_height                = 1.27;

// Clearances
firing_pin_collar_clearance = 1/64;  // Adds to the trigger travel
alignment_pin_clearance       = 1/32;  // Housing pin socket
sear_rod_clearance          = 1/64;  // Sear rod path
sear_collar_clearance       = 1/64;  // Sear collar pockets
sear_block_clearance        = 1/128; // Sear block path
sear_block_rod_clearance    = 1/64;  // Widens the hole in the sear block
trigger_clearance           = 1/128; // Trigger path

// Calculated: Trigger Geometry
trigger_travel           = (firing_pin_collar_diameter - firing_pin_diameter)/2 + trigger_overtravel;
sear_block_width         = sear_diameter + (sear_block_padding*2);
sear_block_height        = trigger_travel + (sear_block_padding*2);
trigger_height           = sear_block_height + trigger_travel;

// Calculated: Trigger
trigger_sear_slot_width  = sear_diameter + sear_rod_clearance;
trigger_sear_slot_length = trigger_travel + sear_diameter + sear_rod_clearance;
trigger_width            = trigger_sear_slot_width + trigger_padding;
trigger_wing_span        = trigger_width + trigger_wing_width;
trigger_wing_x_offset    = sear_block_padding;
trigger_track_height     = trigger_height + trigger_clearance;
trigger_track_width      = trigger_width + (trigger_clearance*2);

// Calculated: Sear block
sear_collar_pocket_height        = sear_collar_height + (sear_collar_clearance*2);
sear_collar_pocket_radius        = (sear_collar_diameter + sear_collar_clearance)/2;
sear_block_length                = sear_diameter + (sear_block_padding*2);
sear_block_hole_radius           = sear_diameter/2 + sear_block_rod_clearance/2;
sear_block_track_width           = sear_block_width + (sear_block_clearance*2);
sear_block_track_length          = sear_block_length + (sear_block_clearance*2);
sear_block_track_height          = sear_block_height + trigger_travel + sear_block_clearance*2;
trigger_housing_internal_top     = sear_collar_padding         // Top collar pocket, top padding
                                   + sear_collar_pocket_height // Collar pocket
                                   + sear_collar_padding;      // Top collar pocket, bottom padding

trigger_housing_internal_bottom  = trigger_housing_internal_top + sear_block_track_height;

// Calculated: Trigger Housing
trigger_housing_length       = trigger_housing_length_extra
                               + max(sear_block_length + (sear_block_padding*2), // Sear track and padding

                                   // OR
                                   trigger_wing_length/2 + trigger_travel // Track for the trigger wings
                                   + sear_block_padding*2)                // Front and rear walls

                                // AND
                                 + trigger_housing_length_extra;
trigger_housing_width        = max(trigger_wing_span + sear_block_padding,
                                   grip_width);
trigger_housing_height       = max(grip_height,
                                   sear_collar_pocket_height + sear_collar_padding*2 // Top collar pocket
                                 + max(trigger_track_height,sear_block_track_height) // Sear or trigger cutter, whichever is larger
                                 + sear_collar_pocket_height + sear_collar_padding // Bottom collar pocket
                                 + trigger_travel
                                 + sear_spring_height);

// Calculated:
trigger_rear_height        = 1/4;
trigger_length             = trigger_housing_length + trigger_protrousion;
trigger_angle_cutter_width = trigger_width * 1.1;
trigger_rear_cutter_height = trigger_height - trigger_rear_height;
trigger_x_extended         = -sear_diameter + trigger_travel;
trigger_x_compressed       = -sear_diameter;




module alignment_pin(male=true) {
  rotate([90,0,0])
  if (male) {
    cube([alignment_pin_diameter,alignment_pin_diameter,alignment_pin_length], center=true);
  } else {
    cube([
      alignment_pin_diameter+alignment_pin_clearance,
      alignment_pin_diameter+alignment_pin_clearance,
      alignment_pin_length + alignment_pin_clearance], center=true);
  }
}
