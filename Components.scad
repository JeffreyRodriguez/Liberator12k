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
tee_overlap             = 1/16;
sear_block_padding      = 5/32;
sear_collar_padding     = 1/16; // Between the bottom of the sear collar and top of the tracks
trigger_padding         = 1/8;
trigger_wing_height     = 1/8;
trigger_wing_width      = 1/4;
trigger_wing_length     = 1/2;
trigger_protrousion     = 1/2;
trigger_overtravel      = 1/16;
sear_spring_height      = 1/4;
revolver_cylinder_wall  = 1/16;
trigger_housing_padding_back = 1/16;
trigger_housing_padding_front = 12/32;
trigger_housing_padding_sides = 1/16;
trigger_housing_padding_top = 1/16;
trigger_housing_padding_bottom = 1/8;
forend_wall_thickness = 1/8;

linkage_mount_wall_thickness = 1/16;
linkage_mount_pipe_length = 1;
linkage_mount_height = 1/2;
linkage_mount_block_clearance = 1/64;


revolver_zigzag_pin_diameter=1/4;
revolver_shots = 6;
zigzag_clearance = 1/64;
zigzag_offset_z = 3/8;
chamber_length = 3;


// Configurable: Cylinder Linkage
cylinder_linkage_height     = 3/8;
cylinder_linkage_width      = 3/8;
cylinder_linkage_length     = 7;
cylinder_linakge_rod_offset = 3.5;

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
cylinder_hole_diameter = 3_4_pipe_od + 3_4_pipe_clearance;
revolver_cylinder_od   = ((cylinder_hole_diameter*1.5)+revolver_cylinder_wall*3 + revolver_zigzag_pin_diameter)*2;
cylinder_circumference = 3.14 * pow(revolver_cylinder_od/2, 2);
revolver_center_offset = cylinder_hole_diameter + revolver_cylinder_wall*2;
rotation_angle = 360/revolver_shots;
rotation_arc = cylinder_circumference/revolver_shots;
zigzag_height = rotation_arc/2;
zigzag_overtravel = revolver_zigzag_pin_diameter*1.5;
revolver_cylinder_height = zigzag_height + zigzag_overtravel*2;
zigzag_width = revolver_zigzag_pin_diameter + zigzag_clearance;
top_slot_height = zigzag_overtravel + revolver_zigzag_pin_diameter + zigzag_clearance;
bottom_slot_height = zigzag_overtravel + revolver_zigzag_pin_diameter + zigzag_clearance;
chamber_protrusion = (chamber_length - revolver_cylinder_height)/2;


linkage_mount_linkage_offset = revolver_cylinder_od/2 - revolver_center_offset;
linkage_mount_block_width = cylinder_linkage_width + linkage_mount_wall_thickness*2;
linkage_mount_block_height = revolver_cylinder_od/2 - revolver_center_offset - 3_4_pipe_od/2 + cylinder_linkage_height + linkage_mount_wall_thickness;
linkage_mount_block_length = linkage_mount_height + linkage_mount_pipe_length;
linkage_mount_offset_x = 3_4_pipe_od/2 + 3_4_pipe_clearance;
linkage_mount_offset_y = -linkage_mount_block_width/2;

// Calculated: Backstrap position
backstrap_offset      = 1_pipe_od/2
                      + linkage_mount_block_height
                      - linkage_mount_wall_thickness
                      + forend_wall_thickness*2
                      + 3_4_angle_stock_height;


module circle_cutter(diameter,length, width, height, xp=0, xn=0, yp=0, yn=0, center=true) {
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
