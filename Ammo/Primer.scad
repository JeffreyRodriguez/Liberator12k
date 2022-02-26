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


// Produces no primer
function Spec_PrimerDummy() = [
  [PrimerRimDiameter,   0],
  [PrimerRimHeight,     0],
  [PrimerHeight,        0],
  [PrimerMajorDiameter, 0],
  [PrimerMinorDiameter, 0],
  [PrimerClearance,     0],
  [PrimerFn,            0]
];

// .209 type (based on Fiocchi 616)
function Spec_Primer209() = [
  [PrimerRimDiameter,   0.309],
  [PrimerRimHeight,     0.01],
  [PrimerHeight,        0.3],
  [PrimerMajorDiameter, 0.248],
  [PrimerMinorDiameter, 0.242],
  [PrimerClearance,     0.005],
  [PrimerFn,            20]
];

// .22 cal Ramset (necked variety)
function Spec_Primer22PAT() = [
  [PrimerRimDiameter,   0.275],
  [PrimerRimHeight,     0.036],
  [PrimerHeight,        0.564],
  [PrimerMajorDiameter, 0.226],
  [PrimerMinorDiameter, 0.225],
  [PrimerClearance,     0.015],
  [PrimerFn,            12]
];

// .27 cal Ramset
function Spec_Primer27PAT() = [
  [PrimerRimDiameter,   0.327],
  [PrimerRimHeight,     0.05],
  [PrimerHeight,        0.402],
  [PrimerMajorDiameter, 0.2685],
  [PrimerMinorDiameter, 0.268],
  [PrimerClearance,     0.015],
  [PrimerFn,            24]
];

// 12 gram CO2 cartridge mouth and neck
function Spec_Primer12gCO2() = [
  [PrimerRimDiameter,   0.315],
  [PrimerRimHeight,     0.24],
  [PrimerHeight,        0.29],
  [PrimerMajorDiameter, 0.315],
  [PrimerMinorDiameter, 0.76],
  [PrimerClearance,     0],
  [PrimerFn,            12]
];

function PrimerRimDiameter(primer=undef)   = lookup(PrimerRimDiameter, primer);
function PrimerRimRadius(primer=undef)     = lookup(PrimerRimDiameter, primer)/2;
function PrimerRimHeight(primer=undef)     = lookup(PrimerRimHeight, primer);
function PrimerHeight(primer=undef)        = lookup(PrimerHeight, primer);
function PrimerMajorDiameter(primer=undef) = lookup(PrimerMajorDiameter, primer);
function PrimerMajorRadius(primer=undef)   = lookup(PrimerMajorDiameter, primer)/2;
function PrimerMinorDiameter(primer=undef) = lookup(PrimerMinorDiameter, primer);
function PrimerMinorRadius(primer=undef)   = lookup(PrimerMinorDiameter, primer)/2;
function PrimerClearance(primer=undef)     = lookup(PrimerClearance, primer);
function PrimerFn(primer=undef)            = lookup(PrimerFn, primer);

function PrimerOAHeight(primer=undef) = lookup(PrimerHeight, primer) + lookup(PrimerRimHeight, primer);

module Primer(primer=Spec_Primer27PAT(), extend=0.001) {
  render()
  union() {

    // Rim
    translate([0,0,-extend])
    cylinder(r=(PrimerRimDiameter(primer)+PrimerClearance(primer))/2,
      h=PrimerRimHeight(primer) + extend,
      $fn=PrimerFn(primer));

    // Rim Taper
    translate([0,0,PrimerRimHeight(primer)])
    cylinder(r1=(PrimerRimDiameter(primer)+PrimerClearance(primer))/2,
      r2=0,
      h=(PrimerRimDiameter(primer)+PrimerClearance(primer))/2,
      $fn=PrimerFn(primer));

    // Primer
    cylinder(r1=(PrimerMajorDiameter(primer) + PrimerClearance(primer))/2,
             r2=(PrimerMinorDiameter(primer) + PrimerClearance(primer))/2,
             h=PrimerHeight(primer),
             $fn=PrimerFn(primer));
  }
}

scale([25.4, 25.4, 25.4]) Primer();
