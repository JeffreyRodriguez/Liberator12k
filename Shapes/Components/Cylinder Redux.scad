use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Math/Circles.scad>;
use <../Chamfer.scad>;
use <../Donut.scad>;
use <../ZigZag.scad>;

// **********************
// * Customizer Options *
// **********************
/* [Render] */
_CYLINDER_ALPHA= 1; // [0:0.1:1]
_SHOW_CHAMBERS = true;
_SHOW_CHAMBER_BOLTS = true;

/* [ZigZag] */
ZIG_ZAG_WIDTH = 0.2501;
ZIG_ZAG_DEPTH = 0.1601;
ZIG_ZAG_CLEARANCE = 0.0101;

/* [Chambers] */
CHAMBER_BOLT = "#8-32"; // ["M3", "M4", "M5", "#8-32", "#10-24"]
CHAMBER_BOLT_CLEARANCE = 0.005;

CHAMBER_OUTSIDE_DIAMETER = 1.0001;
CHAMBER_INSIDE_DIAMETER = 0.8130;
CHAMBER_CLEARANCE = 0.01;
CHAMBER_LENGTH = 3.0001;
CHAMBER_OFFSET = 1.0001;

/* [Cylinder] */
CYLINDER_HEIGHT       = 2.75;
CYLINDER_DIAMETER     = 3.375;
CYLINDER_EXTRA_BOTTOM = 0.125;
CYLINDER_EXTRA_TOP    = 0.125;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// *************
// * Functions *
// *************

function ChamberBolt() = BoltSpec(CHAMBER_BOLT);
assert(ChamberBolt(), "ChamberBolt() is undefined. Unknown CHAMBER_BOLT?");

function ZigZagWidth() = ZIG_ZAG_WIDTH;
function ZigZagDepth() = ZIG_ZAG_DEPTH;

function ChamberCount(chamberDiameter=0.5, centerOffset=0.51) =
  floor(PI / (asin(chamberDiameter / (centerOffset*2))*(PI/180)));

module RevolverChamberIterator(centerOffset=1, positions=4) {
  for (i=[0:positions-1])
  rotate([0,0,(360/positions)*i]) {
    translate([centerOffset,0])
    children();
  }
}

module ChamberBolt(positions, chamberRadius, chamberBoltOffset=-1,
                   clearance=CHAMBER_BOLT_CLEARANCE, cutter=false) {
  angle = 360/positions;

  rotate(angle)
  translate([chamberRadius,0,chamberBoltOffset])
  rotate([0,90,0])
  NutAndBolt(bolt=ChamberBolt(), head="none", nut="heatset",
       boltLength=0.5+(cutter?chamberRadius:0),
       nutHeightExtra=(cutter?chamberRadius:0),
       clearance=clearance, teardrop=cutter);
}

module OffsetZigZagRevolver(diameter=4, height=2.75,
           chamberRadius=1, chamberInnerRadius=0,
           chamberClearance=CHAMBER_CLEARANCE, centerOffset=undef,
           depth=ZigZagDepth(),
           extraTop=0, extraBottom=0,
           spindleRadius=0,
           chamberBolts=true, chambers=true, chamberLength=undef,
           supportsTop=false, supportsBottom=false,
           cutter=false, radialClearance=0.015, linearClearance=0.03,
           debug=false, alpha=_CYLINDER_ALPHA,
           render_cylinder=false) {
  radialClear = cutter ? radialClearance : 0;
  linearClear = cutter ? linearClearance : 0;

  radius = diameter/2;

  centerOffset = centerOffset==undef ? (chamberRadius*2) : centerOffset;

  positions = ChamberCount(chamberRadius*2, centerOffset);
  trackAngle=360/positions/2;

  echo("Cylinder positions: ", positions);
  echo("Cylinder height: ", height);
  echo("Cylinder diameter, radius: ", radius*2, radius);

  // Chamber Bolts
  if (chamberBolts)
  color("Silver") render()
  translate([0,0,height])
  RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
  ChamberBolt(positions=positions,
              chamberRadius=chamberRadius,
              cutter=false);

  // Chamber Inserts
  if (chambers && !cutter)
  color("Silver", alpha) render()
  DebugHalf(debug)
  RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
  linear_extrude(height=chamberLength)
  difference() {
    circle(r=chamberRadius);

    if (chamberInnerRadius>0)
    circle(r=chamberInnerRadius);
  }

  // The Cylinder
  color("Tan", alpha) RenderIf(render_cylinder)
  DebugHalf(debug)
  difference() {

    // Body
    ChamferedCylinder(r1=radius+radialClear, r2=1/16,
                      h=(cutter?chamberLength+linearClear:height),
                      chamferTop=true, teardropTop=true, chamferBottom=!cutter);

    if (!cutter) {
      
      children();
      
      // Spindle Hole
      if (spindleRadius > 0)
      cylinder(r=spindleRadius,
               h=max(height, chamberLength+linearClearance)+ManifoldGap(2));

      // Chambers
      translate([0,0,-ManifoldGap()])
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
      cylinder(r=chamberRadius+chamberClearance,
               h=chamberLength+linearClearance);

      // Chamber ID
      translate([0,0,-ManifoldGap()])
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
      cylinder(r=chamberInnerRadius,
               h=height+ManifoldGap(2));

      // Chamber bolts
      translate([0,0,height])
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions/2) {
        ChamberBolt(positions=positions,
                    chamberRadius=chamberRadius,
                    cutter=true);
        ChamberBolt(positions=-positions,
                    chamberRadius=chamberRadius,
                    cutter=true);
      }

      // ZigZag track
      translate([0,0,-ManifoldGap()])
      rotate(trackAngle)
      rotate(360/positions)
      ZigZag(radius=radius, depth=ZigZagDepth(), width=ZigZagWidth(),
             positions=positions,
             extraTop=extraTop, extraBottom=extraBottom,
             supportsTop=supportsTop, supportsBottom=supportsBottom);
    }


  }
}

// L12k 6-shot 4130 12ga
//scale(25.4)
OffsetZigZagRevolver(
      diameter=CYLINDER_DIAMETER,
      height=CYLINDER_HEIGHT,
      centerOffset=CHAMBER_OFFSET,
      chamberRadius=CHAMBER_OUTSIDE_DIAMETER/2, chamberInnerRadius=CHAMBER_INSIDE_DIAMETER/2,
      chamberBolts=_SHOW_CHAMBER_BOLTS,
      supportsTop=true,
      supportsBottom=true,
      depth=ZIG_ZAG_DEPTH,
      extraTop=CYLINDER_EXTRA_TOP,
      extraBottom=CYLINDER_EXTRA_BOTTOM,
      render_cylinder=$preview,
      chambers=$preview,
      chamberLength=CHAMBER_LENGTH);