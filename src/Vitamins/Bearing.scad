include <../Meta/Common.scad>;


// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// *************
// * Constants *
// *************
BearingInnerDiameter     = 1;
BearingOuterDiameter     = 2;
BearingWidth             = 3;
BearingRaceDiameter      = 4;

// *************
// * Accessors *
// *************
function BearingClearanceSnug()  = Inches(0.01);
function BearingClearanceLoose() = Inches(0.02);

function BearingInnerDiameter(spec, clearance) = lookup(BearingInnerDiameter, spec) + clearance;
function BearingInnerRadius(spec, clearance)   = BearingInnerDiameter(spec, clearance)/2;

function BearingOuterDiameter(spec, clearance) = lookup(BearingOuterDiameter, spec) + clearance;
function BearingOuterRadius(spec, clearance)   = BearingOuterDiameter(spec, clearance)/2;

function BearingRaceDiameter(spec)             = lookup(BearingRaceDiameter, spec)/2;
function BearingRaceRadius(spec)               = BearingRaceDiameter(spec)/2;

function BearingWidth(spec)                    = lookup(BearingWidth, spec);

// *********
// * Specs *
// *********

// 608 Bearing
function Spec_Bearing608() = [
  [BearingInnerDiameter,    Millimeters(8)],
  [BearingOuterDiameter,    Millimeters(22)],
  [BearingWidth,            Millimeters(7)],
  [BearingRaceDiameter,     Millimeters(12)],
];

// 623 Bearing
function Spec_Bearing623() = [
  [BearingInnerDiameter,    Millimeters(3)],
  [BearingOuterDiameter,    Millimeters(10)],
  [BearingWidth,            Millimeters(8)],
  [BearingRaceDiameter,     Millimeters(5.2)],
];

// ***********
// * Modules *
// ***********
module Bearing2D(spec=Spec_Bearing608(), clearance=0, solid=false) {
  difference() {
    circle(r=BearingOuterRadius(spec, clearance));

    if (solid==false)
    circle(r=BearingInnerRadius(spec, clearance));
  }
}

module Bearing(spec=Spec_Bearing608(),
               clearance=0,
               extraHeight=0,
               solid=false, center=false) {
  color("SteelBlue")
  render()
  linear_extrude(height=BearingWidth(spec)+extraHeight, center=center)
  Bearing2D(spec=spec, clearance=clearance, solid=solid);
}

scale([25.4, 25.4, 25.4])
Bearing(spec=Spec_Bearing608());
