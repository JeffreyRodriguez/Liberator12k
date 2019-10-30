use <../../../Meta/Clearance.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Components/AR15/Fire Control.scad>;
use <../../../Components/AR15/Mating Pins.scad>;
use <../../../Components/AR15/Trigger Pocket.scad>;
use <../../../Components/AR15/Trigger.scad>;
use <../../../Receiver/Lower/AR15/Liberated Lower.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;

use <Trigger Pocket Ram.scad>;

module AR15_BoltStop(extraTop=ManifoldGap(),
                     clearance=UnitsMetric(0.4), cutter=false) {
  
  
  clear = Clearance(clearance, cutter);
  clear2 = clear*2;


  translate([AR15_RearPinX()+UnitsImperial(3.2)-clear,
             -(UnitsImperial(0.75)/2)-clear,
             -UnitsImperial(0.3)-clear])
  cube([UnitsImperial(0.15)+clear2,
         UnitsImperial(0.75)+clear2,
         UnitsImperial(0.3)+clear+extraTop]);
}

module AR15_TriggerPocketJigBody(height=UnitsImperial(0.75)
                                       +TriggerPocketRamBumperHeight(),
                                 clearance=UnitsImperial(0.005),
                                 alpha=.5) {
  width=UnitsImperial(1.0625);
                                    
  color("White", alpha) render()
  difference() {
    union() {
      
      // Outline of the trigger pocket
      linear_extrude(height=height)
      hull()
      AR15_TriggerPocket2d(clearance=UnitsMetric(4), cutter=true);
      
      AR15_MatingLugRear(cutter=false, extraTop=height);
        
      // Bottom Rear
      translate([AR15_RearPinX(),-(AR15_MatingLugWidth()/2),0])
      cube([AR15_TriggerPocketX(),
            AR15_MatingLugWidth(),
            height]);
      
      // Bottom Front
      translate([AR15_TriggerPocketX()+AR15_TriggerPocketOAL(),
                 -(AR15_MatingLugWidth()/4),0])
      cube([UnitsImperial(0.75),
            (AR15_MatingLugWidth()/2),
            height]);
      
      AR15_BoltStop(extraTop=height, cutter=false);
    }

    render()
    linear_extrude(height=AR15_TriggerPocketDepth()
                         +TriggerPocketRamBumperHeight())
    projection()
    TriggerPocketRam(cutter=true);
    
    AR15_MatingPins(cutter=true);
    
  }
}

module AR15_TriggerPocketTestJig(width=1.25, alpha=1) {
  render()
  difference() {
    union() {
      translate([AR15_RearPinX()-UnitsImperial(0.25),
                 -(width/2),
                 AR15_PinZ()-UnitsImperial(0.25)])
      cube([AR15_TriggerPocketX()+AR15_TriggerPocketOAL()+UnitsImperial(0.625),
            width,
            abs(AR15_PinZ())+UnitsImperial(0.25)]);
      
      // Horn for holding down the jig
      translate([AR15_TriggerPocketX()+AR15_TriggerPocketOAL(),
                 -(AR15_MatingLugWidth()/4),
                 AR15_PinZ()-UnitsImperial(0.25)])
      cube([UnitsImperial(0.75),
            (AR15_MatingLugWidth()/2),
            abs(AR15_PinZ())+UnitsImperial(0.25)]);
      
    }
      
    AR15_MatingLugRear(cutter=true, extraTop=abs(AR15_PinZ()));
    
    AR15_MatingPins(cutter=true);
    
    AR15_BoltStop(cutter=true);
    
    // Wire holes
    for (m = [0,1]) mirror([0,m,0])
    translate([AR15_TriggerPocketX()+UnitsImperial(0.125),
               -UnitsImperial(0.375),-1])
    cylinder(r=0.0625, h=1, $fn=8);
      
    // Test bar
    translate([AR15_TriggerPocketX(),
               -0.5,
               -UnitsImperial(0.25)])
    cube([AR15_TriggerPocketOAL(),
          1,
          abs(AR15_PinZ())+UnitsImperial(0.25)]);
  }
}

module AR15_TriggerPocketJig(alpha=1) {
  translate([0,0,AR15_TriggerPocketDepth()*(1-$t)])
  TriggerPocketRam(cutter=false);

  //union() {
    *AR15_TriggerPocketJigFront(cutter=true);
    
    AR15_TriggerPocketJigBody();
  //}
}


*AR15_LiberatedLower();

AR15_TriggerPocketTestJig();
AR15_TriggerPocketJig();

*!scale(25.4) rotate([0,0,0])
AR15_TriggerPocketTestJig();

*!scale(25.4) rotate([180,0,0])
AR15_TriggerPocketJigBody();

