//
// Square Tube dimensions
//
SquareTubeInner           = 1;
SquareTubeOuter           = 2;
SquareTubeCornerRadius    = 3;
SquareTubeClearanceLoose  = 4; // Added to width, should slide freely
SquareTubeClearanceSnug   = 5; // Added to width, should not slip (default)
SquareTubeWeightPerUnit   = 6;

function SquareTubeClearanceSnug()  = SquareTubeClearanceSnug;
function SquareTubeClearanceLoose() = SquareTubeClearanceLoose;

function SquareTubeClearance(spec, clearance) = (clearance != undef) ? lookup(clearance, spec) : 0;
function SquareTubeInner(spec, clearance)     = lookup(SquareTubeInner, spec) + SquareTubeClearance(spec, clearance);
function SquareTubeOuter(spec, clearance)     = lookup(SquareTubeOuter, spec) + SquareTubeClearance(spec, clearance);
function SquareTubeCornerRadius(spec)         = lookup(SquareTubeCornerRadius, spec);
function SquareTubeWall(spec)                 = (SquareTubeOuter(spec) - SquareTubeInner(spec))/2;


// 1" Square Tube
SquareTubeOneInch = [
  [SquareTubeInner,          0.87],
  [SquareTubeOuter,          1],
  [SquareTubeCornerRadius,   0.11],
  [SquareTubeClearanceLoose, 0.015], // TODO: Verify
  [SquareTubeClearanceSnug,  0.01], // TODO: Verify
  [SquareTubeWeightPerUnit,  0] // TODO
];
function Spec_SquareTubeOneInch() = SquareTubeOneInch;

module Tubing2D(spec=Spec_SquareTubeOneInch(), clearance=SquareTubeClearanceSnug(), hollow=false) {
  union() {
    difference() {
      square([SquareTubeOuter(spec, clearance), SquareTubeOuter(spec, clearance)]);

      if (hollow==true)
      translate([SquareTubeWall(spec),SquareTubeWall(spec),0])
      square([SquareTubeInner(spec), SquareTubeInner(spec)]);
    }

    // Corner chamfers
    for (i=[[SquareTubeWall(spec),SquareTubeWall(spec),0],
            [SquareTubeInner(spec)+SquareTubeWall(spec),SquareTubeWall(spec),90],
            [SquareTubeInner(spec)+SquareTubeWall(spec),SquareTubeInner(spec)+SquareTubeWall(spec),180],
            [SquareTubeWall(spec),SquareTubeInner(spec)+SquareTubeWall(spec),-90]]) {
      translate([i[0],i[1]])
      rotate([0,0,i[2]])
      polygon([[0,0], [SquareTubeCornerRadius(spec),0], [0, SquareTubeCornerRadius(spec)]]);
    }
  }
}


Tubing2D(spec=Spec_SquareTubeOneInch(), hollow=true);

module TubingInsert2D(spec=Spec_SquareTubeOneInch()) {
  difference() {
    square([tubingInner,tubingInner]);

    // Corner chamfers
    for (i=[[0,0,0],
             [tubingInner,0,90],
             [tubingInner,tubingInner,180],
             [0,tubingInner,-90]]) {
      translate([i[0],i[1]])
      rotate([0,0,i[2]])
      polygon([[0,0], [SquareTubeCornerRadius(spec),0], [0, SquareTubeCornerRadius(spec)]]);
    }
  }
}

//TubingInsert2D();
