use <../Vitamins/Rod.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Math/Circles.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Donut.scad>;
use <../Shapes/ZigZag.scad>;

// **********************
// * Customizer Options *
// **********************

/* [Chamber] */
CHAMBER_BOLT = "#8-32"; // ["M3", "M4", "M5", "#8-32", "#10-24"]
CHAMBER_BOLT_CLEARANCE = -0.05;

CHAMBER_OUTSIDE_DIAMETER = 1;
CHAMBER_INSIDE_DIAMETER = 0.813;

/* [Spindle] */
SPINDLE_DIAMETER = 0.09375;
SPINDLE_CLEARANCE = 0.015;

SPINDLE_COLLAR_DIAMETER = 0.375;
SPINDLE_COLLAR_WIDTH = 0.1875;

/* [ZigZag] */
ZIG_ZAG_WIDTH = 0.25;
ZIG_ZAG_DEPTH = 0.1875;
ZIG_ZAG_CLEARANCE = 0.01;
ZIG_ZAG_ANGLE = 80; // [45:89]

/* [Cylinder] */
CYLINDER_OUTER_WALL = 0.1875;


// *************
// * Functions *
// *************


$fs = UnitsFs()*0.5;

function ChamberBolt() = BoltSpec(CHAMBER_BOLT);
assert(ChamberBolt(), "ChamberBolt() is undefined. Unknown CHAMBER_BOLT?");

function SpindleDiameter() = SPINDLE_DIAMETER;
function SpindleRadius() = SpindleDiameter()/2;

function ZigZagWidth() = ZIG_ZAG_WIDTH;
function ZigZagDepth() = ZIG_ZAG_DEPTH;

function CylinderOuterWall() = CYLINDER_OUTER_WALL;

function ChamberCount(chamberDiameter=0.5, centerOffset=0.51) =
  floor(PI / (asin(chamberDiameter / (centerOffset*2))*(PI/180)));

function RevolverCylinderRadius(centerOffset=1, chamberRadius=1,
                                wall=CylinderOuterWall(), depth=ZigZagDepth())
             = centerOffset
             + chamberRadius
             + wall+depth;

function RevolverCylinderHeight(radius, positions, zigzagAngle=45, width=ZigZagWidth())
           = ZigZagHeight(radius, positions, ZigZagWidth(), zigzagAngle)
           + (ZigZagWidth()*1.5);

module RevolverChamberIterator(centerOffset=1, positions=4) {
  for (i=[0:positions-1])
  rotate([0,0,(360/positions)*i]) {
    translate([centerOffset,0])
    children();
  }
}

module ChamberBolt(positions, chamberRadius, boltOffset=1.5,
                   clearance=CHAMBER_BOLT_CLEARANCE, cutter=false) {
  angle = 360/positions;

  rotate(angle)
  translate([chamberRadius-(cutter?chamberRadius:0),0,boltOffset])
  rotate([0,90,0])
  rotate(180)
  NutAndBolt(bolt=ChamberBolt(), head="none",
       boltLength=0.8+(cutter?chamberRadius:0),
       clearance=clearance, teardrop=cutter);
}

module OffsetZigZagRevolver(chamberRadius=1, chamberInnerRadius=0,
           centerOffset=undef, coreInnerRadius=0,
           wall=CylinderOuterWall(), depth=ZigZagDepth(),
           zigzagAngle=45, boltOffset=1.75,
           trackAngle=0, extraTop=0, extraBottom=0,
           spindleRadius=SpindleRadius()+SPINDLE_CLEARANCE,
           chamberBolts=true, chambers=true, chamberLength=undef,
           supports=true, core=true, shell=true,
           cutter=false, radialClearance=0.015, linearClearance=0.03,
           debug=false, alpha=1) {
  radialClear = cutter ? radialClearance : 0;
  linearClear = cutter ? linearClearance : 0;

  centerOffset = centerOffset==undef ? (chamberRadius*2) : centerOffset;

  positions = ChamberCount(chamberRadius*2, centerOffset);

  radius = RevolverCylinderRadius(
               centerOffset,chamberRadius,
               wall, depth);

  height = RevolverCylinderHeight(radius, positions, zigzagAngle, ZigZagWidth())
         + extraTop + extraBottom;

  trackAngle=360/positions/2;

  coreRadius=centerOffset-0.25;

  echo("Cylinder positions: ", positions);
  echo("Cylinder height: ", height);
  echo("Cylinder radius: ", radius);

  // Chamber Bolts
  if (chamberBolts)
  color("Silver") render()
  RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
  ChamberBolt(positions=positions,
              chamberRadius=chamberRadius,
              boltOffset=boltOffset, cutter=false);

  if (chambers && !cutter)
  color("Silver") render()
  DebugHalf(enabled=debug)
  RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
  linear_extrude(height=chamberLength)
  difference() {
    circle(r=chamberRadius);

    if (chamberInnerRadius>0)
    circle(r=chamberInnerRadius);
  }

  color("Tan", alpha) render()
  DebugHalf(enabled=debug)
  difference() {

    // Body
    union() {

      // Outer shell
      if (shell)
      difference() {
        ChamferedCylinder(r1=radius+radialClear, r2=1/16,
                          h=(cutter?chamberLength+linearClear:height),
                          chamferTop=true, chamferBottom=!cutter, $fn=100);

        // Split into two parts, core and shell
        translate([0,0,-ManifoldGap()])
        cylinder(r=centerOffset,
                 h=height+ManifoldGap(2));
      }

      // Core
      if (core)
      difference() {
        ChamferedCylinder(r1=coreRadius, r2=1/16,
                          h=chamberLength);


        // Spindle Hole
        cylinder(r=spindleRadius,
                 h=max(height, chamberLength+linearClearance)+ManifoldGap(2));

          if (coreInnerRadius > 0) {

              // Hollow out the core
              cylinder(r=coreInnerRadius, h=height+ManifoldGap());
          }
      }
    }

    if (!cutter) {

      // Chambers
      translate([0,0,-ManifoldGap()])
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
      cylinder(r=chamberRadius,
               h=chamberLength+linearClearance);

      // Chamber bolts
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
      ChamberBolt(positions=positions,
                  chamberRadius=chamberRadius,
                  boltOffset=boltOffset, cutter=true);

      // ZigZag track
      translate([0,0,-ManifoldGap()])
      rotate(trackAngle)
      rotate(360/positions)
      ZigZag(radius=radius, depth=ZigZagDepth(), width=ZigZagWidth(),
             positions=positions, zigzagAngle=zigzagAngle,
             extraTop=extraTop, extraBottom=extraBottom,
             supports=supports);
    }


  }
}

// L12k 6-shot 4130 12ga
scale(25.4)
OffsetZigZagRevolver(depth=3/16,
      centerOffset=1.0001,
      chamberRadius=1/2, chamberInnerRadius=0.813/2,
      chamberBolts=false, boltOffset=1.75,
      zigzagAngle=ZIG_ZAG_ANGLE,
      supports=true,  extraTop=0.125+0.033,
      core=false, shell=true,
      chambers=false, chamberLength=3);

