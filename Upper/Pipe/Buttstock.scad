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

module Buttstock(extension=0.125, debug=false) {

  chamferRadius = 1/32;
  length = 5;
  base = 0.375;
  baseHeight = ReceiverOR()*sqrt(2);
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
        translate([-ReceiverOR(), -ReceiverOR()/2,-ManifoldGap()])
        ChamferedCube([length, ReceiverOR(), base+(chamferRadius*2)],
                       r=chamferRadius);

        translate([0,0,baseHeight])
        ChamferedCylinder(r1=ReceiverOR()+wall,
                            r2=chamferRadius*2, h=extensionHull,
                          chamferTop=false,
                           $fn=Resolution(30,60));
      }
      
      translate([0,0,baseHeight+extensionHull-ManifoldGap()])
      ChamferedCylinder(r1=ReceiverOR()+wall,
                        r2=chamferRadius*2,
                        chamferBottom=false,
                        h=extension,
                        $fn=Resolution(30,60));
    }

    // Ribs
    for (X = [0:1:length-2])
    translate([X,0,0])
    rotate([0,45,0])
    cube([ribDepth, ReceiverOD(), ribDepth], center=true);

    // Pipe hole
    translate([0,0,baseHeight])
    ChamferedCircularHole(r1=ReceiverOR(PipeClearanceSnug()),
                          r2=chamferRadius,
                          h=extensionHull+extension, chamferBottom=false,
                          $fn=Resolution(30,50));
  }
}


translate([LowerMaxX()-ReceiverLength(),0,0])
Buttstock();

PipeLugAssembly(pipeAlpha=0.5);

// Buttstock Plater
*!scale(25.4) rotate([0,-90,0]) translate([ReceiverLength(), 0,0])
Buttstock();
