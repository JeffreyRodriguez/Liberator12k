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
PipeCapDiameter     = 10;
PipeCapLength       = 11;
PipeCapDepth        = 12;

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

function PipeTaperedDiameter(pipe, clearance, clearanceSign) =
           lookup(PipeTaperedDiameter, pipe) + (PipeClearance(pipe, clearance)*clearanceSign);

function PipeTaperedRadius(pipe, clearance, clearanceSign=1) =
           PipeTaperedDiameter(pipe, clearance, clearanceSign)/2;

function PipeThreadLength(pipe) =
           lookup(PipeThreadLength, pipe);

function PipeThreadDepth(pipe) =
           lookup(PipeThreadDepth, pipe);

function PipeWall(pipe) =
           PipeOuterRadius(pipe) - PipeInnerRadius(pipe);

function PipeFn(pipe=undef, fn) =
           (fn == undef) ? lookup(PipeFn, pipe) : fn;

function PipeOuterCircumference(pipe, clearance, clearanceSign=1) =
           PI*PipeOuterDiameter(pipe, clearance, clearanceSign);

function PipeInnerCircumference(pipe, clearance, clearanceSign=1) =
           PI*PipeInnerDiameter(pipe, clearance, clearanceSign);

function PipeCapDiameter(pipe, clearance, clearanceSign=1) = lookup(PipeCapDiameter, pipe) + (PipeClearance(pipe, clearance)*clearanceSign);
function PipeCapRadius(pipe, clearance, clearanceSign=1) = PipeCapDiameter(pipe, clearance, clearanceSign)/2;
function PipeCapLength(pipe) = lookup(PipeCapLength, pipe);
function PipeCapDepth(pipe) = lookup(PipeCapDepth, pipe);


module Pipe2d(pipe, clearance=PipeClearanceSnug(), clearanceSign=1, hollow=false, extraRadius=0, $fn=undef) {
  difference() {
    circle(r=PipeOuterRadius(pipe=pipe, clearance=clearance, clearanceSign=clearanceSign)+extraRadius,
         $fn=PipeFn(pipe, $fn));

    if (hollow)
    circle(r=PipeInnerRadius(pipe, clearance),
         $fn=PipeFn(pipe, $fn));
  }
};

module Pipe(pipe, length = 1, clearance=PipeClearanceSnug(),
            center=false, hollow=false, taperBottom=false, taperTop=false) {
  translate([0,0,(center ? -length/2 : 0)])
  difference() {
    linear_extrude(height=length)
    Pipe2d(pipe=pipe, clearance=clearance, hollow=hollow);

    if (taperBottom)
    PipeTaperCutter(pipe, clearance);

    if (taperTop)
    translate([0,0,length])
    mirror([0,0,1])
    PipeTaperCutter(pipe, clearance);
  }
};

module PipeTaperCutter(pipe, clearance=undef, clearanceSign=1) {
  translate([0,0,-ManifoldGap()])
  difference() {
    linear_extrude(height=PipeThreadLength(pipe))
    Pipe2d(pipe=pipe, extraRadius=PipeWall(pipe), hollow=false);

    cylinder(r1=PipeTaperedRadius(pipe, clearance),
             r2=PipeOuterRadius(pipe, clearance),
              h=PipeThreadLength(pipe),
             $fn=PipeFn(pipe));
  }
}


// 12GaugeChamber - 12ga Chamber tolerances are much pickier than ERW pipe
function Spec_12GaugeChamber() = [
  [PipeInnerDiameter,   0.78],
  [PipeFn,              30]
];

// 1/8" Pipe
function Spec_PipeOneEighthInch() = [
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

// 1/4" Pipe
function Spec_PipeOneQuarterInch() = [
  [PipeInnerDiameter,   0.336],
  [PipeOuterDiameter,   0.534],
  [PipeTaperedDiameter, 0.440],
  [PipeThreadLength,    0.445],
  [PipeThreadDepth,     0.247],
  [PipeClearanceSnug,   0.015],
  [PipeClearanceLoose,  0.025],
  [PipeFn,              30],
  [PipeWeightPerUnit,   40]
];

// 3/8" Sch40 Pipe
function Spec_PipeThreeEighthsInch() = [
  [PipeInnerDiameter,   0.470],
  [PipeOuterDiameter,   0.676],
  [PipeTaperedDiameter, 0.587],
  [PipeThreadLength,    0.554],
  [PipeThreadDepth,     0.247], // FIXME: Just wrong
  [PipeClearanceSnug,   0.015],
  [PipeClearanceLoose,  0.025],
  [PipeFn,              30],
  [PipeWeightPerUnit,   40] // FIXME: Just wrong
];

// 1/2" Sch40 Pipe
function Spec_PipeOneHalfInch() = [
  [PipeInnerDiameter,   0.678],
  [PipeOuterDiameter,   0.876],
  [PipeTaperedDiameter, 0.829],
  [PipeThreadLength,    0.767],
  [PipeThreadDepth,     0.247], // FIXME: Just wrong
  [PipeClearanceSnug,   0.015],
  [PipeClearanceLoose,  0.025],
  [PipeFn,              30],
  [PipeWeightPerUnit,   40] // FIXME: Just wrong
];

// 3/4" Sch40 Pipe
function Spec_PipeThreeQuarterInch() = [
  [PipeInnerDiameter,   0.81],
  [PipeOuterDiameter,   1.05],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.015],
  [PipeClearanceLoose,  0.02],
  [PipeFn,              50],
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
  [PipeOuterDiameter,   1.325],
  [PipeTaperedDiameter, 1.285],
  [PipeThreadLength,    0.982],
  [PipeThreadDepth,     0.5], // TODO: Verify
  [PipeClearanceSnug,   0.015],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              50],
  [PipeWeightPerUnit,   0] // TODO
];

// 1" NPT Pipe Schedule 80
function Spec_PipeOneInchSch80() = [
  [PipeInnerDiameter,   0.958],
  [PipeOuterDiameter,   1.315],
  [PipeTaperedDiameter, 1.285],
  [PipeThreadLength,    0.982],
  [PipeThreadDepth,     0.5], // TODO: Verify
  [PipeClearanceSnug,   0.002],
  [PipeClearanceLoose,  0.01],
  [PipeFn,              50],
  [PipeWeightPerUnit,   0], // TODO
  [PipeCapDiameter,     1.75], // TODO: Verify
  [PipeCapLength,       1.5],   // TODO: Verify
  [PipeCapDepth,        1.15]
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
  [PipeTaperedDiameter, 0.70],
  [PipeThreadLength,    0.5],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.005],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              30],
  [PipeWeightPerUnit,   42]
];

// 1.00x0.813" DOM Tubing
function Spec_TubingOnePointZero() = [
  [PipeInnerDiameter,   0.813],
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
  [PipeClearanceSnug,   0.015],
  [PipeClearanceLoose,  0.025],
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

// 1 1/2" Sch40 ABS
function Spec_OnePointFiveSch40ABS() = [
  [PipeInnerDiameter,   1.6],
  [PipeOuterDiameter,   1.905],
  [PipeTaperedDiameter, 0.0],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.005],
  [PipeClearanceLoose,  0.01],
  [PipeFn,              60],
  [PipeWeightPerUnit,   0]
];

// 1 3/4" Polycarbonate Tubing
function Spec_OnePointSevenFivePCTube() = [
  [PipeInnerDiameter,   1.5],
  [PipeOuterDiameter,   1.75],
  [PipeTaperedDiameter, 0.0],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.005],
  [PipeClearanceLoose,  0.01],
  [PipeFn,              60],
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
