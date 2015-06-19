//
// Pipe dimensions
//

PipeInnerDiameter   = 1; // Inner Diameter of pipe, smallest measurement if asymmetrical
PipeOuterDiameter   = 2; // Outer Diameter of pipe, largest measurement if asymmetrical
PipeTaperedDiameter = 4; // Threads are tapered, smallest measurement if asymmetrical
PipeThreadLength    = 5; // Total length of the pipe thread
PipeThreadDepth     = 6; // Depth when fully seated
PipeClearanceSnug   = 7; // Should not slip
PipeClearanceLoose  = 8; // Should slide freely
PipeFn              = 9; // Number of sides
PipeWeightPerUnit   = 10;


// 1/4" Pipe
PipeOneQuarterInch = [
  [PipeInnerDiameter,   0.265],
  [PipeOuterDiameter,   0.415],
  [PipeTaperedDiameter, 0.415], // TODO: Verify
  [PipeThreadLength,    0.5],   // TODO: Verify
  [PipeThreadDepth,     0.25],  // TODO: Verify
  [PipeClearanceSnug,   0.015], // TODO: Verify
  [PipeClearanceLoose,  0.027], // TODO: Verify
  [PipeFn,              20],
  [PipeWeightPerUnit,   0] // TODO
];


// 3/4" Pipe
PipeThreeQuartersInch = [
  [PipeInnerDiameter,   0.81],
  [PipeOuterDiameter,   1.07],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.005],
  [PipeClearanceLoose,  0.027],
  [PipeFn,              30],
  [PipeWeightPerUnit,   0] // TODO
];

// 1" Pipe
PipeOneInch = [
  [PipeInnerDiameter,   1.06],
  [PipeOuterDiameter,   1.315],
  [PipeTaperedDiameter, 1.285],
  [PipeThreadLength,    0.982],
  [PipeThreadDepth,     0.5], // TODO: Verify
  [PipeClearanceSnug,   0.02],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              30],
  [PipeWeightPerUnit,   0] // TODO
];

function PipeOuterRadius(pipe, clearance=0) = (lookup(PipeOuterDiameter, pipe) + clearance) / 2;
function PipeInnerRadius(pipe, clearance=0) = (lookup(PipeInnerDiameter, pipe) - clearance) / 2;

module Pipe(pipe=PipeThreeQuartersInch, length = 1, clearance=undef) {
  $fn = lookup(PipeFn, pipe);

  difference() {

    // Create the pipe wall
    if (clearance == undef) {
      cylinder(r=PipeOuterRadius(pipe), h=length);
    } else {
      cylinder(r=PipeOuterRadius(pipe, clearance=lookup(clearance, pipe)), h=length);
    }
  }
};

//Pipe(pipe=PipeOneInch, clearance=PipeClearanceLoose);


// Fittings: Tee
TeeOuterDiameter = 1; // Diameter of the body, not the rim
TeeWidth         = 2; // Across the top of the tee, side-to-side
TeeHeight        = 3; // From the middle of the bottom rim to the top of the body
TeeInnerDiameter = 4; // Diameter of the threaded hole
TeeRimDiameter   = 5; // Diameter of the tee rim
TeeRimWidth      = 6; // Width of the tee rim

TeeThreeQuarterInch = [
  [TeeOuterDiameter, 1.38],
  [TeeWidth,         2.64],
  [TeeHeight,        2.01],
  [TeeInnerDiameter, 0.88],
  [TeeRimDiameter,   1.53],
  [TeeRimWidth,      0.31]
];

function TeeRimWidth(tee) = lookup(TeeRimWidth, tee);
function TeeRimDiameter(tee) = lookup(TeeRimDiameter, tee);
function TeeWidth(tee) = lookup(TeeWidth, tee);
function TeeCenter(tee) = lookup(TeeHeight, tee) - (lookup(TeeOuterDiameter, tee)/2);

module TeeRim(tee=TeeThreeQuarterInch, heightMultiplier=1) {
  cylinder(r=lookup(TeeRimDiameter, tee)/2, h=lookup(TeeRimWidth, tee) * heightMultiplier);
}

// 3/4" Pipe
3_4_pipe_id              = 0.81;
3_4_pipe_od              = 1.07;
3_4_pipe_tapered_od      = 1.018;
3_4_pipe_thread_length   = 0.9;
3_4_pipe_depth           = 0.5; // Depth when fully screwed into a fitting
3_4_pipe_clearance       = 0.015;
3_4_pipe_clearance_loose = 0.027;
3_4_pipe_wall            = (3_4_pipe_od - 3_4_pipe_id)/2;

// 1" Pipe
1_pipe_id              = 1.06;
1_pipe_od              = 1.315;
1_pipe_tapered_od      = 1.285;  // Threaded portion of the pipe, smallest OD
1_pipe_thread_length   = 0.982;  // Length of the threads, measured from the end of the pipe to the last thread mark
1_pipe_clearance       = 0.02;
1_pipe_clearance_loose = 0.03;
1_pipe_wall            = (1_pipe_od - 1_pipe_id)/2;

// 3/4" Tee
3_4_tee_diameter  = 1.38; // Diameter of the body, behind the rim
3_4_tee_width     = 2.64; // Across the top of the T
3_4_tee_height    = 2.01; // From the middle of the bottom rim to the top of the body
3_4_tee_id        = 0.88;
3_4_tee_rim_od    = 1.53;
3_4_tee_rim_width = 0.31;
3_4_tee_center_z  = 3_4_tee_height - (3_4_tee_diameter/2); // Centerline of the T
3_4_tee_rim_z_min = 3_4_tee_center_z - (3_4_tee_rim_od/2); // Bottom of the T rims
3_4_tee_rim_z_max = 3_4_tee_center_z + (3_4_tee_rim_od/2); // Top of the T rims

// 3/4" x 1/8" Bushing
3_4_x_1_8_bushing_height         = 0.955;
3_4_x_1_8_bushing_od             = 1.0;
3_4_x_1_8_bushing_id             = 0.45;
3_4_x_1_8_bushing_head_height    = 0.215;
3_4_x_1_8_bushing_depth          = 0.5;
3_4_x_1_8_bushing_head_od        = 1.225;  // Across the points
3_4_x_1_8_bushing_head_id        = 1.065;  // Across the flats
3_4_x_1_8_bushing_head_clearance = 0.01;

// Fittings: Bushings
BushingHeight    = 1;
BushingDiameter  = 2;
BushingDepth     = 3; // Bushing screws in about half an inch
BushingCapWidth  = 4;
BushingCapHeight = 5;

// 3/4" Bushing
BushingThreeQuarterInch = [
  [BushingHeight,    0.955],
  [BushingDiameter,  1],
  [BushingDepth,     0.5],
  [BushingCapWidth,  1.225],
  [BushingCapHeight, 0.215]
];

module Bushing(spec=BushingThreeQuarterInch) {

  od        = lookup(BushingDiameter, spec);
  height    = lookup(BushingHeight, spec);
  capWidth  = lookup(BushingCapWidth, spec);
  capHeight = lookup(BushingCapHeight, spec);

  union() {

    // Body
    translate([0,0,capHeight/2])
    cylinder(r=od/2, h=height - (capHeight/2), $fn=20);

    // Head
    cylinder(r=capWidth/2, h=capHeight, $fn=6);
  }
}

module bushing(id, od, height, head_major_width, head_height) {
  difference() {
    union() {

      // Body
      translate([0,0,head_height/2])
      cylinder(r=od/2, h=height - (head_height/2), $fn=20);

      // Head
      cylinder(r=head_major_width/2, h=head_height, $fn=6);
    }

    // Hole
    translate([0,0,-1])
    cylinder(r=id/2, h=height + 2, $fn=20);
  }
};

module pipe(id=1, od=2, length=1, hollow=true, cutter=false, clearance=0.1) {
  difference() {

    // Create the pipe wall
    if (cutter) {
      cylinder(r=(od + clearance)/2, h=length);
    } else {
      cylinder(r=od/2, h=length);
    }

    // Hollow it out
    if (hollow) {
      translate([0,0,-1])
      cylinder(r=id/2, h=length + 2);
    }
  }
};


module 3_4_x_1_8_bushing() {
  bushing(id=3_4_x_1_8_bushing_id,
     od=3_4_x_1_8_bushing_od,
     height=3_4_x_1_8_bushing_height,
     head_major_width=3_4_x_1_8_bushing_head_od,
     head_height=3_4_x_1_8_bushing_head_height);
}

module 3_4_pipe(length=1, hollow=true, cutter=false, loose=false) {
  clearance = loose ? 3_4_pipe_clearance_loose : 3_4_pipe_clearance;

  pipe(id=3_4_pipe_id, od=3_4_pipe_od, clearance=clearance,
       length=length, hollow=hollow, cutter=cutter);
};

module 1_pipe(length=1, hollow=true, cutter=false, loose=false) {
  clearance = loose ? 1_pipe_clearance_loose : 1_pipe_clearance;

  pipe(id=1_pipe_id, od=1_pipe_od, clearance=clearance,
       length=length, hollow=hollow, cutter=cutter);
};

module pipe_sleeve(length=1,wall=1,hole=1, clearance=0) {
  difference() {
    cylinder(r=hole/2 + wall, h=length);

    translate([0,0,-0.1])
    cylinder(r=hole/2 + clearance, h=length + 0.2);
  }
};

module 3_4_pipe_sleeve(length=1,wall=1) {
  pipe_sleeve(hole=3_4_pipe_od, length = length, wall = wall, clearance = 3_4_pipe_clearance);
};

module 1_pipe_sleeve(length=1,wall=1) {
  pipe_sleeve(hole=1_pipe_od, length = length, wall = wall, clearance = 1_pipe_clearance);
};

module nested_pipe_sleeve(minor_id=1, minor_length=1, major_id=2, major_length=2, minor_clearance=0, major_clearance=0, wall=1) {
    difference() {
      cylinder(r=major_id/2 + wall, h=minor_length + major_length);

      // Minor Hole
      translate([0,0,-0.1])
      cylinder(r=(minor_id+minor_clearance)/2, h=minor_length + 0.2);

      // Major Hole (1" pipe)
      translate([0,0,minor_length])
      cylinder(r=(major_id+major_clearance)/2, h=major_length + 0.1);
    }
}

module 134_nested_pipe_sleeve(major_length = 2, minor_length=1, wall=1) {
  nested_pipe_sleeve(minor_id=3_4_pipe_od, major_id=1_pipe_od,
                     minor_clearance=3_4_pipe_clearance, major_clearance=1_pipe_clearance,
                     minor_length=minor_length, major_length=major_length, wall=wall);
}

module 1_pipe_tapered(length=2) {
  union() {

    // Thread taper
    rotate([0,90,0])
    color("Orange")
    cylinder(r=1_pipe_tapered_od/2, r2=1_pipe_od/2, h=1_pipe_thread_length);

    // Extra pipe length
    translate([1_pipe_thread_length,0,0])
    rotate([0,90,0])
    color("Blue")
    cylinder(r=1_pipe_od/2, h=length - 1_pipe_thread_length);
  }
};

module tee(width, height, od, id, rim_od, rim_width, cutout = false) {
  difference() {
    union() {

      // T-Top
      rotate([0,-90,0])
      translate([height - (od/2),0,0])
      cylinder(r=od/2, h=width * 0.99, center=true);

      // T-Bottom
      translate([0,0,(height - (od/2)) * 0.01])
      cylinder(r=od/2, h=(height - (od/2)) * 0.98);

      // Bottom rim
      cylinder(r=rim_od/2, h=rim_width);

      // Left rim
      rotate([0,90,0])
      translate([-(height - (od/2)),0,-width/2])
      cylinder(r=rim_od/2, h=rim_width);

      // Right rim
      rotate([0,-90,0])
      translate([height - (od/2),0,-width/2])
      cylinder(r=rim_od/2, h=rim_width);
    }

    // Top Hole
    rotate([0,-90,0])
    translate([height - (od/2),0,0])
    cylinder(r=id/2, h=width * 1.05, center=true);

    // Bottom Hole
    translate([0,0,-height * 0.01])
    cylinder(r=id/2, h=height - (od/2) * 1.01);

    // Cutout
    if (cutout) {
       translate([-width/1.8,-od,-height*0.05])
      cube([width * 1.1, od * 1.1, height * 1.1]);
    }
  }
};

module 3_4_tee(width=3_4_tee_width,
               height=3_4_tee_height,
               od=3_4_tee_diameter,
               id=0,
               rim_od=3_4_tee_rim_od,
               rim_width=3_4_tee_rim_width,
               cutout=false) {
  $fn = 30;

  tee(width=width,
       height=height,
       od=od,
       id=id,
       rim_od=rim_od,
       rim_width=rim_width,
       cutout=cutout);
};


*3_4_tee();


scale([25.4, 25.4, 25.4])
*3_4_pipe_sleeve(wall=1/8, length=1/2, $fn=30);
