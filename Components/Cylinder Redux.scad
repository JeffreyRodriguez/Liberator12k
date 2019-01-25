use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;
use <../Math/Circles.scad>;
use <../Shapes/ZigZag.scad>;

function ZigZagDepth() = 1/4;
function ZigZagWidth() = RodDiameter(ActuatorRod(), RodClearanceSnug());

function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
//function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function ActuatorRod() = Spec_RodOneEighthInch();
function CylinderRod() = Spec_RodOneHalfInch();

function CylinderWall() = 0.3125;
function CylinderOuterWall() = 2 /32;
function CylinderChamberOffset() = 
  (PipeOuterRadius(BarrelPipe())
  +CylinderWall()) *sqrt(2);

function CylinderRadius(barrelPipe=BarrelPipe()) =
                  CylinderChamberOffset()
                  +PipeOuterRadius(BarrelPipe())
                  +CylinderOuterWall()
                  +ZigZagDepth();

function OffsetRevolverRadius(centerOffset, chamberDiameter, wall)
             = centerOffset + (chamberDiameter) + wall;

module OffsetRevolverIterator(centerOffset=1, positions=4) {
  for (i=[0:positions-1])
  rotate([0,0,(360/positions)*i]) {
    translate([centerOffset,0])
    children();
  }
}

module OffsetRevolver(radius=CylinderRadius(), positions=6,
         centerOffset=1, chamberDiameter=1,
         height=1,
         trackAngle=0,
         chamberLength=undef,
         chambers=true, debug=false) {
  // Body
  color("Gold") render()
  linear_extrude(height=height)
  difference() {
    circle(r=radius, $fn=Resolution(50,120));

    OffsetRevolverIterator(centerOffset=centerOffset, positions=positions)
    children();
  }
}

module OffsetZigZagRevolver(barrelPipe=BarrelPipe(),
           wall=CylinderWall(), positions=6,
           centerOffset=CylinderChamberOffset(),
           trackAngle=0,
           chambers=true, chamberLength=undef,
           printableZigZag=true, debug=false) {

  radius = OffsetRevolverRadius(
               centerOffset,
               PipeOuterRadius(barrelPipe),
               wall);
  height = ZigZagHeight(radius, positions, ZigZagWidth()) +(ZigZagWidth()*6);

  color("Gold")
  render()
  difference() {
    OffsetRevolver(radius=radius, centerOffset=centerOffset,
                   positions=positions,
                   height=height, debug=false)
    translate([0,0,-ManifoldGap()])
    Pipe2d(barrelPipe, clearance=PipeClearanceSnug());
  
    rotate(trackAngle)
    ZigZag(radius=radius, depth=ZigZagDepth(),
           width=5/16, positions=positions);

    // Spindle
    Rod(rod=CylinderRod(), length=height, clearance=RodClearanceLoose());
  }
  
  if (chambers)
  color("MidnightBlue", 0.5)
  OffsetRevolverIterator(centerOffset=centerOffset, positions=positions)
  Pipe(BarrelPipe(), length=(chamberLength==undef?height:chamberLength), clearance=undef);
}

OffsetZigZagRevolver(
           centerOffset=CylinderChamberOffset(),
           chambers=true, chamberLength=1.5,
           trackAngle=0, debug=false);
