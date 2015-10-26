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

// Configurable: Wall Thickness
tee_overlap             = 3/16;

rope_od                 = 6/32;

// Configurable: Cylinder
cylinder_spindle_diameter    = 1/8;
cylinder_spindle_wall        = 5/16;
revolver_cylinder_wall       = PipeWall(PipeOneInch);
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
actuator_cylinder_clearance  = 0.1;

// Configurable: Vitamin Selection
railRod        = RodFiveSixteenthInch;
breechBushing  = BushingThreeQuarterInch;
barrelPipe     = TubingOnePointOneTwoFive;
stockPipe      = PipeThreeQuarterInch;
receiverTee    = TeeThreeQuarterInch;
gasSealingPipe = PipeOneInch;

// Configurable: Common Settings
bottomRailAngle = 50;

// Configurable: Forend
forend_length = 2;
forend_wall_thickness = 3/16;

// AR15 grip info
grip_width                 = 0.85;
grip_height                = 1.27;


// Calculated: Revolver Cylinder
zigzag_width = revolver_zigzag_pin_diameter + zigzag_clearance*2;
revolver_cylinder_radius = (PipeOuterDiameter(PipeThreeQuarterInch)*1.5)+revolver_cylinder_wall + revolver_cylinder_outer_wall + revolver_zigzag_depth;
revolver_cylinder_od   = revolver_cylinder_radius*2;
cylinder_circumference = 3.14 * pow(revolver_cylinder_od/2, 2);
revolver_center_offset = PipeOuterDiameter(PipeThreeQuarterInch) + revolver_cylinder_wall;
rotation_angle = 360/revolver_shots;
rotation_arc = cylinder_circumference/revolver_shots;
zigzag_height = rotation_arc/2 + revolver_zigzag_pin_diameter*2;
revolver_cylinder_height = zigzag_height + revolver_zigzag_pin_diameter*2.5;
chamber_protrusion = (chamber_length - revolver_cylinder_height)/2;

top_slot_height = revolver_zigzag_pin_diameter*2;
bottom_slot_height = revolver_zigzag_pin_diameter*2 + zigzag_clearance*1.5;
