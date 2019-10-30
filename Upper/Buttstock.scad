include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Components/Firing Pin.scad>;

use <../Finishing/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;

use <../Lower/Receiver Lugs.scad>;
use <../Lower/Trigger.scad>;
use <../Lower/Lower.scad>;

use <Lugs.scad>;
use <Linear Hammer.scad>;

function ButtstockBolt() = Spec_BoltM4();
function ButtstockHeight() = 2;
function ButtstockSleeveLength() = 1;
function ButtstockWall() = 0.1875;

function ButtstockOD() = ReceiverOD()+(ButtstockWall()*2);
function ButtstockOR() = ButtstockOD()/2;


module ButtstockBolt(debug=false, cutter=false, clearance=0.005, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver")
  DebugHalf(enabled=debug)
  for (R = [0,90,-90]) rotate([R,0,0])
  translate([(ButtstockSleeveLength()/2),0,ReceiverOR()+ButtstockWall()])
  Bolt(bolt=ButtstockBolt(), head="socket", capOrientation=true,
       length=ButtstockWall()+ReceiverPipeWall(),
       clearance=clear,
       teardrop=cutter, teardropAngle=teardropAngle);
}

module Buttstock(debug=false, $fn=Resolution(30,60)) {
  chamferRadius = 1/16;
  length = 4;
  base = 0.375;
  baseHeight = ButtstockHeight();
  ribDepth=0.1875;
  extensionHull = ButtstockSleeveLength();

  color("Tan")
  DebugHalf(enabled=debug) render()
  difference() {

    // Stock and extension hull
    translate([-baseHeight,0,0])
    rotate([0,90,0])
    hull() {

      // Foot of the stock
      for (L = [0,1]) translate([(length*L)-(ButtstockOR()/2),0,0])
      ChamferedCylinder(r1=ButtstockOR()/2, r2=chamferRadius, h=base);

      // Around the receiver tube
      translate([0,0,baseHeight])
      ChamferedCylinder(r1=ButtstockOR(),
                          r2=chamferRadius*2, h=extensionHull,
                        chamferTop=true);
    }

    // Utility slot
    translate([-baseHeight,0,0])
    rotate([0,90,0]) {
      translate([ButtstockOR()+ButtstockWall(), -0.51/2, base])
      ChamferedCube([length, 0.51, baseHeight+extensionHull], r=chamferRadius);


      // Gripping Ridges
      for (M = [0,1]) mirror([0,M,0])
      for (X = [0:ButtstockOR()/2:length-(ButtstockOR()/2)])
      translate([X-(ButtstockOR()/4),(ButtstockOR()/2)+(ButtstockOR()/10),-ManifoldGap()])
      cylinder(r1=ButtstockOR()/4, r2=0, h=base);

      // Pipe hole
      translate([0,0,baseHeight])
      ChamferedCircularHole(r1=ReceiverOR(),
                            r2=chamferRadius,
                            h=extensionHull, chamferBottom=false);

      // Linear hammer spacer hole
      translate([0,0,baseHeight-1-chamferRadius])
      ChamferedCircularHole(r1=HammerTailInnerRadius(),
                            r2=chamferRadius,
                            h=1, chamferBottom=false);
    }

    ButtstockBolt(cutter=true, teardropAngle=0);

  }
}


//translate([LowerMaxX()-ReceiverLength(),0,0])
Buttstock();
ButtstockBolt();

//PipeLugAssembly(pipeAlpha=0.5);

// Buttstock Plater
*!scale(25.4) rotate([0,-90,0]) translate([0, 0,0])
Buttstock();
