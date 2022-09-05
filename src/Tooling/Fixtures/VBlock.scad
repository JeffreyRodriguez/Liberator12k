include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Cutaway.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;
use <../../Meta/Conditionals/MirrorIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/MLOK.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
/* [Export] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["","Fixtures/VBlock","Fixtures/VBlock_Arm","Fixtures/VBlock_Arm_Barrel","Fixtures/VBlock_Arm_Sleeve"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Vitamins] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

ARM_HOLE_DIAMETER = 1.0001;
ARM_HOLE_CLEARANCE = 0.0201;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=0.5);

// Settings: Vitamins
function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

module Fixture_VBlock() {
  length = Inches(3);
  width = Inches(0.75);
  armWidth = Inches(0.51);
  sideWidth = Inches(0.75);

  baseHeight = Inches(0.75);
  height = 0.5+baseHeight;
  clearance = Inches(0.002);
  CR = Inches(1/16);

  vBottomZ = Inches(0.5);

  alignmentArmWidth = Inches(0.375);
  alignmentArmHeight = Inches(0.375);

  wall = 0.5;

  difference() {

    union() {

      // Main v-block support
      translate([0,-1,0])
      ChamferedCube([width, 2, height], r=CR);

      // Side v-block support
      translate([width+armWidth,-1,0])
      ChamferedCube([sideWidth, 2, height], r=CR);

      // Connector block
      translate([0,-(Inches(1/2)/2),0])
      ChamferedCube([width+armWidth+sideWidth, Inches(1/2), Inches(1/2)], r=CR);

      // Main Alignment Arm
      translate([0,-1,0])
      ChamferedCube([alignmentArmWidth, length, alignmentArmHeight], r=CR);

      // Side Alignment Arm
      translate([width+armWidth+sideWidth-alignmentArmWidth,-1,0])
      ChamferedCube([alignmentArmWidth, length, alignmentArmHeight], r=CR);
    }

    // V Cutout
    translate([-CR-ManifoldGap(),0,vBottomZ])
    rotate([45,0,0])
    ChamferedCube([width+armWidth+sideWidth+(CR*2)+ManifoldGap(),2,2], r=CR, teardropXYZ=[false,false,false]);

    // T-Slot Bolt Holes
    for (X = [(width/2), width+armWidth+(sideWidth/2)])
    translate([X,0,Inches(0.5)])
    Bolt(GPBolt(), length=1, head="flat", capOrientation=true, capHeightExtra=1, clearance=0.008);

    // Alignment Pins
    for (X = [+(alignmentArmWidth/2), (width+armWidth+sideWidth)-(alignmentArmWidth/2)])
    translate([X,1.75+Millimeters(2.5/2),0])
    cylinder(r=Millimeters(2.5/2), h=height);

    // Locating pin
    translate([0,0,height-Inches(0.5)])
    cylinder(r=Millimeters(2.5/2), h=height+ManifoldGap(2));

    // Arm Pins
    for (Y = [0.625, -0.625]) {

      // Main block
      translate([0,Y,Inches(0.375)])
      rotate([0,90,0])
      ChamferedCircularHole(r1=(0.255/2), h=width, teardropTop=true);

      // Side side block
      translate([width+armWidth,Y,Inches(0.375)])
      rotate([0,90,0])
      ChamferedCircularHole(r1=(0.255/2), h=sideWidth, teardropTop=true);
    }
  }
}

module Fixture_VBlock_Arm(r=Inches(ARM_HOLE_DIAMETER/2), clearance=ARM_HOLE_CLEARANCE, vbolt) {

  diameter = r*2;
  width = Inches(0.875);
  armWidth = Inches(0.5);

  baseHeight = Inches(0.75);
  height = Inches(0.5)+baseHeight;
  thumbscrewExtension = 0.4375;
  CR = Inches(1/16);

  vBottomZ = Inches(0.5);

  alignmentArmWidth = Inches(0.375);
  alignmentArmHeight = Inches(0.375);

  armRadius = baseHeight-Inches(1/8)-Inches(0.005);
  wall = Inches(0.25);

  difference() {
    hull() {

        // Arm Pin Support
        for (Y = [Inches(0.255), -Inches(0.255)-Inches(0.75)])
        translate([0,Y,Inches(1/16)])
        ChamferedCube([armWidth, Inches(0.75), vBottomZ+r], r=CR);

        // Tube Support
        translate([0,0,baseHeight+r])
        rotate([0,90,0])
        ChamferedCylinder(r1=r+wall, r2=CR, h=armWidth,
                          teardropTop=true);

        // Clamp Screw Support
        translate([0,0,vBottomZ+(r*sqrt(2))])
        for (R = [-1,1]) rotate([R*45,0,0])
        translate([0,-Inches(0.25), r])
        ChamferedCube([armWidth, Inches(0.5), thumbscrewExtension], r=CR);
    }

    // Tube Cutout
    translate([0,0,vBottomZ+(r*sqrt(2))])
    rotate([0,90,0])
    ChamferedCircularHole(r1=r+clearance, r2=CR, h=armWidth);

    // Bridge cutout section
    translate([armWidth,-Inches(0.51/2),0])
    rotate([0,-90,0])
    ChamferedSquareHole([Inches(0.51), Inches(0.51)], chamferRadius=CR, length=armWidth, center=false, corners=false);

    // Lower radius cutout section
    translate([armWidth,-min(diameter, Inches(0.51))/2,Inches(0.5)])
    rotate([0,-90,0])
    ChamferedSquareHole([r, min(diameter, Inches(0.51))], chamferRadius=CR, length=armWidth, center=false, corners=false);

    // Clamp Screws
    translate([0,0,vBottomZ+(r*sqrt(2))])
    for (R = [-1,1]) rotate([R*45,0,0])
    translate([(armWidth/2),0, r])
    NutAndBolt(GPBolt(), boltLength=Inches(0.5), clearance=Inches(0.001),
               nut="heatset", nutHeightExtra=r,
               nutBackset=Inches(0.01));

    // Arm Pins
    for (Y = [0.625, -0.625])
    translate([0,Y,Inches(0.375)])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.255/2), h=armWidth, teardropTop=true);

  }
}
//

ScaleToMillimeters()
if ($preview) {
  r=ARM_HOLE_DIAMETER/2;

  // Barrel Mockup
  color("DimGrey")
  translate([0,0,Inches(0.5)+(r*sqrt(2))])
  rotate([0,90,0])
  cylinder(r=r, h=12);

  color("Chocolate")
  for (X = [0.755,6.755]) translate([X,0,0])
  render()
  Fixture_VBlock_Arm(r=r);

  color("Tan", 0.5)
  render()
  Fixture_VBlock();

  color("Tan",0.5)
  translate([6,0,0])
  render()
  Fixture_VBlock();
} else {

  echo("Part: ", _RENDER);
  echo("Orientation: ", (_RENDER_PRINT ? "Print" : "Assembly"));

  // ********************
  // * Fixures and Jigs *
  // ********************
  if (_RENDER == "Fixtures/VBlock")
    if (!_RENDER_PRINT)
      Fixture_VBlock();
    else
      Fixture_VBlock();

  if (_RENDER == "Fixtures/VBlock_Arm")
    if (!_RENDER_PRINT)
      Fixture_VBlock_Arm();
    else
      rotate([0,-90,0])
      Fixture_VBlock_Arm();

  if (_RENDER == "Fixtures/VBlock_Arm_Barrel")
    if (!_RENDER_PRINT)
      Fixture_VBlock_Arm(r=BarrelRadius());
    else
      rotate([0,-90,0])
      Fixture_VBlock_Arm(r=BarrelRadius());

  if (_RENDER == "Fixtures/VBlock_Arm_Sleeve")
    if (!_RENDER_PRINT)
      Fixture_VBlock_Arm(r=TrunnionRadius());
    else
      rotate([0,-90,0])
      Fixture_VBlock_Arm(r=TrunnionRadius());

  // ************
  // * Hardware *
  // ************

  /* if (_RENDER == "Hardware/BarrelCollarBolts")
  BarrelCollarBolts(); */

}
