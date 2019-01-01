include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Rod.scad>;

// Settings: Vitamins
DEFAULT_FIRING_PIN_RETAINER_BOLT = Spec_BoltM5();

module FiringPin(cutter=false, debug=false) {
  clear = cutter ? 0.002 : 0;
  clear2 = clear*2;
  
  union() {
    color("Silver")
    DebugHalf(enabled=debug)
    translate([0,0,-0.0])
    cylinder(r=(5/16/2)+clear, h=1+clear2, $fn=Resolution(20,50));
    
    color("DarkGoldenrod")
    translate([0,0,-0.5])
    cylinder(r=(3/32/2)+clear, h=1, $fn=Resolution(20,50));
  }
}

module FiringPinSetScrew(bolt=DEFAULT_FIRING_PIN_RETAINER_BOLT, cutter=false) {
  clear = cutter ? 0.002 : 0;
  clear2 = clear*2;
  
    color("CornflowerBlue")
  translate([0.0625,0,0.5-0.125+ManifoldGap()])
  rotate([0,90,0])
  Bolt(bolt=bolt, cap=false,
       clearance=cutter,
       length=0.25+ManifoldGap(2));
}

module FiringPinRetainer(bolt=DEFAULT_FIRING_PIN_RETAINER_BOLT, cutter=false, alpha=0.5, debug=false) {
  color("Grey")
  DebugHalf(enabled=debug)
  difference() {
    translate([-0.25,-0.75,0])
    cube([0.5, 1.5, 0.5]);
    
    if (!cutter) {
      FiringPin(cutter=true);
      
      FiringPinRetainerBolts(bolt=bolt, cutter=true);
    }
  }
}

module FiringPinRetainerBolts(bolt=DEFAULT_FIRING_PIN_RETAINER_BOLT,
                              breechThickness=0.375, cutter=false) {
  color("CornflowerBlue")
  for (Y = [1,-1])
  translate([0,Y*(1.125/2),0.5+ManifoldGap()])
  Bolt(bolt=bolt, capOrientation=true,
       clearance=cutter,
       length=0.5+breechThickness+ManifoldGap(2));
}

module FiringPinAssembly(cutter=false, debug=false) {
  FiringPin(cutter=cutter, debug=debug);
  FiringPinSetScrew();
  FiringPinRetainerBolts(cutter=cutter);
  FiringPinRetainer(cutter=cutter, debug=debug, alpha=0.5);
}

FiringPinAssembly(cutter=false);
