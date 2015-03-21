include <Math/Triangles.scad>;
include <Vitamins/Angle Stock.scad>;
include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;

//
// Component Dimensions
//
$fn=60;

// Fascist Settings
overall_length = 26.5;
barrel_length = 18.5;

// Centerline for firing pin and tee body
centerline_z  = 3_4_tee_center_z; // OK

breech_face_x = (3_4_tee_width/2) + 3_4_x_1_8_bushing_depth;




// Configurable Settings
tee_overlap             = 1/8;
sear_block_padding      = 5/32;
sear_collar_padding     = 1/16; // Between the bottom of the sear collar and top of the tracks
trigger_padding         = 1/8;
trigger_wing_height     = 1/8;
trigger_wing_width      = 1/4;
trigger_wing_length     = 1/2;
trigger_protrousion     = 1/2;
trigger_overtravel      = 1/16;
sear_spring_height      = 1/4;

trigger_housing_padding_back = 1/16;
trigger_housing_padding_front = 12/32;
trigger_housing_padding_sides = 1/16;
trigger_housing_padding_top = 1/16;
trigger_housing_padding_bottom = 1/8;

// Configurable: Cylinder
cylinder_spindle_diameter    = 1/4 + 1/32;
cylinder_spindle_wall        = 1/4;
revolver_cylinder_wall       = 1_pipe_wall;
revolver_cylinder_outer_wall = 1_pipe_wall;
spindle_overlap              = revolver_cylinder_wall;
revolver_zigzag_pin_diameter = 1/4;
revolver_zigzag_depth        = 3/16;
revolver_shots               = 6;
zigzag_clearance             = 1/64;
chamber_length               = 3;
chamber_seal_overlap         = 1/4;
spindle_collar_diameter      = 0.505;
spindle_collar_height        = 0.27;

// Configurable: Backstrap
backstrap_wall_thickness = 1/4;

// Configurable: Actuator
actuator_length             = 1.5;
actuator_collar_offset      = 5/8;
actuator_pin_offset         = 1;
actuator_pin_depth          = 13.5/32;
actuator_cylinder_clearance = 1/16;

// Configurable: Forend
forend_length = 2;
forend_wall_thickness = 1/8;
forend_seal_length = 2;
forend_depth = 1.5;


// Configurable: Cylinder Linkage
cylinder_linkage_height     = 3/8;
cylinder_linkage_width      = 3/8;
cylinder_linkage_length     = 7;
cylinder_linakge_rod_offset = 3.05;

// Clearances
firing_pin_collar_clearance = 1/64;  // Adds to the trigger travel
alignment_pin_clearance     = 2/128; // Housing pin socket
sear_rod_clearance          = 1/64;  // Sear rod path
sear_collar_clearance       = 1/64;  // Sear collar pocket
sear_block_clearance        = 1/128; // Sear block path
sear_block_rod_clearance    = 1/64;  // Widens the hole in the sear block
trigger_clearance           = 1/128; // Trigger path
forend_clearance            = 1/64;  // Around the linkage mounting block



// Vitamin measurements
firing_pin_diameter        = 1/4;
firing_pin_collar_diameter = 1/2;
firing_pin_collar_height   = 1/4;
sear_diameter              = 1/4;
sear_collar_diameter       = 1/2;
sear_collar_height         = 0.27;
grip_width                 = 0.85;
grip_height                = 1.27;

// Calculated: Trigger Geometry
trigger_travel           = (firing_pin_collar_diameter - firing_pin_diameter)/2 + trigger_overtravel;
sear_block_width         = sear_diameter + (sear_block_padding*2);
sear_block_height        = trigger_travel + sear_block_padding;
trigger_height           = sear_block_height + trigger_travel;

// Calculated: Trigger
trigger_sear_slot_width  = sear_diameter + sear_rod_clearance;
trigger_sear_slot_length = trigger_travel + sear_diameter + sear_rod_clearance;
trigger_width            = trigger_sear_slot_width + trigger_padding;
trigger_wing_span        = trigger_width + trigger_wing_width;
trigger_wing_x_offset    = sear_block_padding;
trigger_track_height     = trigger_height + trigger_clearance*2;
trigger_track_width      = trigger_width + (trigger_clearance*2);

// Calculated: Sear block
sear_collar_pocket_height        = sear_collar_height + (sear_collar_clearance*2);
sear_collar_pocket_radius        = (sear_collar_diameter + sear_collar_clearance)/2;
sear_block_length                = sear_diameter + (sear_block_padding*2);
sear_block_hole_radius           = sear_diameter/2 + sear_block_rod_clearance/2;
sear_block_track_width           = sear_block_width + (sear_block_clearance*2);
sear_block_track_length          = sear_block_length + (sear_block_clearance*2);
sear_block_track_height          = sear_block_height + trigger_travel + sear_block_clearance;

// Calculated: Trigger Housing
trigger_housing_internal_top     = trigger_housing_padding_top         // Top collar pocket, top padding
                                 + sear_collar_pocket_height           // Collar pocket
                                 + sear_collar_padding;                // Top collar pocket, bottom padding
trigger_housing_x_back         = - trigger_housing_padding_back
                                 - max(-sear_collar_diameter/2 - sear_collar_clearance, sear_diameter/2 + sear_block_padding);
trigger_housing_length         = max(sear_block_length,trigger_wing_length/2 + trigger_travel)
                                 + trigger_housing_padding_back
                                 + trigger_housing_padding_front;
trigger_housing_width          = max(trigger_wing_span + trigger_housing_padding_sides,
                                     grip_width);
trigger_housing_height                 = max(grip_height,
                                             trigger_housing_internal_top                        // Top collar pocket
                                             + max(trigger_track_height,sear_block_track_height) // Sear or trigger cutter, whichever is larger
                                             + trigger_travel
                                             + sear_spring_height
                                             + trigger_housing_padding_top
                                             + trigger_housing_padding_bottom);
trigger_housing_top_pin_height      = sear_collar_height;
trigger_housing_spring_block_height = trigger_housing_height - trigger_housing_internal_top - sear_block_track_height;
trigger_housing_pin_width    = trigger_width;
trigger_housing_pin_length   = trigger_housing_padding_front/2;

trigger_housing_internal_bottom = trigger_housing_internal_top - sear_block_track_height;

// Calculated:
trigger_rear_height        = 1/4;
trigger_length             = trigger_housing_length/2 + sear_diameter + trigger_protrousion;
trigger_x_extended         = -sear_diameter + trigger_travel;
trigger_x_compressed       = -sear_diameter;

// Calculated: Sear Collar Pocket
sear_collar_alignment_pin_height = sear_collar_height + sear_collar_padding*2 + sear_collar_clearance*2;

// Calculated: Revolver Cylinder
zigzag_width = revolver_zigzag_pin_diameter + zigzag_clearance*2;
cylinder_hole_diameter = 3_4_pipe_od + 3_4_pipe_clearance;
revolver_cylinder_od   = ((3_4_pipe_od*1.5)+revolver_cylinder_wall + revolver_cylinder_outer_wall + revolver_zigzag_depth)*2;
cylinder_circumference = 3.14 * pow(revolver_cylinder_od/2, 2);
revolver_center_offset = 3_4_pipe_od + revolver_cylinder_wall;
rotation_angle = 360/revolver_shots;
rotation_arc = cylinder_circumference/revolver_shots;
zigzag_height = rotation_arc/2 + revolver_zigzag_pin_diameter/2;
revolver_cylinder_height = zigzag_height + revolver_zigzag_pin_diameter*2.5;
chamber_protrusion = (chamber_length - revolver_cylinder_height)/2;

top_slot_height = revolver_zigzag_pin_diameter*2;
bottom_slot_height = revolver_zigzag_pin_diameter*2 + zigzag_clearance*1.5;



forend_linkage_offset = revolver_cylinder_od/2 - revolver_center_offset;
forend_block_width = cylinder_linkage_width + forend_wall_thickness*2;
forend_block_height = revolver_cylinder_od/2 - revolver_center_offset - 3_4_pipe_od/2 + cylinder_linkage_height + forend_wall_thickness;
forend_block_length = forend_length + forend_seal_length;
forend_offset_x = 3_4_pipe_od/2 + 3_4_pipe_clearance;
forend_offset_y = -forend_block_width/2;

// Calculated: Backstrap position
backstrap_offset      = 3_4_tee_rim_od/2 + tee_overlap*2
                      + 3_4_angle_stock_height;

module backstrap(length = 1, loose=false) {
  difference() {

    // 3/4" Angle Stock Mount, with a bit of rounding-off
    translate([
      backstrap_wall_thickness*sqrt(2),
      0,
      0])
    rotate([0,0,135]) {
      intersection() {
        translate([3_4_angle_stock_width - 1/8,3_4_angle_stock_width - 1/8, - 0.1])
        cylinder(r=3_4_angle_stock_width/2 + 12/32, h=length + 0.2);

        cube([
          3_4_angle_stock_width + backstrap_wall_thickness*2,
          3_4_angle_stock_width + backstrap_wall_thickness*2,
          length]);
        }
    }


    // 3/4" Angle Stock
    translate([0,0,-2.1])
    rotate([0,0,135])
    3_4_angle_stock(
      length=length + 4.2,
      cutter=true,
      loose=loose);
  }
}
