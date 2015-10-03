RodDiameter       = 1;
RodRadius         = 2;
RodClearanceSnug  = 3;
RodClearanceLoose = 4;
RodFn             = 5;

RodOneEighthInch = [
  [RodDiameter, 1/8],
  [RodRadius, 1/8/2],
  [RodClearanceSnug, 0.02],
  [RodClearanceLoose, 0.03],
  [RodFn, 8]
];

RodOneQuarterInch = [
  [RodDiameter,       1/4],
  [RodRadius,         1/4/2],
  [RodClearanceSnug,  0.027],
  [RodClearanceLoose, 0.035],
  [RodFn,             8]
];

RodFiveSixteenthInch = [
  [RodDiameter,       5/16],
  [RodRadius,         5/16/2],
  [RodClearanceSnug,  0.025],
  [RodClearanceLoose, 0.025],
  [RodFn,             10]
];

RodThreeQuarterInchTubing = [
  [RodDiameter,       0.758],
  [RodRadius,         0.758/2],
  [RodClearanceSnug,  0.023],
  [RodClearanceLoose, 0.029],
  [RodFn,             30]
];

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
function RodRadius(rod, clearance=undef) = RodDiameter(rod, clearance)/2;

/**
 * Lookup the $fn value for a rod, optionally overriding it
 * @param rod The rod to lookup.
 * @param $fn Override the RodFn. If defined, this will be the result. (convenience arg)
 **/
function RodFn(rod, $fn=undef) = ($fn == undef) ? lookup(RodFn, rod) : $fn;

/**
 * A 2D rod (circle).
 * @param rod The rod to render.
 * @param clearance The RodClearance to use.
 * @param $fn Override the RodFn value of the rod.
 */
module Rod2d(rod=RodOneQuarterInch, clearance=undef, $fn=undef) {
  circle(r=RodRadius(rod, clearance),
         $fn=RodFn(rod, $fn));
}


module Rod(rod=RodOneQuarterInch, length=1, clearance=undef, center=false, $fn=undef) {
  render(convexity=1)
  linear_extrude(height=length, center=center)
  Rod2d(rod, clearance, $fn=$fn);
}

// 1/8" Rod
1_8_rod_d                = 1/8;
1_8_rod_r                = 1_8_rod_d/2;
1_8_rod_clearance        = 0.02;
1_8_rod_clearance_loose  = 0.03;

// 1/4" Rod
1_4_rod_d                = 1/4;
1_4_rod_r                = 1_4_rod_d/2;
1_4_rod_clearance        = 0.01;
1_4_rod_clearance_loose  = 0.015;
1_4_rod_collar_d         = 1/22;
1_4_rod_collar_width     = 0.27;
1_4_rod_collar_clearance = 0.0; // TODO

// 5/16" Rod
5_16_rod_d                = 5/16;
5_16_rod_r                = 5_16_rod_d/2;
5_16_rod_clearance        = 0.02; // TODO
5_16_rod_clearance_loose  = 0.02;

module rod(diameter=1, length=1, clearance=0, clearance_loose=0, loose=false, cutter=false, center=false, $fn=20) {
  clearance = loose ? clearance_loose : clearance;

  if (cutter) {
    cylinder(r=(diameter/2) + (loose ? clearance_loose : clearance), h=length, center=center);
  } else {
    cylinder(r=diameter/2, h=length, center=center);
  }
}

module 1_8_rod(length=1, loose=false, cutter=false, center=false) {
  rod(diameter=1_8_rod_d,
      clearance=1_8_rod_clearance,
      clearance_loose=1_8_rod_clearance_loose,
      length=length,
      cutter=cutter,
      center=center);
}

module 1_4_rod(length=1, loose=false, cutter=false, center=false) {
  rod(diameter=1_4_rod_d,
      clearance=1_4_rod_clearance,
      clearance_loose=1_4_rod_clearance_loose,
      loose=loose,
      length=length,
      cutter=cutter,
      center=center);
}

module 1_4_rod_collar(cutter=false) {
  rod(diameter=1_4_rod_collar_d,
      clearance=1_4_rod_collar_clearance,
      cutter=cutter,
      length=1_4_rod_collar_width);
}

module 5_16_rod(length=1, loose=false, cutter=false, center=false) {
  rod(diameter=5_16_rod_d,
      clearance=5_16_rod_clearance,
      clearance_loose=5_16_rod_clearance_loose,
      length=length,
      cutter=cutter,
      center=center);
}
