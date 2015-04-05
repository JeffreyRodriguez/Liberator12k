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
