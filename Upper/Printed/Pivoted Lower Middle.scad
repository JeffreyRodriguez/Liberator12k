use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Bearing.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Lower Plater.scad>;
use <../../Lower/Trigger.scad>;

function PivotBearing() = Spec_Bearing608();
function PivotWall()    = 0.25;

function LowerPivotX(bearing=PivotBearing(),
                                  wall=PivotWall())

                              = LowerMaxX()
                              + BearingOuterRadius(bearing)
                              + wall;
function LowerPivotZ() = -LowerGuardHeight();

function LowerPivotBolt() = Spec_BoltM8();

module LowerPivotLug(wall=PivotWall(), bearing=PivotBearing()) {
  height = TriggerFingerWall()
         + TriggerFingerRadius();

  render()
  difference() {
    hull() {
      translate([ReceiverLugFrontMinX(), -0.25, -LowerGuardHeight()])
      cube([ReceiverLugFrontLength()+LowerWallFront(), 0.5, height]);

      translate([LowerPivotX(),0,LowerPivotZ()])
      rotate([90,0,0])
      cylinder(r=BearingOuterRadius(bearing)+wall, h=0.5,
               center=true, $fn=Resolution(15,40));
    }

    LowerPivotLugBolt(clearance=true);

    LowerCutouts();
  }
}

module LowerPivotLugBolt(boltSpec=Spec_BoltM8(),
                             length=UnitsMetric(30),
                             clearance=true) {
  cutter = (clearance) ? 1 : 0;

  color("SteelBlue")
  translate([LowerPivotX(),
             length-(GripWidth()/2),
             LowerPivotZ()])
  rotate([90,0,0])
  rotate([0,0,90])
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=clearance,
              capHeightExtra=cutter, nutBackset=0.06, nutHeightExtra=cutter);
}

module LowerPivotedMiddle(bearing=PivotBearing()) {
  color("DimGrey")
  render()
  union() {
    LowerMiddle();
    LowerPivotLug();
  }
}

module LowerPivoted(showLeft=true, showRight=true, showMiddle=true) {
  
  // Sides
  Lower(showMiddle=false,
        showLeft=showLeft,
        showRight=showRight);

  // Middle
  if (showMiddle)
  color("DimGrey")
  render()
  union() {
    LowerMiddle();
    LowerPivotLug();
  }
}

LowerPivoted();

//!scale(25.4) LowerMiddlePlater() LowerPivotedMiddle(showSides=false);
