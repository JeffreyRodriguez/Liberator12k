use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Math/Circles.scad>;
use <../Finishing/Chamfer.scad>;
use <../Shapes/ZigZag.scad>;

function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
//function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function ActuatorRod() = Spec_RodOneQuarterInch();
function CylinderRod() = Spec_RodThreeEighthsInch();
function CylinderRod() = Spec_RodFiveSixteenthInch();

//Spec_RodThreeEighthsInch

function ZigZagWidth() = RodDiameter(ActuatorRod(), RodClearanceSnug());
function ZigZagDepth() = 1/4;


function CylinderOuterWall() = (1/8)+ZigZagDepth();
function CylinderChamberOffset() =  PipeOuterDiameter(BarrelPipe());

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
         height=1, chamberLength=2,
         trackAngle=0, debug=false) {
  // Body
  color("Gold") render()
  difference() {
    union() {
      
      // Outer shell
      ChamferedCylinder(r1=radius, r2=1/16, h=height, $fn=Resolution(50,120));
      
      // Extended core
      cylinder(r=centerOffset, h=chamberLength, $fn=Resolution(30,50));
    }

    linear_extrude(height=max(height,chamberLength))
    OffsetRevolverIterator(centerOffset=centerOffset, positions=positions)
    children();
  }
}

module OffsetZigZagRevolver(barrelPipe=BarrelPipe(),
           wall=CylinderOuterWall(), positions=6,
           centerOffset=CylinderChamberOffset(),
           trackAngle=0, extraTop=0, extraBottom=0,
           spindleRadius=RodRadius(CylinderRod(), RodClearanceSnug()),
           chambers=true, chamberLength=undef,
           supports=true,
           debug=false, alpha=1) {

  radius = OffsetRevolverRadius(
               centerOffset,
               PipeOuterRadius(barrelPipe),
               wall);
  height = ZigZagHeight(radius, positions, ZigZagWidth()) +(ZigZagWidth()*1.5);
  
  if (chambers)
  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  OffsetRevolverIterator(centerOffset=centerOffset, positions=positions)
  Pipe(BarrelPipe(),
       length=(chamberLength==undef?height:chamberLength),
       clearance=undef, hollow=true);

  color("Gold", alpha)
  DebugHalf(enabled=debug)
  difference() {
    OffsetRevolver(radius=radius, centerOffset=centerOffset,
                   positions=positions,
                   chamberLength=chamberLength,
                   height=height+extraTop+extraBottom, debug=false)
    translate([0,0,-ManifoldGap()])
    Pipe2d(barrelPipe, clearance=PipeClearanceLoose());
  
    rotate(trackAngle)
    ZigZag(radius=radius, depth=ZigZagDepth(), supports=supports,
           width=ZigZagWidth(), positions=positions,
           extraTop=extraTop, extraBottom=extraBottom);
    
    
    // Split into two parts, core and shell
    translate([0,0,-ManifoldGap()])
    linear_extrude(height=max(height+extraTop+extraBottom, chamberLength)+ManifoldGap(2))
    difference() {
      circle(centerOffset
            +PipeWall(barrelPipe), $fn=Resolution(4,60));
      
      circle(PipeOuterRadius(barrelPipe)
            +PipeWall(barrelPipe), $fn=Resolution(40,60));
    }

    // Spindle
    cylinder(r=spindleRadius,
             h=max(height+extraTop+extraBottom, chamberLength)+ManifoldGap(2),
             $fn=Resolution(20,40));
  }
}

OffsetZigZagRevolver(
           centerOffset=CylinderChamberOffset(),
           chambers=true, chamberLength=4, extraTop=1,
           trackAngle=0, debug=false);
