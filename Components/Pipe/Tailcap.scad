include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Cap.scad>;
use <Lugs.scad>;

module Tailcap(base=0.25, debug=false) {
  DebugHalf(enabled=debug)
  translate([-base,0,0])
  rotate([0,90,0])
  difference() {
    PrintablePipeCap(
        pipeDiameter=ReceiverOD(),
        base=base,
        $fn=Resolution(30,60));
  }
}

translate([LowerMaxX()-ReceiverLength(),0,0])
Tailcap();

PipeLugAssembly(pipeAlpha=0.5);

// Tailcap Plater
*!scale(25.4) rotate([0,-90,0]) translate([ReceiverLength(),0,0])
Tailcap();
