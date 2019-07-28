//$t=0.6;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Units.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

use <Receiver Lugs.scad>;
use <Lower.scad>;


function LowerLugMinX() = ReceiverLugFrontMaxX()+0.5;
function LowerLugMaxX() = LowerLugMinX()+0.5;
function LowerLugLength() = LowerLugMaxX() - LowerLugMinX();

function LowerLugMaxZ() = 0;
function LowerLugMinZ() = LowerLugMaxZ()-0.75;
function LowerLugHeight() = LowerLugMaxZ() - LowerLugMinZ();

function LowerLugBoltX() = ReceiverLugFrontMaxX()+0.75;
function LowerLugBoltZ() = -0.5;

module LowerLug(holes=true, cutter=false) {
  clearance = cutter ? 0.005 : 0;

  render()
  difference() {
    translate([LowerLugMinX(),-clearance, LowerLugMinZ()-clearance])
    translate([0,-0.25,0])
    cube([LowerLugLength()+clearance,
          0.5+ManifoldGap(),
          LowerLugHeight()+(clearance*2)]);

    if (holes)
    LowerLugBolts(clearance=true);
  }
}

module LowerLugBolts(boltSpec=Spec_BoltM3(), length=UnitsMetric(30), clearance=true) {
  color("Silver")
  translate([LowerLugBoltX(),0, -0.5])
  translate([0,(GripWidth()/2)+0.125,0.25])
  rotate([90,0,0])
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=clearance);
}

Lower();
LowerLug(holes=true, cutter=false);
LowerLugBolts();
