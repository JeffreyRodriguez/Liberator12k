include <../../Meta/Common.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Components/ORing.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

/* [Stock and Hole Dimensions] */

/* [Jig Dimensions] */
SQUARE_WIDTH = 0.2501;
PUNCH_DIAMETER = 0.0984;
DRILL_DIAMETER = 0.25;
HOLE_OFFSET = 1.0001;
BASE_HEIGHT = 0.2501;
BASE_EXTENSION = 1.0001;

/* [Fine Tuning] */
CLEARANCE = 0.0051;
CHAMFER_RADIUS = 0.0625;

TYPE = "Centerpunch"; // ["Centerpunch", "Drill"]

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

module SquareRodJig(width=SQUARE_WIDTH, r=PUNCH_DIAMETER/2, drillRadius=DRILL_DIAMETER/2, offset=HOLE_OFFSET, extension=BASE_EXTENSION) {
  clear = 0.004;
  clear2 = clear*2;

  wall = 0.25;
  length = offset+extension;
  guideHeight = BASE_HEIGHT+(width/2);
  baseWidth  = (width*2) + (wall*4);
  capWidth  = width + (wall*2);
  capHeight = BASE_HEIGHT+width+wall;
  centerpunchHeight = BASE_HEIGHT+(width/2)+Inches(0.5);

  offsetSide = capWidth+wall;

  difference() {
    union() {

      // Base
      ChamferedCube([length, baseWidth, BASE_HEIGHT], r=CHAMFER_RADIUS);

      // Side guides
      ChamferedCube([length, baseWidth, guideHeight], r=CHAMFER_RADIUS);

      // Punch alignment block
      translate([offset-wall-r,0,0])
      ChamferedCube([wall+(r*2)+wall, capWidth, centerpunchHeight], r=CHAMFER_RADIUS);

      // Back cover
      translate([0,offsetSide-wall,0])
      ChamferedCube([offset-wall-r, capWidth, capHeight], r=CHAMFER_RADIUS);

      // Front Cover
      translate([offset+r+wall,offsetSide-wall,0])
      ChamferedCube([extension-r-wall, capWidth, capHeight], r=CHAMFER_RADIUS);

      // Hold-down support
      translate([0,-0.5,0])
      ChamferedCube([1, 2.5, BASE_HEIGHT], r=CHAMFER_RADIUS);
    }

    // Punch hole
    translate([offset,wall+(width/2),BASE_HEIGHT])
    cylinder(r=r+clear, h=centerpunchHeight);

    // Punch square rod cutout
    translate([-length, wall-clear, BASE_HEIGHT])
    cube([length*3, width+clear2, width+clear2]);

    // Drill hole
    translate([offset,offsetSide+(width/2),0])
    cylinder(r=drillRadius, h=capHeight);

    // Drill square rod cutout
    translate([0, offsetSide-clear, BASE_HEIGHT])
    cube([length+ManifoldGap(), width+clear2, width+clear2]);

    // Hold-down holes
    for (Y = [0,2])
    translate([Inches(0.5),Y-0.25,0])
    Bolt(bolt=BoltSpec("#8-32"), length=Inches(0.5), clearance=clear);

  }
}

ScaleToMillimeters() {
  color("Tan") render()
  SquareRodJig();
}
