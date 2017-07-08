use <../Components/Teardrop.scad>;

RodDiameter       = 1;
RodRadius         = 2;
RodClearanceSnug  = 3;
RodClearanceLoose = 4;
RodFn             = 5;

/**
 * Lookup the diameter of a rod.
 * @param rod The rod to lookup.
 * @param clearance The RodClearance to use.
 */
function RodDiameter(rod=undef, clearance=undef)
           = lookup(RodDiameter, rod)
          + (clearance != undef ? lookup(clearance, rod) : 0);

/**
 * Lookup the radius of a rod.
 * @param rod The rod to lookup.
 * @param clearance The RodClearance to use.
 */
function RodRadius(rod=undef, clearance=undef) = RodDiameter(rod, clearance)/2;

/**
 * Lookup the $fn value for a rod, optionally overriding it
 * @param rod The rod to lookup.
 * @param $fn Override the RodFn. If defined, this will be the result. (convenience arg)
 **/
function RodFn(rod=undef, fn=undef) = ($fn == undef) ? lookup(RodFn, rod) : fn;

function RodClearanceSnug()  = RodClearanceSnug;
function RodClearanceLoose() = RodClearanceLoose;

/**
 * A 2D rod (circle).
 * @param rod The rod to render.
 * @param clearance The RodClearance to use.
 * @param $fn Override the RodFn value of the rod.
 */
module Rod2d(rod=Spec_RodOneQuarterInch(), clearance=undef, extraWall=0, teardrop=false, teardropRotation=0, teardropTruncated=true, $fn=undef) {
  if (teardrop) {
    Teardrop(r=RodRadius(rod, clearance)+extraWall,
      rotation=teardropRotation,
      truncated=teardropTruncated,
           $fn=RodFn(rod=rod, fn=$fn));
  } else {
    circle(r=RodRadius(rod, clearance)+extraWall,
         $fn=RodFn(rod=rod, fn=$fn));
  }
}


module Rod(rod=Spec_RodOneQuarterInch(), length=1, clearance=undef, center=false, teardrop=false, teardropRotation=0, teardropTruncated=true, $fn=undef) {
  render(convexity=1)
  linear_extrude(height=length, center=center)
  Rod2d(rod=rod, clearance=clearance, teardrop=teardrop, teardropRotation=teardropRotation, teardropTruncated=teardropTruncated, $fn=$fn);
}

function Spec_RodBicNozzle() = [
  [RodDiameter, 0.093],
  [RodRadius, 0.093/2],
  [RodClearanceSnug, 0.04],
  [RodClearanceLoose, 0.06],
  [RodFn, 5]
];

function Spec_RodBicFlint() = [
  [RodDiameter, 0.0985],
  [RodRadius, 0.0985/2],
  [RodClearanceSnug, 0.04],
  [RodClearanceLoose, 0.06],
  [RodFn, 5]
];

function Spec_RodOneEighthInch() = [
  [RodDiameter, 1/8],
  [RodRadius, 1/8/2],
  [RodClearanceSnug, 0.01],
  [RodClearanceLoose, 0.02],
  [RodFn, 8]
];

function Spec_RodThreeSixteenthInch() = [
  [RodDiameter,       3/16],
  [RodRadius,         3/16/2],
  [RodClearanceSnug,  0.027],
  [RodClearanceLoose, 0.035],
  [RodFn,             16]
];

function Spec_RodOneQuarterInch() = [
  [RodDiameter,       1/4],
  [RodRadius,         1/4/2],
  [RodClearanceSnug,  0.027],
  [RodClearanceLoose, 0.035],
  [RodFn,             12]
];

function Spec_RodOneHalfInch() = [
  [RodDiameter,       1/2],
  [RodRadius,         1/2/2],
  [RodClearanceSnug,  0.027],
  [RodClearanceLoose, 0.035],
  [RodFn,             24]
];

function Spec_RodFiveSixteenthInch() = [
  [RodDiameter,       5/16],
  [RodRadius,         5/16/2],
  [RodClearanceSnug,  0.022],
  [RodClearanceLoose, 0.025],
  [RodFn,             16]
];

function Spec_RodNineSixteenthInch() = [
  [RodDiameter,       9/16],
  [RodRadius,         9/16/2],
  [RodClearanceSnug,  0.027],
  [RodClearanceLoose, 0.035],
  [RodFn,             24]
];

function Spec_RodThreeQuarterInch() = [
  [RodDiameter,       3/4],
  [RodRadius,         3/4/2],
  [RodClearanceSnug,  0.027],
  [RodClearanceLoose, 0.035],
  [RodFn,             24]
];

function Spec_RodThreeQuarterInchTubing() = [
  [RodDiameter,       0.758],
  [RodRadius,         0.758/2],
  [RodClearanceSnug,  0.023],
  [RodClearanceLoose, 0.029],
  [RodFn,             30]
];

function Spec_RodOnePointZeroInch() = [
  [RodDiameter,       1.0],
  [RodRadius,         1.0/2],
  [RodClearanceSnug,  0.023],
  [RodClearanceLoose, 0.029],
  [RodFn,             50]
];


function Spec_RodOnePointOneTwoFiveInch() = [
  [RodDiameter,       1.125],
  [RodRadius,         1.125/2],
  [RodClearanceSnug,  0.023],
  [RodClearanceLoose, 0.029],
  [RodFn,             50]
];
