use <../../Meta/Clearance.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Manifold.scad>;

use <Mating Pins.scad>;

function AR15_TriggerPocketDepth()         = UnitsMetric(32);
function AR15_TriggerPocketWidth()         = UnitsMetric(18);
function AR15_TriggerPocketLength()        = UnitsMetric(45);
function AR15_TriggerWidth()               = UnitsMetric(7);
function AR15_TriggerSelectorLength()      = UnitsMetric(16);
function AR15_TriggerPocketSelectorWidth() = UnitsMetric(9);
function AR15_TriggerPocketHammerLength()  = UnitsMetric(3);
function AR15_TriggerPocketHammerWidth()   = UnitsMetric(9);
function AR15_TriggerPocketOffsetX()       = UnitsImperial(0.565);

function AR15_TriggerPocketX() = AR15_RearPinX()+AR15_TriggerPocketOffsetX();

function AR15_TriggerPocketOAL()      = AR15_TriggerPocketLength()
                                      + AR15_TriggerSelectorLength()
                                      + AR15_TriggerPocketHammerLength();

module AR15_TriggerPocket2d(clearance=UnitsMetric(0.8), cutter=false) {
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


module AR15_TriggerPocket(clearance=UnitsMetric(0.8), cutter=false) {

  translate([0,0,-AR15_TriggerPocketDepth()]) {
    linear_extrude(height=AR15_TriggerPocketDepth()+ManifoldGap())
    AR15_TriggerPocket2d(clearace=clearance, cutter=cutter);
    
    translate([0,0,-UnitsMetric(10)])
    linear_extrude(height=AR15_TriggerPocketDepth())
    AR15_TriggerHole2d(clearance=clearance, cutter=cutter);
  }
}

module AR15_TriggerHole2d(clearance=UnitsMetric(0.8), cutter=false) {
  translate([AR15_TriggerPocketX()+AR15_TriggerSelectorLength()+UnitsMetric(11.5), -(AR15_TriggerWidth()/2)])
  square([UnitsMetric(15),AR15_TriggerWidth()]);
}

module AR15_TriggerPocketTriggerHole(clearance=UnitsMetric(0.8), cutter=false) {
  
  translate([0,0,-UnitsMetric(10)])
  linear_extrude(height=AR15_TriggerPocketDepth())
  AR15_TriggerHole2d();
}

AR15_TriggerPocket(clearance=UnitsMetric(0.8), cutter=true);
