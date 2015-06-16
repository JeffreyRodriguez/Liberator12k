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
tee_overlap             = 3/16;
sear_block_padding      = 5/32;
sear_collar_padding     = 1/16; // Between the bottom of the sear collar and top of the tracks
trigger_padding         = 1/8;
trigger_wing_height     = 1/8;
trigger_wing_width      = 1/4;
trigger_wing_length     = 1/2;
trigger_protrousion     = 1/2;
trigger_overtravel      = 1/16;
sear_spring_height      = 1/4;
rope_od                 = 6/32;

trigger_housing_padding_back = 1/16;
trigger_housing_padding_front = 12/32;
trigger_housing_padding_sides = 1/16;
trigger_housing_padding_top = 1/16;
trigger_housing_padding_bottom = 1/8;

// Configurable: Cylinder
cylinder_spindle_diameter    = 1/8;
cylinder_spindle_wall        = 5/16;
revolver_cylinder_wall       = 1_pipe_wall;
revolver_cylinder_outer_wall = 3/64;
spindle_overlap              = revolver_cylinder_wall;
revolver_zigzag_pin_diameter = 4/32;
revolver_zigzag_depth        = 3/16;
revolver_shots               = 6;
zigzag_clearance             = 1/64;
chamber_length               = 3;
chamber_seal_overlap         = 1/4;
spindle_collar_diameter      = 0.505;
spindle_collar_height        = 0.27;

// Configurable: Vitamin Selection
backstrapRod   = RodThreeQuarterInchTubing;
spindleRod     = RodOneQuarterInch;
breechBushing  = BushingThreeQuarterInch;
barrelPipe     = PipeThreeQuartersInch;
receiverTee    = TeeThreeQuarterInch;
gasSealingPipe = PipeOneInch;

// Configurable: Actuator
actuator_length             = 1.5;
actuator_collar_offset      = 5/8;
actuator_pin_offset         = 1;
actuator_pin_depth          = 13.5/32;
actuator_cylinder_clearance = 1/64;

// Configurable: Forend
forend_length = 2;
forend_wall_thickness = 3/16;
forend_seal_length = 2;
forend_extension = 1/2;


// Configurable: Cylinder Linkage
cylinder_linkage_height     = 3/8;
cylinder_linkage_width      = 3/8;
cylinder_linkage_length     = 7;
cylinder_linakge_rod_offset = 3.05;

grip_width                 = 0.85;
grip_height                = 1.27;


// Calculated: Revolver Cylinder
zigzag_width = revolver_zigzag_pin_diameter + zigzag_clearance*2;
cylinder_hole_diameter = 3_4_pipe_od + 3_4_pipe_clearance;
revolver_cylinder_radius = (3_4_pipe_od*1.5)+revolver_cylinder_wall + revolver_cylinder_outer_wall + revolver_zigzag_depth;
revolver_cylinder_od   = revolver_cylinder_radius*2;
cylinder_circumference = 3.14 * pow(revolver_cylinder_od/2, 2);
revolver_center_offset = 3_4_pipe_od + revolver_cylinder_wall;
rotation_angle = 360/revolver_shots;
rotation_arc = cylinder_circumference/revolver_shots;
zigzag_height = rotation_arc/2 + revolver_zigzag_pin_diameter*2;
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
backstrap_offset      = 3_4_tee_rim_od/2 + tee_overlap
                      + lookup(RodRadius, backstrapRod);
