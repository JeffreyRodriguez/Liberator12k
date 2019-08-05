use <../Vitamins/Rod.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Math/Circles.scad>;
use <../Finishing/Chamfer.scad>;
use <../Shapes/Donut.scad>;
use <../Shapes/ZigZag.scad>;


function ActuatorRod() = Spec_RodOneQuarterInch();
function CylinderRod() = Spec_RodOneQuarterInch();
function CylinderRod() = Spec_RodFiveSixteenthInch();
//function CylinderRod() = Spec_RodOneHalfInch();
function CylinderBolt() = Spec_BoltOneHalf();
function CylinderBolt() = Spec_BoltFiveSixteenths();
//function CylinderBolt() = Spec_BoltOneQuarter();
function ChamberBolt() = Spec_BoltM3();

function SpindleDiameter() = BoltDiameter(CylinderBolt());
function SpindleRadius() = BoltRadius(CylinderBolt());

//Spec_RodThreeEighthsInch
function ZigZagWidth() = RodDiameter(ActuatorRod(), RodClearanceSnug());
function ZigZagDepth() = 0.1875;
function CylinderOuterWall() = 0.1875;
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

module ChamberBolt(positions, chamberRadius, boltOffset=1.5, cutter=false) {
  angle = 360/positions;
  
  rotate(angle)
  translate([chamberRadius-0.1-(cutter?chamberRadius:0),0,boltOffset])
  rotate([0,90,0])
  rotate(180)
  color("Silver") render()
  Bolt(bolt=ChamberBolt(),
       length=0.8+(cutter?chamberRadius:0), cap=false,
       clearance=false, teardrop=cutter);
}

module OffsetZigZagRevolver(chamberRadius=1, chamberInnerRadius=0,
           centerOffset=undef, coreInnerRadius=0,
           wall=CylinderOuterWall(), depth=ZigZagDepth(),
           zigzagAngle=45, boltOffset=1.75,
           trackAngle=0, extraTop=0, extraBottom=0,
           spindleRadius=BoltRadius(CylinderBolt(), clearance=true),
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

  echo("Cylinder positions: ", positions);
  echo("Cylinder height: ", height);
  echo("Cylinder radius: ", radius);
             
  coreRadius=centerOffset-0.25;
  
  // Chamber Bolts
  if (chamberBolts)
  RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
  ChamberBolt(positions=positions,
              chamberRadius=chamberRadius,
              boltOffset=boltOffset, cutter=false);
  
  if (chambers && !cutter)
  color("Silver")
  DebugHalf(enabled=debug)
  RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
  render()
  linear_extrude(height=chamberLength)
  difference() {
    circle(r=chamberRadius, $fn=Resolution(20,60));
    
    if (chamberInnerRadius>0)
    circle(r=chamberInnerRadius, $fn=Resolution(20,60));
  }

  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    
    // Body
    union() {
      
      // Outer shell
      if (shell)
      difference() {
        ChamferedCylinder(r1=radius+radialClear, r2=1/16,
                          h=(cutter?chamberLength+linearClear:height),
                          chamferTop=true, chamferBottom=!cutter,
                          $fn=Resolution(20,120));
      
        // Split into two parts, core and shell
        translate([0,0,-ManifoldGap()])
        cylinder(r=centerOffset,
                 h=height+ManifoldGap(2),
                 $fn=Resolution(20,120));
      }
      
      // Core
      if (core)
      difference() {
        ChamferedCylinder(r1=coreRadius, r2=1/16,
                          h=chamberLength, $fn=Resolution(12,50));
        

        // Spindle Hole
        cylinder(r=spindleRadius,
                 h=max(height, chamberLength+linearClearance)+ManifoldGap(2),
                 $fn=Resolution(20,40));
  
          if (coreInnerRadius > 0) {
              
              // Hollow out the core
              cylinder(r=coreInnerRadius, h=height+ManifoldGap(), $fn=40);
          }
      }
    }

    if (!cutter) {
      
      // Chambers
      translate([0,0,-ManifoldGap()])
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
      cylinder(r=chamberRadius,
               h=chamberLength+linearClearance,
               $fn=Resolution(20,60));
      
      // Chamber bolts
      RevolverChamberIterator(centerOffset=centerOffset, positions=positions)
      ChamberBolt(positions=positions,
                  chamberRadius=chamberRadius,
                  boltOffset=boltOffset, cutter=true);
    
      // ZigZag track
      rotate(trackAngle)
      rotate(360/positions)
      ZigZag(radius=radius, depth=ZigZagDepth(), width=ZigZagWidth(),
             positions=positions, zigzagAngle=zigzagAngle,
             extraTop=extraTop, extraBottom=extraBottom,
             supports=supports);
    }
    
    
  }
}

// 1.125" OD chambers
*!OffsetZigZagRevolver(chamberRadius=1.125/2, chamberInnerRadius=0.813/2, centerOffset=1.355,
           chambers=true, chamberLength=3.5, extraTop=0.25,
           trackAngle=360/7/2, zigzagAngle=45, debug=false, cutter=false);

// 0.75" OD chambers
*!OffsetZigZagRevolver(chamberRadius=0.75/2, chamberInnerRadius=0.813/2, centerOffset=1.355,
           chambers=true, chamberLength=3.5, extraTop=0.25,
           trackAngle=360/11/2, zigzagAngle=60, debug=false, cutter=false);

// 0.5" OD chambers
*!OffsetZigZagRevolver(chamberRadius=0.5/2, chamberInnerRadius=0.813/2, centerOffset=1.355,
           chambers=true, chamberLength=3.5,
           trackAngle=360/15/2, zigzagAngle=60, debug=false, cutter=false);


// 5x1.125" OD chambers
*!OffsetZigZagRevolver(chamberRadius=1.125/2, chamberInnerRadius=0.813/2, centerOffset=1,
           chambers=true, chamberLength=3, extraTop=0.125,
           zigzagAngle=45, debug=false, cutter=false);
           
           
// 5x1.125" OD chambers
*!OffsetZigZagRevolver(chamberRadius=1.125/2, chamberInnerRadius=0.813/2, centerOffset=1,
           chambers=true, chamberLength=3.5, extraTop=0.125,
           trackAngle=360/5/2, zigzagAngle=45, debug=false, cutter=false);

*OffsetZigZagRevolver(chamberRadius=1/2,
           centerOffset=undef,
           chambers=true, chamberLength=4, extraTop=1,
           trackAngle=0, debug=false, cutter=false);

// L12k 5-shot DOM 12ga
*OffsetZigZagRevolver(depth=3/16,
      centerOffset=31/32,
      chamberRadius=1.135/2, chamberInnerRadius=0.813/2,
      chamberBolts=false, boltOffset=1.875,
      teardrop=false, zigzagAngle=49.35,
      supports=false,  extraTop=0.125,
      chambers=true, chamberLength=3);

// L12k 6-shot 4130 12ga
!scale(25.4)
OffsetZigZagRevolver(depth=3/16,
      centerOffset=1.0001,
      chamberRadius=1/2, chamberInnerRadius=0.813/2,
      chamberBolts=false, boltOffset=1.75,
      teardrop=false, zigzagAngle=80,
      supports=false,  extraTop=0.125+0.033,
      core=false, shell=true,
      chambers=false, chamberLength=3);

// 1" Sch40 Steel pipe
*translate([-6,0,0])
OffsetZigZagRevolver(chamberRadius=1.355/2, chamberInnerRadius=0.813/2,
           centerOffset=undef,
           chambers=true, chamberLength=4, extraTop=0,
           trackAngle=0, debug=false, cutter=false);
