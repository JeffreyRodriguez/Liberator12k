// 1/8" Rod
1_8_rod_d         = 1/8;
1_8_rod_r         = 1_8_rod_d/2;
1_8_rod_clearance = 0.03; // TODO

// 1/4" Rod
1_4_rod_d         = 1/4;
1_4_rod_r         = 1_4_rod_d/2;
1_4_rod_clearance = 0.02; // TODO

// 5/16" Rod
5_16_rod_d         = 5/16;
5_16_rod_r         = 5_16_rod_d/2;
5_16_rod_clearance = 0.02; // TODO

module rod(diameter=1, length=1, clearance=0, cutter=false, $fn=20) {
  if (cutter) {
    cylinder(r=(diameter+clearance)/2, h=length);
  } else {
    cylinder(r=diameter/2, h=length);
  }
}

module 1_8_rod(length=1, cutter=false) {
  rod(diameter=1_8_rod_d, clearance=1_8_rod_clearance, length=length, cutter=cutter);
}

module 1_4_rod(length=1, cutter=false) {
  rod(diameter=1_4_rod_d, clearance=1_4_rod_clearance, length=length, cutter=cutter);
}

module 5_16_rod(length=1, cutter=false) {
  rod(diameter=5_16_rod_d, clearance=5_16_rod_clearance, length=length, cutter=cutter);
}
