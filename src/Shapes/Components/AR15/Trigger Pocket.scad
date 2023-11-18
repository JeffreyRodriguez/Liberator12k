include <../../../Meta/Common.scad>;

use <../../../Meta/Clearance.scad>;
use <Mating Pins.scad>;

function AR15_TriggerPocketDepth()         = Millimeters(32);
function AR15_TriggerPocketWidth()         = Millimeters(18);
function AR15_TriggerPocketLength()        = Millimeters(45);
function AR15_TriggerWidth()               = Millimeters(7);
function AR15_TriggerSelectorLength()      = Millimeters(16);
function AR15_TriggerPocketSelectorWidth() = Millimeters(9);
function AR15_TriggerPocketHammerLength()  = Millimeters(3);
function AR15_TriggerPocketHammerWidth()   = Millimeters(9);
function AR15_TriggerPocketOffsetX()       = Inches(0.565);

function AR15_TriggerPocketX() = AR15_RearPinX()+AR15_TriggerPocketOffsetX();

function AR15_TriggerPocketOAL()      = AR15_TriggerPocketLength()
                                      + AR15_TriggerSelectorLength()
                                      + AR15_TriggerPocketHammerLength();

module AR15_TriggerPocket2d(clearance=Millimeters(0.8), cutter=false) {
  clear = Clearance(clearance, cutter);
  clear2 = clear*2;

  selectorWidth  = AR15_TriggerPocketHammerWidth()  + clear2;
  hammerWidth  = AR15_TriggerPocketHammerWidth()  + clear2;

  triggerPocketWidth  = AR15_TriggerPocketWidth() + clear2;
  triggerPocketLength = AR15_TriggerPocketLength() + clear2;

  render()
  translate([AR15_TriggerPocketX(),0,0])
  union() {

    // Trigger pack body
    translate([AR15_TriggerSelectorLength()-clear,-triggerPocketWidth/2])
    square([triggerPocketLength,triggerPocketWidth]);

    // Hammer travel
    translate([AR15_TriggerSelectorLength()+AR15_TriggerPocketLength()+clear,
                -(hammerWidth/2)])
    square([AR15_TriggerPocketHammerLength()+ManifoldGap(), hammerWidth]);

    // Selector Extension
    translate([-clear,-(selectorWidth/2)])
    square([AR15_TriggerSelectorLength()+ManifoldGap(),selectorWidth]);
  }
}


module AR15_TriggerPocket(clearance=Millimeters(0.8), cutter=false) {

  translate([0,0,-AR15_TriggerPocketDepth()]) {
    linear_extrude(height=AR15_TriggerPocketDepth()+ManifoldGap())
    AR15_TriggerPocket2d(clearace=clearance, cutter=cutter);

    translate([0,0,-Millimeters(10)])
    linear_extrude(height=AR15_TriggerPocketDepth())
    AR15_TriggerHole2d(clearance=clearance, cutter=cutter);
  }
}

module AR15_TriggerHole2d(clearance=Millimeters(0.8), cutter=false) {
  translate([AR15_TriggerPocketX()+AR15_TriggerSelectorLength()+Millimeters(11.5), -(AR15_TriggerWidth()/2)])
  square([Millimeters(15),AR15_TriggerWidth()]);
}

module AR15_TriggerPocketTriggerHole(clearance=Millimeters(0.8), cutter=false) {

  translate([0,0,-Millimeters(10)])
  linear_extrude(height=AR15_TriggerPocketDepth())
  AR15_TriggerHole2d();
}

AR15_TriggerPocket(clearance=Millimeters(0.8), cutter=true);
