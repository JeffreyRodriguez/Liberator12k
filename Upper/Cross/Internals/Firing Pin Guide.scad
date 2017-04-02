include <../../../Meta/Animation.scad>;

use <../../../Components/Firing Pin Retainer.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Components/Teardrop.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Debug.scad>;

use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Pipe.scad>;

use <../Reference.scad>;
use <../../../Lower/Trigger.scad>;

use <Sear Bolts.scad>;
use <Charger.scad>;
use <Striker.scad>;

function FiringPinOffsetX() = BreechRearX()-0.75-0.125;
function FiringPinProtrusion() = 3/32;
function FiringPinHeadLength() = 0.4;
function FiringPinLength() = BreechFrontX()
                           + FiringPinProtrusion()
                           - RodRadius(SearRod())
                           -0.125;

module FiringPin() {
  color("Red")
  render(convexity=4)
  translate([FiringPinOffsetX()+0.125,0,0])
  rotate([0,90,0])
  union() {

    // Nail Body
    Rod(rod=FiringPinRod(), clearance=RodClearanceLoose(), length=FiringPinLength());

    // Nail Double-Head
    for (i = [0,0.31])
    translate([0,0,i])
    cylinder(r=0.15, h=0.08, $fn=10);
  }
}

module FiringPinGuide(od=ReceiverID()-0.01,
                    debug=false) {
  height = ReceiverLength()
         - PipeThreadDepth(StockPipe())
         - BushingDepth(BreechBushing());
  echo("Firing Pin Guide Length", height);

  if (debug) {
    color("SteelBlue")
    translate([FiringPinOffsetX()+FiringPinHeadLength(),0,0])
    FiringPinRetainerPins();


    color("SteelBlue")
    translate([0.15*Animate(ANIMATION_STEP_STRIKER),0,0])
    translate([-0.15*Animate(ANIMATION_STEP_CHARGE),0,0])
    FiringPin();
  }


  color("PaleTurquoise",0.5)
  render(convexity=4)
  difference() {

    // Body
    translate([BreechRearX(),0,0])
    rotate([0,-90,0])
    cylinder(r=od/2, h=height, $fn=Resolution(20,30));

    // Striker Hole
    hull() {
      translate([-0.25,0,0])
      translate([BreechRearX(),0,0])
      rotate([0,-90,0])
      Rod(rod=StrikerRod(), clearance=RodClearanceLoose(), length=height);

      translate([FiringPinOffsetX()+FiringPinHeadLength(),0,0])
      FiringPinRetainer(showPins=false);
    }

    // Scoop out a path for the striker top
    translate([0.1,
               -(StrikerTopWidth()/2)-0.02,
               (RodRadius(StrikerRod())*sin(45))-0.01])
    mirror([1,0,0])
    cube([height+ManifoldGap(2),
          StrikerTopWidth()+0.04,
          od]);

    // Scoop out a path for the charging handle
    translate([FiringPinOffsetX()+FiringPinHeadLength()+0.03,
               -(ChargingHandleWidth()/2)-0.03,
               0])
    mirror([1,0,0])
    cube([height+ManifoldGap(2),
          ChargingHandleWidth()+0.06,
          od]);

    translate([0,0,-ReceiverCenter()])
    linear_extrude(height=ReceiverCenter())
    Teardrop(r=RodRadius(SearRod(), RodClearanceLoose()),
             rotation=180);


    translate([FiringPinOffsetX()+FiringPinHeadLength(),0,0])
    FiringPinRetainer(gap=0.14, teardrop=true);

    // Bolts
    SearBolts(teardrop=true, cutter=true);
  }
}


ChargingHandle();

ChargingInsert();

Striker();

translate([0,0,-ReceiverCenter()])
TriggerGroup();

//FiringPin();
SearBolts(cutter=false);
FiringPinGuide(debug=true);

color("black", 0.25)
Reference();

*!scale(25.4) rotate([0,90,0])
FiringPinGuide();
