//
// Square Tube dimensions
//
BearingInnerRadius     = 1;
BearingOuterRadius     = 2;
BearingHeight          = 3;
BearingRaceRadius      = 4;
BearingFn              = 5;
BearingClearanceLoose  = 6; // Added to width, should slide freely
BearingClearanceSnug   = 7; // Added to width, should not slip (default)

function BearingClearanceSnug()  = BearingClearanceSnug;
function BearingClearanceLoose() = BearingClearanceLoose;

function BearingClearance(spec, clearance)   = (clearance != undef) ? lookup(clearance, spec) : 0;
function BearingInnerRadius(spec, clearance) = lookup(BearingInnerRadius, spec) + BearingClearance(spec, clearance);
function BearingOuterRadius(spec, clearance) = lookup(BearingOuterRadius, spec) + BearingClearance(spec, clearance);
function BearingHeight(spec)                 = lookup(BearingHeight, spec);
function BearingRaceRadius(spec)             = lookup(BearingRaceRadius, spec);
function BearingFn(spec)                     = lookup(BearingFn, spec);


// 608 Bearing
Bearing608 = [
  [BearingInnerRadius,    0.157],
  [BearingOuterRadius,    0.433],
  [BearingHeight,         0.276],
  [BearingRaceRadius,     0.2375],
  [BearingFn,             30],
  [BearingClearanceLoose, 0.02], // TODO: Verify
  [BearingClearanceSnug,  0.01], // TODO: Verify
];
function Spec_Bearing608() = Bearing608;

module Bearing2D(spec=Spec_Bearing608(), clearance=BearingClearanceSnug(), solid=false) {
  //echo(BearingInnerRadius(spec, clearance));
  difference() {
    circle(r=BearingOuterRadius(spec, clearance), $fn=BearingFn(spec));

    if (solid==false)
    circle(r=BearingInnerRadius(spec, clearance), $fn=BearingFn(spec)/2);
  }
}

module Bearing(spec=Spec_Bearing608(), clearance=BearingClearanceSnug(), solid=false) {
  linear_extrude(height=BearingHeight(spec))
  Bearing2D(spec=spec, clearance=clearance, solid=solid);
}

scale([25.4, 25.4, 25.4])
Bearing(spec=Spec_Bearing608());
