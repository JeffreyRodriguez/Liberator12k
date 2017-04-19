include <../../../../../Meta/Animation.scad>;

use <../../../../../Meta/Debug.scad>;
use <../../../../../Meta/Manifold.scad>;
use <../../../../../Meta/Resolution.scad>;

use <../../../../../Vitamins/Pipe.scad>;
use <../../../../../Vitamins/Rod.scad>;
use <../../../../../Vitamins/Double Shaft Collar.scad>;

use <../../../Reference.scad>;
use <../../../Frame.scad>;
use <../../Forend.scad>;
use <../../Forend Slotted.scad>;
use <Barrel Lugs.scad>;





DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_LOCK_ROD  = Spec_RodOneQuarterInch();

function ForendMidsectionLength() = 0.25;
function ForendFrontLength() = 0.375;

module LuggedForend(lengthOpen=BarrelLugLength(), lengthClosed=3, alpha=1, clearance=0.05) {
  echo("Lugged Forend Length", lengthOpen+lengthClosed);

  color("Gold", alpha)
  render(convexity=4)
  translate([ForendSlottedLength()+ForendMidsectionLength(),0,0])
  difference() {
    Forend(length=lengthClosed+lengthOpen, scallopAngles=[]);
    
    translate([ForendX()-ManifoldGap(),0,0])
    rotate([0,90,0])
    BarrelLugTrack(slideLength=lengthClosed,
                   lugLength=lengthOpen+clearance+ManifoldGap());
  }
}

function ForendFrontMinX() = ForendX()
                             +ForendSlottedLength()
                             +ForendMidsectionLength()
                             +BarrelLugLength()
                             +0.25;

module ForendMidsection(barrelSpec=BarrelPipe()) {
  translate([ForendSlottedLength(),0,0])
  Forend(barrelSpec=barrelSpec, length=ForendMidsectionLength());
}

ForendSlotted(length=ForendSlottedLength()-ManifoldGap());
ForendMidsection();

translate([ForendFrontMinX(),0,0])
ForendFront(length=ForendFrontLength());
LuggedForend();

// Plated Lugged Forend
*!scale(25.4)
translate([0,0,3+BarrelLugLength()])
rotate([0,90,0])
LuggedForend();

// Plated Forend-Midsection
*!scale(25.4)
rotate([0,-90,0])
translate([-ForendX()-ForendSlottedLength(),0,0])
ForendMidsection(barrelSpec=Spec_Tubing1628x1125());

// Plated Far Forend
*!scale(25.4)
rotate([0,-90,0])
ForendFront(length=ForendFrontLength());