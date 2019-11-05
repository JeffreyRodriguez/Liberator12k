include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Shapes/Components/Firing Pin.scad>;

use <../Shapes/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;

use <Lower/Receiver Lugs.scad>;
use <Lower/Trigger.scad>;
use <Lower/Lower.scad>;

use <Linear Hammer.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "Buttstock"]

/* [Receiver Tube] */
RECEIVER_TUBE_OD = 1.75;

$fs = UnitsFs()*0.25;

function ButtstockBolt() = Spec_BoltM4();
function ButtstockHeight() = 2;
function ButtstockSleeveLength() = 1;
function ButtstockWall() = 0.1875;


module ButtstockBolt(receiverRadius=RECEIVER_TUBE_OD/2,
                     debug=false, cutter=false,
                     clearance=0.005, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver")
  DebugHalf(enabled=debug)
  for (R = [180]) rotate([R,0,0])
  translate([(ButtstockSleeveLength()/2),0,receiverRadius+(ButtstockWall()*2)])
  Bolt(bolt=ButtstockBolt(), head="socket", capOrientation=true,
       length=(ButtstockWall()*2)+0.125,
       clearance=clear,
       teardrop=cutter, teardropAngle=teardropAngle);
}

module Buttstock(od=RECEIVER_TUBE_OD,
                 debug=false, alpha=1) {
  receiverRadius=od/2;  
  chamferRadius = 1/16;
  length = 4;
  base = 0.375;
  baseHeight = ButtstockHeight();
  ribDepth=0.1875;
  extensionHull = ButtstockSleeveLength();
  outsideRadius = receiverRadius+ButtstockWall();
  
  

  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {

    // Stock and extension hull
    translate([-baseHeight,0,0])
    rotate([0,90,0])
    hull() {

      // Foot of the stock
      for (L = [0,1]) translate([(length*L)-(outsideRadius/2),0,0])
      ChamferedCylinder(r1=outsideRadius/2, r2=chamferRadius,
                         h=base,
                         $fn=Resolution(20,50));

      // Around the receiver tube
      translate([0,0,baseHeight])
      ChamferedCylinder(r1=outsideRadius,
                        r2=chamferRadius*2, h=extensionHull,
                        chamferTop=true, $fn=Resolution(30,90));
    }

    translate([-baseHeight,0,0])
    rotate([0,90,0]) {
      
      // Utility slot
      translate([outsideRadius+ButtstockWall(), -0.51/2, base])
      ChamferedCube([length, 0.51, baseHeight+extensionHull], r=chamferRadius);


      // Gripping Ridges
      for (M = [0,1]) mirror([0,M,0])
      for (X = [0:outsideRadius/2:length-(outsideRadius/2)])
      translate([X-(outsideRadius/4),(outsideRadius/2)+(outsideRadius/10),-ManifoldGap()])
      cylinder(r1=outsideRadius/4, r2=0, h=base);

      // Receiver Pipe hole
      translate([0,0,baseHeight])
      ChamferedCircularHole(r1=receiverRadius,
                            r2=chamferRadius,
                            h=extensionHull,
                            chamferBottom=false,
                            teardropTop=false,
                            $fn=Resolution(20,80));

      // Linear hammer spacer hole
      translate([0,0,baseHeight-1-chamferRadius])
      ChamferedCircularHole(r1=HammerTailInnerRadius(),
                            r2=chamferRadius,
                            h=1, chamferBottom=false,
                            teardropTop=false,
                            $fn=Resolution(20,50));
    }

    ButtstockBolt(receiverRadius=receiverRadius, cutter=true, teardropAngle=0);

  }
}

module Buttstock_print(od=RECEIVER_TUBE_OD)
rotate([0,-90,0]) translate([ButtstockHeight(),0,0])
Buttstock(od=od);

module ButtstockAssembly(od=RECEIVER_TUBE_OD, alpha=1) {  
  ButtstockBolt();

  Buttstock(alpha=alpha);
}


scale(25.4) {
  if (_RENDER == "Assembly") {
    ButtstockAssembly();
  }

  if (_RENDER == "ReceiverCoupling")
  ReceiverCoupling_print();

  if (_RENDER == "")
  BarrelLatchCollar_print();

  if (_RENDER == "RecoilPlateHousing")
  BreakActionRecoilPlateHousing_print();

  if (_RENDER == "Forend")
  BreakActionForend_print();
}
