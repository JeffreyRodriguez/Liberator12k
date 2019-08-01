include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Firing Pin.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

module Buttstock(innerRadius=ReceiverOR(PipeClearanceSnug()), extension=0.125,
                 debug=false, $fn=Resolution(30,60)) {
  outsideRadius = 1;

  chamferRadius = 1/16;
  length = 4;
  base = 0.375;
  baseHeight = outsideRadius*2;
  wall = 0.1875;
  ribDepth=0.1875;
  extensionHull = 1;

  DebugHalf(enabled=debug)
  translate([-baseHeight,0,0])
  rotate([0,90,0])
  difference() {
    union() {
      // Stock and extension hull
      hull() {
        
        // Foot of the stock
        for (L = [0,1]) translate([(length*L)-(outsideRadius/2),0,0])
        ChamferedCylinder(r1=outsideRadius/2, r2=chamferRadius, h=base);

        // Around the receiver tube
        translate([0,0,baseHeight])
        ChamferedCylinder(r1=outsideRadius+wall,
                            r2=chamferRadius*2, h=extensionHull,
                          chamferTop=false);
      }
      
      // Extension around the receiver
      translate([0,0,baseHeight+extensionHull-ManifoldGap()])
      ChamferedCylinder(r1=outsideRadius+wall,
                        r2=chamferRadius*2,
                        chamferBottom=false,
                        h=extension);
    }


    // Gripping Ridges
    for (M = [0,1]) mirror([0,M,0])
    for (X = [0:outsideRadius/2:length-(outsideRadius/2)])
    translate([X-(outsideRadius/4),(outsideRadius/2)+(outsideRadius/10),-ManifoldGap()])
    cylinder(r1=outsideRadius/4, r2=0, h=outsideRadius/3);

    // Pipe hole
    translate([0,0,baseHeight])
    ChamferedCircularHole(r1=innerRadius,
                          r2=chamferRadius,
                          h=extensionHull+extension, chamferBottom=false);
  }
}


//translate([LowerMaxX()-ReceiverLength(),0,0])
Buttstock();

//PipeLugAssembly(pipeAlpha=0.5);

// Buttstock Plater
*!scale(25.4) rotate([0,-90,0]) translate([0, 0,0])
Buttstock();
