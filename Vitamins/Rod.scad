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
  [RodFn, 16]
];

RodOneQuarterInch = [
  [RodDiameter,       1/4],
  [RodRadius,         1/4/2],
  [RodClearanceSnug,  0.01],
  [RodClearanceLoose, 0.015],
  [RodFn,             20]
];

module Rod2d(rod=RodOneQuarterInch, clearance=undef, center=false) {
  clearRadius = clearance != undef ? lookup(clearance, rod)/2 : 0;

  circle(r=lookup(RodDiameter, rod)/2 + clearRadius,
         center=center,
         $fn=lookup(RodFn, rod));
}


module Rod(rod=RodOneQuarterInch, length=1, clearance=undef, center=false) {
  clearRadius = clearance != undef ? lookup(clearance, rod)/2 : 0;

  cylinder(r=lookup(RodDiameter, rod)/2 + clearRadius,
           h=length,
           center=center,
           $fn=lookup(RodFn, rod));
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
