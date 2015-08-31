//
// Primer dimensions
//

PrimerRimDiameter   = 1; // Diameter of the rim
PrimerRimHeight     = 2; // Height of the rim
PrimerHeight        = 3; // Total height of the primer
PrimerMajorDiameter = 4; // Measured just above the rim of the primer
PrimerMinorDiameter = 5; // Measured near the tip of the primer
PrimerClearance     = 6; // Extra clearance for fitting
PrimerFn            = 7; // Sides, for rendering

// .209 type (based on Fiocchi 616)
Primer209 = [
  [PrimerRimDiameter,   0.309],
  [PrimerRimHeight,     0.01],
  [PrimerHeight,        0.3],
  [PrimerMajorDiameter, 0.248],
  [PrimerMinorDiameter, 0.242],
  [PrimerClearance,     0.021],
  [PrimerFn,            50]
];

PrimerDummy = [
  [PrimerRimDiameter,   0],
  [PrimerRimHeight,     0],
  [PrimerHeight,        0],
  [PrimerMajorDiameter, 0],
  [PrimerMinorDiameter, 0],
  [PrimerClearance,     0],
  [PrimerFn,            0]
];


module Primer(primer=Primer209, extend=0.1) {
  render()
  union() {

    // Primer
    translate([0,0,lookup(PrimerRimHeight, primer)])
    cylinder(r1=(lookup(PrimerMajorDiameter, primer) + lookup(PrimerClearance, primer))/2,
             r2=(lookup(PrimerMinorDiameter, primer) + lookup(PrimerClearance, primer))/2,
             h=lookup(PrimerHeight, primer) + 0.1,
             $fn=lookup(PrimerFn, primer));

    // Primer Rim
    translate([0,0,-extend])
    cylinder(r=(lookup(PrimerRimDiameter, primer)+lookup(PrimerClearance, primer))/2,
             h=lookup(PrimerRimHeight, primer) + extend,
             $fn=lookup(PrimerFn, primer));

    // Primer Rim Taper
    translate([0,0,lookup(PrimerRimHeight, primer)])
    cylinder(r1=(lookup(PrimerRimDiameter, primer)+lookup(PrimerClearance, primer))/2,
             r2=(lookup(PrimerMajorDiameter, primer)+lookup(PrimerClearance, primer))/2,
             h=lookup(PrimerRimHeight, primer),
             $fn=lookup(PrimerFn, primer));
  }
}

// scale([25.4, 25.4, 25.4]) Primer();
