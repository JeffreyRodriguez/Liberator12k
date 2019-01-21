include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Finishing/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Rod.scad>;

// Settings: Vitamins
DEFAULT_FIRING_PIN_RETAINER_BOLT = Spec_BoltM5();

function FiringPinRod() = Spec_RodThreeEighthsInch();
function FiringPinBodyLength() = 1;
function FiringPinRetainerLength() = 0.625+.25;
function FiringPinSpringLength() = 0.375;

module FiringPin(cutter=false, debug=false) {
  clear = cutter ? 0.002 : 0;
  clear2 = clear*2;
  
  translate([0,0,FiringPinSpringLength()])
  union() {
    color("Silver")
    DebugHalf(enabled=debug)
    Rod(FiringPinRod(), clearance=cutter?RodClearanceLoose():undef,
        length=FiringPinBodyLength()+clear2);
    
    color("DarkGoldenrod")
    translate([0,0,-0.5-(cutter?0.5:0)])
    cylinder(r=(3/32/2)+clear,
             h=FiringPinBodyLength()+(cutter?0.5:0),
             $fn=Resolution(20,50));
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
    intersection() {
      ChamferedCylinder(r1=0.75, r2=1/16, h=FiringPinRetainerLength(), $fn=Resolution(30,50));
      
      translate([-0.375, -0.75, 0])
      ChamferedCube([1, 1.5, FiringPinRetainerLength()], r=1/16);
    }
    
    if (!cutter) {
      FiringPin(cutter=true);
      
      FiringPinRetainerBolts(bolt=bolt, cutter=true);
      
      FiringPinSpring(cutter=true);
    }
  }
}

module FiringPinSpring(cutter=false, debug=true) {
  clear = cutter ? 0.002 : 0;
  clear2 = clear*2;
  
  translate([0,0,FiringPinSpringLength()])
  union() {
    color("Silver")
    DebugHalf(enabled=debug)
    Rod(FiringPinRod(), clearance=cutter?RodClearanceLoose():undef,
        length=FiringPinSpringLength()+clear2);
    
    color("DarkGoldenrod")
    cylinder(r=(0.25/2)+clear, h=FiringPinSpringLength(), $fn=Resolution(20,50));
  }
  
}

module FiringPinRetainerBolts(bolt=DEFAULT_FIRING_PIN_RETAINER_BOLT,
                              breechThickness=0.375, cutter=false) {
  color("CornflowerBlue")
  for (Y = [1,-1])
  translate([0,Y*(1.125/2),FiringPinRetainerLength()+ManifoldGap()])
  Bolt(bolt=bolt, capOrientation=true,
       clearance=cutter,
       length=FiringPinRetainerLength()+breechThickness+ManifoldGap(2));
}

module FiringPinAssembly(
         retainerBolt=DEFAULT_FIRING_PIN_RETAINER_BOLT,
         cutter=false, debug=false) {

  FiringPin(cutter=cutter, debug=debug);
  FiringPinSetScrew();
  FiringPinRetainerBolts(bolt=retainerBolt, cutter=cutter);
  FiringPinRetainer(cutter=cutter, debug=debug, alpha=0.5);
}

FiringPinAssembly(cutter=false, debug=true);
