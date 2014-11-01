include <Pipe.scad>;

//
// Component Dimensions
//
$fn=60;

breech_face_x = (3_4_tee_width/2) + 3_4_x_1_8_bushing_depth;

// Firing Pin: 1/4" Rod with shaft collar(s)
firing_pin_diameter      = 1/4;
firing_pin_collar_od     = 1/2;
firing_pin_collar_length = 0.25;
firing_pin_overtravel    = 3/32; // Protrusion from breech face
firing_pin_length        = breech_face_x + (3_4_tee_width/2);

// Trigger: 1 1/2"x1"x1/4" Aluminum Stock with 1/8" Rod Pin
trigger_height          = 1 + 1/32;
trigger_width           = 0.25 + 1/32;
trigger_length          = 1.5;
trigger_top_clearance   = 3_4_tee_rim_z_min + 1/8;
trigger_pin_diameter    = 1/8 + 1/32;
trigger_pin_length      = 1;
trigger_pin_offset_top  = 1/8;
trigger_pin_offset_back = 1/8;

// Trigger Bar: 1/2" Square Steel Tubing
trigger_bar_width        = 0.5;
trigger_bar_thickness    = 0.06;
trigger_bar_clearance    = 1/32;
trigger_bar_iterations   = 100;

// Sear: 1/4" Rod with 1/8" Rod Pin
sear_diameter     = 1/4;
sear_overtravel   = 1/32;
sear_undertravel  = -1/8;
sear_travel       = (firing_pin_collar_od/2) + sear_overtravel + sear_undertravel;
sear_pin_diameter = 1/8 + 1/32;
sear_pin_length   = 1;
sear_extra_length = 1/4;
sear_clearance    = 1/64;


sear_spring_length_extended = 1.3 - 1/32; // With pre-compression
sear_spring_length_compressed = 1;

// Move the trigger assembly to the back of the T
trigger_assembly_clearance = 1/8;
trigger_assembly_x = - (3_4_tee_id/2)
                     + (sear_diameter/2)
                     + trigger_assembly_clearance;

// Trigger geometry: Trigger Travel (C on diagram)
function trigger_travel(trigger_pin_min, sear_travel) =
    sqrt( pow(trigger_pin_min,2) + (2*pow(sear_travel,2)) )
    - trigger_pin_min + sear_travel;

// Trigger geometry: Trigger Bar Pin Distance (D on diagram)
function trigger_bar_pin_distance(trigger_pin_min, sear_travel) =
    (trigger_pin_min + trigger_travel(trigger_pin_min, sear_travel))
    * sqrt(2);

function trigger_bar_angle(pin_distance, trigger_travel, pct) =
    0;


// Trunnion: 3/4"x1/8" Bushing and 1" Pipe
trunnion_guide_tube_length = 1.6;
trunnion_length = 3;

// Barrel: 3/4"x18.5" Pipe
barrel_id     = 3_4_pipe_id;
barrel_od     = 3_4_pipe_od;
barrel_length = 18.5; // Fascism free?

// Stock: 3/4x"FASCISM_MIN_LENGTH" Pipe
overall_length = 26.5; // Fascism free?
stock_length   = overall_length - barrel_length + breech_face_x - 3_4_pipe_depth;
