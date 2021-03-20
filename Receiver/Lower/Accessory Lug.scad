//$t=0.6;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;

use <Lugs.scad>;
use <Lower.scad>;


function FrontLugMinX() = ReceiverLugFrontMaxX()+0.5;
function FrontLugMaxX() = LowerLugMinX()+0.5;
function FrontLugLength() = LowerLugMaxX() - LowerLugMinX();

function FrontLugMaxZ() = 0;
function FrontLugMinZ() = LowerLugMaxZ()-0.75;
function FrontLugHeight() = LowerLugMaxZ() - LowerLugMinZ();

function FrontLugBoltX() = ReceiverLugFrontMaxX()+0.75;
function FrontLugBoltZ() = -0.5;

module FrontLug(holes=true, cutter=false) {
  clearance = cutter ? 0.005 : 0;

  render()
  difference() {
    translate([FrontLugMinX(),-clearance, FrontLugMinZ()-clearance])
    translate([0,-0.25,0])
    cube([FrontLugLength()+clearance,
          0.5+ManifoldGap(),
          FrontLugHeight()+(clearance*2)]);

    if (holes)
    FrontLugBolts(cutter=true);
  }
}

module FrontLugBolts(boltSpec=BoltSpec("M3"), length=UnitsMetric(30), clearance=0.005, cutter=false) {
  clear = cutter ? clearance : 0;
  
  color("Silver")
  translate([FrontLugBoltX(),0, -0.5])
  translate([0,(GripWidth()/2)+0.125,0.25])
  rotate([90,0,0])
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=clear);
}

Lower();
FrontLug(holes=true, cutter=false);
FrontLugBolts();
