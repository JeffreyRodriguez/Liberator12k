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

module OffsetZigZagRevolver(chamberRadius=1, chamberInnerRadius=0, centerOffset=undef,
           wall=CylinderOuterWall(), depth=ZigZagDepth(),
           positions=6, zigzagAngle=45,
           trackAngle=0, extraTop=0, extraBottom=0,
           spindleRadius=RodRadius(CylinderRod(), RodClearanceSnug()),
           chambers=true, chamberLength=undef,
           supports=true,
           cutter=false, radialClearance=0.015, linearClearance=0.03,
           debug=false, alpha=1) {
  radialClear = cutter ? radialClearance : 0;
  linearClear = cutter ? linearClearance : 0;

  centerOffset = centerOffset==undef ? (chamberRadius*2) : centerOffset;

  radius = RevolverCylinderRadius(
               centerOffset,chamberRadius,
               wall, depth);
             
  height = ZigZagHeight(radius, positions, ZigZagWidth(), zigzagAngle) +(ZigZagWidth()*1.5);
  
  if (chambers && !cutter)
  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
  linear_extrude(height=chamberLength)
  difference() {
    circle(r=chamberRadius, $fn=Resolution(40,60));
    
    if (chamberInnerRadius>0)
    circle(r=chamberInnerRadius, $fn=Resolution(40,60));
  }

  color("Gold", alpha)
  DebugHalf(enabled=debug)
  difference() {
    
    // Body
    union() {
      
      // Outer shell
      ChamferedCylinder(r1=radius+radialClear, r2=1/16,
                        h=height+extraTop+extraBottom + linearClear,
                        chamferTop=!cutter, chamferBottom=!cutter,
                        $fn=Resolution(50,120));
      
      // Extended core
      cylinder(r=centerOffset+(cutter?radialClear+chamberRadius:0), h=chamberLength+linearClear, $fn=Resolution(30,50));
    }

    if (!cutter) {
      translate([0,0,-ManifoldGap()])
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
      cylinder(r=chamberRadius,
               h=max(height,chamberLength)+ManifoldGap(2),
               $fn=Resolution(40,60));
    
      // ZigZag track
      rotate(trackAngle)
      ZigZag(radius=radius, depth=ZigZagDepth(), width=ZigZagWidth(),
             positions=positions, zigzagAngle=zigzagAngle,
             extraTop=extraTop, extraBottom=extraBottom,
             supports=supports);
      
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


// 1" OD chambers
*!OffsetZigZagRevolver(chamberRadius=1/2, chamberInnerRadius=0.813/2, centerOffset=5,
           positions=35, chambers=true, chamberLength=3.5, extraTop=0.25,
           trackAngle=360/  10/2, zigzagAngle=45, debug=false, cutter=false);

// 1.125" OD chambers
*!OffsetZigZagRevolver(chamberRadius=1.125/2, chamberInnerRadius=0.813/2, centerOffset=1.355,
           positions=7, chambers=true, chamberLength=3.5, extraTop=0.25,
           trackAngle=360/7/2, zigzagAngle=45, debug=false, cutter=false);


// 0.75" OD chambers
*!OffsetZigZagRevolver(chamberRadius=0.75/2, chamberInnerRadius=0.813/2, centerOffset=1.355,
           positions=11, chambers=true, chamberLength=3.5, extraTop=0.25,
           trackAngle=360/11/2, zigzagAngle=60, debug=false, cutter=false);

OffsetZigZagRevolver(chamberRadius=1/2,
           centerOffset=undef,
           chambers=true, chamberLength=4, extraTop=1,
           trackAngle=0, debug=false, cutter=false);

translate([-6,0,0])
OffsetZigZagRevolver(chamberRadius=1.355/2,
           centerOffset=undef,
           chambers=true, chamberLength=4, extraTop=1,
           trackAngle=0, debug=false, cutter=false);

translate([6,0,0])
OffsetZigZagRevolver(chamberRadius=0.75/2,
           centerOffset=undef,
           chambers=true, chamberLength=2.5, extraTop=1,
           trackAngle=0, debug=false);
