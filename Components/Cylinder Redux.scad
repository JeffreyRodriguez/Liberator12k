use <../Vitamins/Rod.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Math/Circles.scad>;
use <../Finishing/Chamfer.scad>;
use <../Shapes/Donut.scad>;
use <../Shapes/ZigZag.scad>;

function ActuatorRod() = Spec_RodOneQuarterInch();
function CylinderRod() = Spec_RodFiveSixteenthInch();

//Spec_RodThreeEighthsInch
function ZigZagWidth() = RodDiameter(ActuatorRod(), RodClearanceSnug());
function ZigZagDepth() = 1/4;
function CylinderOuterWall() = 1/16;

function RevolverCylinderRadius(centerOffset=1, chamberRadius=1,
                                wall=CylinderOuterWall(), depth=ZigZagDepth())
             = centerOffset
             + chamberRadius
             + wall+depth;

module RevolverChamberIterator(centerOffset=1, positions=4) {
  for (i=[0:positions-1])
  rotate([0,0,(360/positions)*i]) {
    translate([centerOffset,0])
    children();
  }
}

module OffsetZigZagRevolver(chamberRadius=1,
           wall=CylinderOuterWall(), depth=ZigZagDepth(), positions=6,
           centerOffset=undef,
           trackAngle=0, extraTop=0, extraBottom=0,
           spindleRadius=RodRadius(CylinderRod(), RodClearanceSnug()),
           chambers=true, chamberLength=undef,
           supports=true,
           cutter=false, clearance=0.01,
           debug=false, alpha=1) {
  clear = cutter ? clearance : 0;

  centerOffset = centerOffset==undef ? (chamberRadius*2) : centerOffset;

  radius = RevolverCylinderRadius(
               centerOffset,chamberRadius,
               wall, depth);
             
  height = ZigZagHeight(radius, positions, ZigZagWidth()) +(ZigZagWidth()*1.5);
  
  if (chambers && !cutter)
  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
  cylinder(r=chamberRadius, h=chamberLength, $fn=Resolution(40,60));

  color("Gold", alpha)
  DebugHalf(enabled=debug)
  difference() {
    
    // Body
    union() {
      
      // Outer shell
      ChamferedCylinder(r1=radius, r2=1/16,
                        h=height+extraTop+extraBottom + clear,
                        chamferTop=!cutter, chamferBottom=!cutter,
                        $fn=Resolution(50,120));
      
      // Extended core
      cylinder(r=centerOffset+(cutter?clear+chamberRadius:0), h=chamberLength+clear, $fn=Resolution(30,50));
    }

    if (!cutter) {
      translate([0,0,-ManifoldGap()])
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
      cylinder(r=chamberRadius,
               h=max(height,chamberLength)+ManifoldGap(2),
               $fn=Resolution(40,60));
    
      // ZigZag track
      rotate(trackAngle)
      ZigZag(radius=radius, depth=ZigZagDepth(), supports=supports,
             width=ZigZagWidth(), positions=positions,
             extraTop=extraTop, extraBottom=extraBottom);
      
      
      // Split into two parts, core and shell
      translate([0,0,-ManifoldGap()])
      Donut(major=centerOffset+(chamberRadius*0.25),
            minor=centerOffset-(chamberRadius*0.75),
            h=max(height+extraTop+extraBottom, chamberLength)+ManifoldGap(2),
            $fn=Resolution(20,40));

      // Spindle Hole
      cylinder(r=spindleRadius,
               h=max(height+extraTop+extraBottom, chamberLength)+ManifoldGap(2),
               $fn=Resolution(20,40));
    }
  }
}

OffsetZigZagRevolver(chamberRadius=1.125/2,
           centerOffset=undef,
           chambers=true, chamberLength=4, extraTop=1,
           trackAngle=0, debug=false, cutter=false);

translate([6,0,0])
OffsetZigZagRevolver(chamberRadius=0.75/2,
           centerOffset=undef,
           chambers=true, chamberLength=2.5, extraTop=1,
           trackAngle=0, debug=false);
