use <../Meta/Manifold.scad>;

//
// Pipe dimensions
//
PipeInnerDiameter   = 1; // Inner Diameter of pipe, smallest measurement if asymmetrical
PipeOuterDiameter   = 2; // Outer Diameter of pipe, largest measurement if asymmetrical
PipeTaperedDiameter = 3; // Threads are tapered, smallest measurement if asymmetrical
PipeThreadLength    = 4; // Total length of the pipe thread
PipeThreadDepth     = 5; // Depth when fully seated
PipeClearanceSnug   = 6; // Added to the diameter, should not slip (default)
PipeClearanceLoose  = 7; // Added to the diameter, should slide freely
PipeFn              = 8; // Number of sides
PipeWeightPerUnit   = 9;

function PipeClearanceSnug()  = PipeClearanceSnug;
function PipeClearanceLoose() = PipeClearanceLoose;


function PipeClearance(pipe, clearance) =
           (clearance != undef) ? lookup(clearance, pipe) : 0;

function PipeOuterDiameter(pipe, clearance, clearanceSign=1) =
           lookup(PipeOuterDiameter, pipe) + (PipeClearance(pipe, clearance)*clearanceSign);

function PipeInnerDiameter(pipe, clearance, clearanceSign=1) =
           lookup(PipeInnerDiameter, pipe) + (PipeClearance(pipe, clearance)*clearanceSign);

function PipeOuterRadius(pipe, clearance, clearanceSign=1) =
           PipeOuterDiameter(pipe, clearance, clearanceSign)/2;

function PipeInnerRadius(pipe, clearance, clearanceSign=1) =
           PipeInnerDiameter(pipe, clearance, clearanceSign)/2;

function PipeTaperedDiameter(pipe) =
           lookup(PipeTaperedDiameter, pipe);

function PipeTaperedRadius(pipe, clearance, clearanceSign=1) =
           PipeTaperedDiameter(pipe, clearance, clearanceSign)/2;

function PipeThreadLength(pipe) =
           lookup(PipeThreadLength, pipe);

function PipeThreadDepth(pipe) =
           lookup(PipeThreadDepth, pipe);

function PipeWall(pipe) =
           PipeOuterRadius(pipe) - PipeInnerRadius(pipe);

function PipeFn(pipe, fn) =
           (fn == undef) ? lookup(PipeFn, pipe) : fn;

function PipeOuterCircumference(pipe, clearance, clearanceSign=1) =
           3.14*PipeOuterDiameter(pipe, clearance, clearanceSign);

function PipeInnerCircumference(pipe, clearance, clearanceSign=1) =
           3.14*PipeInnerDiameter(pipe, clearance, clearanceSign);


module Pipe2d(pipe, clearance=PipeClearanceSnug(), clearanceSign=1, hollow=false, extraRadius=0, $fn=undef) {
  difference() {
    circle(r=PipeOuterRadius(pipe=pipe, clearance=clearance, clearanceSign=clearanceSign)+extraRadius,
         $fn=PipeFn(pipe, $fn));

    if (hollow)
    circle(r=PipeInnerRadius(pipe, clearance),
         $fn=PipeFn(pipe, $fn));
  }
};
module Pipe(pipe, length = 1, clearance=PipeClearanceSnug(), center=false, hollow=false) {
  translate([0,0,center ? -length/2 : 0])
  linear_extrude(height=length)
  Pipe2d(pipe=pipe, clearance=clearance, hollow=hollow);
};

//Pipe(PipeOneInch, clearance=PipeClearanceLoose);


// 1/4" Pipe
function Spec_PipeOneQuarterInch() = [
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

// 12GaugeChamber - 12ga Chamber tolerances are much pickier than ERW pipe
function Spec_12GaugeChamber() = [
  [PipeInnerDiameter,   0.78],
  [PipeFn,              30]
];

// 3/4" Sch40 Pipe
function Spec_PipeThreeQuarterInch() = [
  [PipeInnerDiameter,   0.81],
  [PipeOuterDiameter,   1.05],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.002],
  [PipeClearanceLoose,  0.01],
  [PipeFn,              30],
  [PipeWeightPerUnit,   40]
];

// 3/4" Sch80 Pipe
function Spec_PipeThreeQuarterInchSch80() = [
  [PipeInnerDiameter,   0.73],
  [PipeOuterDiameter,   1.05],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.002],
  [PipeClearanceLoose,  0.01],
  [PipeFn,              40],
  [PipeWeightPerUnit,   40]
];

// 3/4" Sch80 Stainless Pipe
function Spec_PipeThreeQuarterInchSch80Stainless() = [
  [PipeInnerDiameter,   0.76],
  [PipeOuterDiameter,   1.055],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.002],
  [PipeClearanceLoose,  0.02],
  [PipeFn,              40],
  [PipeWeightPerUnit,   40]
];

// 1" Pipe
function Spec_PipeOneInch() = [
  [PipeInnerDiameter,   1.055],
  [PipeOuterDiameter,   1.315],
  [PipeTaperedDiameter, 1.285],
  [PipeThreadLength,    0.982],
  [PipeThreadDepth,     0.5], // TODO: Verify
  [PipeClearanceSnug,   0.002],
  [PipeClearanceLoose,  0.01],
  [PipeFn,              50],
  [PipeWeightPerUnit,   0] // TODO
];

// 1" Pipe Sch80
function Spec_PipeOneInchSch80() = [
  [PipeInnerDiameter,   0.958],
  [PipeOuterDiameter,   1.315],
  [PipeTaperedDiameter, 1.285],
  [PipeThreadLength,    0.982],
  [PipeThreadDepth,     0.5], // TODO: Verify
  [PipeClearanceSnug,   0.002],
  [PipeClearanceLoose,  0.01],
  [PipeFn,              50],
  [PipeWeightPerUnit,   0] // TODO
];

// 0.375" OD DOM Tubing (Just guessing)
function Spec_TubingThreeEighthsInch() = [
  [PipeInnerDiameter,   0.23],
  [PipeOuterDiameter,   0.375],
  [PipeTaperedDiameter, 0.375],
  [PipeThreadLength,    0.0],
  [PipeThreadDepth,     0.0],
  [PipeClearanceSnug,   0.005],
  [PipeClearanceLoose,  0.022],
  [PipeFn,              20],
  [PipeWeightPerUnit,   0]
];

// 0.75x0.410" DOM Tubing (Just guessing)
function Spec_TubingZeroPointSevenFive() = [
  [PipeInnerDiameter,   0.410],
  [PipeOuterDiameter,   0.750],
  [PipeTaperedDiameter, 0.750],
  [PipeThreadLength,    0.0],
  [PipeThreadDepth,     0.0],
  [PipeClearanceSnug,   0.005],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              30],
  [PipeWeightPerUnit,   42]
];

// 1.00x0.00" DOM Tubing
function Spec_TubingOnePointZero() = [
  [PipeInnerDiameter,   0.0],
  [PipeOuterDiameter,   1.0],
  [PipeTaperedDiameter, 0],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.010],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              50],
  [PipeWeightPerUnit,   42]
];

// 1.125x0.813" DOM Tubing
function Spec_TubingOnePointOneTwoFive() = [
  [PipeInnerDiameter,   0.813],
  [PipeOuterDiameter,   1.125],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.010],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              50],
  [PipeWeightPerUnit,   42]
];

// 1.628" OD DOM Tubing
function Spec_TubingOnePointSixTwoEight() = [
  [PipeInnerDiameter,   1.125],
  [PipeOuterDiameter,   1.628],
  [PipeTaperedDiameter, 0.0],
  [PipeThreadLength,    0.0],
  [PipeThreadDepth,     0.0],
  [PipeClearanceSnug,   0.020],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              70],
  [PipeWeightPerUnit,   0]
];

// 1.628x0.1.125" DOM Tubing
function Spec_Tubing1628x1125() = [
  [PipeInnerDiameter,   1.125],
  [PipeOuterDiameter,   1.628],
  [PipeTaperedDiameter, 0.0],
  [PipeThreadLength,    0.0],
  [PipeThreadDepth,     0.0],
  [PipeClearanceSnug,   0.020],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              70],
  [PipeWeightPerUnit,   0]
];

// 5/16" Brake Line, for .22LR
function Spec_FiveSixteenthInchBrakeLine() = [
  [PipeInnerDiameter,   0.22],
  [PipeOuterDiameter,   0.3125],
  [PipeTaperedDiameter, 0.3125],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.02],
  [PipeClearanceLoose,  0.035],
  [PipeFn,              20],
  [PipeWeightPerUnit,   42]
];

// 3/4" OD x 5/8" ID Tube
function Spec_TubingThreeQuarterByFiveEighthInch() = [
  [PipeInnerDiameter,   0.645],
  [PipeOuterDiameter,   0.75],
  [PipeTaperedDiameter, 0.75],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.03],
  [PipeClearanceLoose,  0.035],
  [PipeFn,              40],
  [PipeWeightPerUnit,   0] // TODO
];

// 0.56x9mm Barrel Blank
function Spec_PointFiveSix9mmBarrel() = [
  [PipeInnerDiameter,   0.0],
  [PipeOuterDiameter,   0.56],
  [PipeTaperedDiameter, 0.56],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.020],
  [PipeClearanceLoose,  0.022],
  [PipeFn,              25],
  [PipeWeightPerUnit,   0]
];



// 2.5" Sch40 PVC (ECM Water Jacket)
function Spec_TwoPointFiveInchSch40PVC() = [
  [PipeInnerDiameter,   2.5],
  [PipeOuterDiameter,   2.88],
  [PipeTaperedDiameter, 0.0],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.020],
  [PipeClearanceLoose,  0.022],
  [PipeFn,              50],
  [PipeWeightPerUnit,   0]
];





echo (PipeOuterCircumference(Spec_PointFiveSix9mmBarrel()));


// Fittings: Tee
TeeOuterDiameter   = 1; // Diameter of the body, not the rim
TeeWidth           = 2; // Across the top of the tee, side-to-side
TeeHeight          = 3; // From the middle of the bottom rim to the top of the body
TeeHeightClearance = 4; // Range for the height
TeeInnerDiameter   = 5; // Diameter of the threaded hole
TeeRimDiameter     = 6; // Diameter of the tee rim
TeeRimWidth        = 7; // Width of the tee rim
TeeInfillSphere    = 8; // Diameter of the infill sphere, cuts out the casting infill between the tee sections
TeeInfillOffset    = 9; // Offset for the infill sphere from center

// Anvil USA 3/4" Cast Iron Pipe Tee (DANGEROUS, OUTSIDE SPEC)
function Spec_TeeThreeQuarterInch() = [
  [TeeOuterDiameter,   1.41],
  [TeeWidth,           2.64],
  [TeeHeight,          2],     // Measured 1.998-2.042
  [TeeHeightClearance, 0.022], // Derived from (height range/2)
  [TeeInnerDiameter,   0.88],
  [TeeRimDiameter,     1.54], // Measured: 1.494-1.523
  [TeeRimWidth,        0.32],
  [TeeInfillSphere,    0.10],
  [TeeInfillOffset,    0.41]
];

// Anvil USA 3/4" Forged Steel Pipe Tee
function Spec_AnvilForgedSteel_TeeThreeQuarterInch() = [
  [TeeOuterDiameter,   1.37],
  [TeeWidth,           2.765],
  [TeeHeight,          2],     // Measured 1.998-2.042
  [TeeHeightClearance, 0.022], // Derived from (height range/2)
  [TeeInnerDiameter,   0.88],
  [TeeRimDiameter,     1.556],
  [TeeRimWidth,        0.9],
  [TeeInfillSphere,    0.10],
  [TeeInfillOffset,    0.41]
];

// Chinese 304SS-150 3/4" Tee (DANGEROUS, OUTSIDE SPEC)
function Spec_304SS_150_TeeThreeQuarterInch() = [
  [TeeOuterDiameter,   1.37],
  [TeeWidth,           2.64],
  [TeeHeight,          2],     // Measured 1.998-2.042
  [TeeHeightClearance, 0.022], // Derived from (height range/2)
  [TeeInnerDiameter,   0.88],
  [TeeRimDiameter,     1.4],
  [TeeRimWidth,        0.31],
  [TeeInfillSphere,    0.10],
  [TeeInfillOffset,    0.41]
];

function TeeOuterDiameter(tee) = lookup(TeeOuterDiameter, tee);
function TeeOuterRadius(tee)   = lookup(TeeOuterDiameter, tee)/2;
function TeeWidth(tee)         = lookup(TeeWidth, tee);
function TeeHeight(tee)        = lookup(TeeHeight, tee);
function TeeInnerDiameter(tee) = lookup(TeeInnerDiameter, tee);
function TeeInnerRadius(tee)   = lookup(TeeInnerDiameter, tee)/2;
function TeeRimDiameter(tee)   = lookup(TeeRimDiameter, tee);
function TeeRimRadius(tee)     = lookup(TeeRimDiameter, tee)/2;
function TeeRimWidth(tee)      = lookup(TeeRimWidth, tee);
function TeeCenter(tee)        = lookup(TeeWidth, tee)/2; //lookup(TeeHeight, tee) - TeeOuterRadius(tee);

function TeePipeEndOffset(tee, pipe) = TeeCenter(tee)-PipeThreadDepth(pipe);

module Tee(tee, $fn=40) {
   render()
   union() {

     // Top Body
     rotate([0,-90,0])
     translate([TeeHeight(tee) - (TeeOuterDiameter(tee)/2),0,0])
     cylinder(r=TeeOuterRadius(tee), h=TeeWidth(tee) * 0.99, center=true, $fn=36);

     // Bottom Body
     translate([0,0,TeeCenter(tee) * 0.01])
     cylinder(r=TeeOuterRadius(tee), h=TeeCenter(tee) * 0.98, $fn=36);

     // Bottom Rim
     cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);


    // Rims
    for (i = [1, -1]) {

      // Rim
      translate([i*TeeWidth(tee)/2,0,TeeCenter(tee)])
      rotate([0,i*-90,0]) {
      cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);

      // Casting Infill
      translate([0,0,TeeRimWidth(tee)])
      cylinder(r1=TeeRimRadius(tee),
               r2=TeeOuterRadius(tee),
                h=0.05,
                $fn=36);
      }
    }
   }
};

module CrossFitting(tee, infill=true, hollow=false, $fn=40) {
  render()
  difference() {
    union() {

      // Horizontal Body
      rotate([0,-90,0])
      translate([TeeHeight(tee) - (TeeOuterDiameter(tee)/2),0,0])
      cylinder(r=TeeOuterRadius(tee), h=TeeWidth(tee), center=true, $fn=36);

      // Vertical Body
      cylinder(r=TeeOuterRadius(tee), h=TeeWidth(tee), $fn=36);

      // Bottom Vertical Rim
      cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);

      // Top Vertical Rim
      translate([0,0,TeeWidth(tee)-TeeRimWidth(tee)])
      cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);

      // Rims
      for (i = [1, -1]) {

        // Rim
        translate([i*TeeWidth(tee)/2,0,TeeCenter(tee)])
        rotate([0,i*-90,0]) {
          cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);

          // Rim-Body Fillet
          translate([0,0,TeeRimWidth(tee)])
          cylinder(r1=TeeRimRadius(tee),
                   r2=TeeOuterRadius(tee),
                   h=0.05,
                   $fn=36);
        }
      }

      for (n=[-1,1]) // Top of cross-fitting
      for (i=[-1,1]) { // Sides of tee-fitting

      // Body-Corner Infill
      translate([0,0,TeeCenter(tee)])
      translate([i*TeeOuterRadius(tee)/2,0,n*-TeeOuterRadius(tee)/2])
      rotate([0,n*i*45,0])
      cylinder(r=TeeOuterRadius(tee), h=0.5, center=true);
      }
    }

    if (hollow)
    translate([0,0,TeeCenter(tee)])
    for (i=[0,1])
    rotate([0,90*i,0])
    cylinder(r=TeeInnerRadius(tee), h=(TeeWidth(tee)*2)+ManifoldGap(2), center=true);
  }
};

//Tee(TeeThreeQuarterInch);

module TeeRim(tee=Spec_TeeThreeQuarterInch(), height=1, clearance=0) {
  cylinder(r=TeeRimRadius(tee) + clearance, h=height, $fn=36);
}

// Fittings: Bushings
BushingHeight    = 1;
BushingDiameter  = 2;
BushingDepth     = 3; // Bushing screws in about half an inch
BushingCapWidth  = 4;
BushingCapHeight = 5;


// 3/4" Bushing
function Spec_BushingThreeQuarterInch() = [
  [BushingHeight,    1.165],
  [BushingDiameter,  1.06], // Measured 1.05, adding clearance
  [BushingDepth,     0.48],
  [BushingCapWidth,  1.227],
  [BushingCapHeight, 0.425]
];

function BushingHeight(bushing)    = lookup(BushingHeight, bushing);
function BushingDiameter(bushing)  = lookup(BushingDiameter, bushing);
function BushingRadius(bushing)    = lookup(BushingDiameter, bushing)/2;
function BushingDepth(bushing)     = lookup(BushingDepth, bushing);
function BushingExtension(bushing) = BushingHeight(bushing) - BushingDepth(bushing);
function BushingCapWidth(bushing)  = lookup(BushingCapWidth, bushing);
function BushingCapHeight(bushing) = lookup(BushingCapHeight, bushing);

module Bushing(spec=Spec_BushingThreeQuarterInch()) {

  od        = lookup(BushingDiameter, spec);
  height    = lookup(BushingHeight, spec);
  capWidth  = lookup(BushingCapWidth, spec);
  capHeight = lookup(BushingCapHeight, spec);

  union() {

    // Body
    translate([0,0,capHeight/2])
    cylinder(r=BushingRadius(spec), h=height - (BushingCapHeight(spec)/2), $fn=20);

    // Head
    cylinder(r=BushingCapWidth(spec)/2, h=BushingCapHeight(spec), $fn=6);
  }
}

CrossFitting(Spec_AnvilForgedSteel_TeeThreeQuarterInch());
