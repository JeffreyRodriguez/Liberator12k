include <../Meta/Common.scad>;

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

// Anvil USA 3/4" Forged Steel Pipe Tee 2104
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

// Anvil USA 1" Forged Steel Pipe Tee 2104
function Spec_AnvilForgedSteel_OneInch() = [
  [TeeOuterDiameter,   1.625],
  [TeeWidth,           3.175],
  [TeeHeight,          2],     // Measured 1.998-2.042
  [TeeHeightClearance, 0.022], // Derived from (height range/2)
  [TeeInnerDiameter,   1.313],
  [TeeRimDiameter,     1.92],
  [TeeRimWidth,        0.9],
  [TeeInfillSphere,    0.10],
  [TeeInfillOffset,    0.41]
];

// Anvil USA 3/4" Forged Steel Pipe Tee 2114
function Spec_AnvilForgedSteel_TeeThreeQuarterInch3k() = [
  [TeeOuterDiameter,   1.625],
  [TeeWidth,           3.175],
  [TeeHeight,          2.05],     // Measured 1.998-2.042
  [TeeHeightClearance, 0.022], // Derived from (height range/2)
  [TeeInnerDiameter,   0.88],
  [TeeRimDiameter,     1.92],
  [TeeRimWidth,        0.9],
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
     translate([TeeCenter(tee),0,0])
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
*Tee(Spec_AnvilForgedSteel_OneInch());



module CrossFitting(tee, infill=true, hollow=false, $fn=40) {
  render()
  difference() {
    union() {

      // Horizontal Body
      translate([0,0, TeeCenter(tee)])
      rotate([0,-90,0])
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


      hull()
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

module TeeRim(tee=Spec_AnvilForgedSteel_OneInch(), height=1, clearance=0) {
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
// 1" Bushing
function Spec_BushingOneInch() = [
  [BushingHeight,    1.306],
  [BushingDiameter,  1.313], // Measured 1.05, adding clearance
  [BushingDepth,     0.59],
  [BushingCapWidth,  1.528],
  [BushingCapHeight, 0.514]
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

module PipeCap(spec=Spec_PipeOneInchSch80(), hollow=true, clearance=undef, clearanceSign=1) {
    render()
    difference() {
        cylinder(r=PipeCapRadius(pipe=spec,
                 clearance=clearance,
                 clearanceSign=clearanceSign),
                 h=PipeCapLength(spec),
                 $fn=PipeFn(spec)*2);

        if (hollow)
        translate([0,0,PipeCapLength(spec)-PipeCapDepth(spec)])
        cylinder(r=PipeOuterRadius(pipe=spec,
                 clearance=clearance,
                 clearanceSign=clearanceSign),
                 h=PipeCapLength(spec),
                 $fn=PipeFn(spec)*2);
    }
}

DEFAULT_PIPE = Spec_PipeOneInchSch80();

PipeCap(spec=DEFAULT_PIPE);

translate([0,0,PipeCapLength(DEFAULT_PIPE)-PipeThreadDepth(DEFAULT_PIPE)])
!Pipe(pipe=Spec_PipeThreeEighthsInch(), length=2, clearance=PipeClearanceLoose(),
      taperBottom=true);


*CrossFitting(Spec_AnvilForgedSteel_TeeThreeQuarterInch3k(), hollow=true);
*CrossFitting(Spec_AnvilForgedSteel_OneInch(), hollow=true);
