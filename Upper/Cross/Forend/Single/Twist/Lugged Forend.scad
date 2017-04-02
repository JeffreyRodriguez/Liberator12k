include <../../../../../Meta/Animation.scad>;

use <../../../../../Meta/Debug.scad>;
use <../../../../../Meta/Manifold.scad>;
use <../../../../../Meta/Resolution.scad>;

use <../../../../../Vitamins/Pipe.scad>;
use <../../../../../Vitamins/Rod.scad>;
use <../../../../../Vitamins/Double Shaft Collar.scad>;

use <../../../../../Reference.scad>;
use <../../Forend.scad>;

use <Barrel Lugs.scad>;

module LuggedForend(lengthOpen=BarrelLugLength(), lengthClosed=3, alpha=1) {
  echo("Lugged Forend Length", lengthOpen+lengthClosed);

  color("Gold", alpha)
  render(convexity=4)
  difference() {
    Forend(length=lengthClosed+lengthOpen);
    
    translate([-ManifoldGap(),0,0])
    rotate([0,90,0])
    BarrelLugTrack(slideLength=lengthClosed,
                   lugLength=lengthOpen+0.05+ManifoldGap());
  }
}

LuggedForend();

// Plated Lugged Forend
*!scale(25.4)
translate([0,0,3+BarrelLugLength()])
rotate([0,90,0])
LuggedForend();