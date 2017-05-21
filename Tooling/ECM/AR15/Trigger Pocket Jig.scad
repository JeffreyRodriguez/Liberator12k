use <../../../Meta/Clearance.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Components/AR15/Fire Control.scad>;
use <../../../Components/AR15/Mating Pins.scad>;
use <../../../Components/AR15/Trigger Pocket.scad>;
use <../../../Components/AR15/Trigger.scad>;
use <../../../Lower/AR15/Liberated Lower.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;

use <Trigger Pocket Ram.scad>;

module AR15_TriggerPocketJigBody(clearance=UnitsImperial(0.005),
                                  alpha=.5) {
  width=UnitsImperial(1.0625);
                                    
  color("White", alpha) render()
  difference() {
    union() {
      hull() {
        
        // Bottom Rear
        translate([AR15_RearPinX(),-0.25,0])
        cube([AR15_TriggerPocketX(),
              0.5,
              UnitsMetric(10)]);
        
        // Top, to support insert
        translate([AR15_TriggerPocketX(),-width/2,0])
        cube([AR15_TriggerPocketOAL()+UnitsMetric(15),
              width,
              AR15_TriggerPocketDepth()+TriggerPocketRamBumperHeight()-ManifoldGap()-clearance]);
      }
      
      AR15_MatingLugRear(cutter=false, extraTop=UnitsMetric(10));
    }
    
    
    AR15_TriggerPocketJigFront(cutter=true);

    render()
    translate([0,0,-ManifoldGap()])
    linear_extrude(height=AR15_TriggerPocketDepth()+TriggerPocketRamBumperHeight())
    projection()
    TriggerPocketRam(cutter=true);
    
    AR15_MatingPins(cutter=true);
    
  }
}


module AR15_TriggerPocketJigFront(cutter=false,
                                 clearance=UnitsImperial(0.008),
                                 alpha=1) {
                                   
  clear = Clearance(clearance,cutter);
  clear2 = clear*2;

  color("Orange", alpha) render()
  difference() {
    union() {
      
      // Tapered point
      translate([AR15_TriggerPocketX()+AR15_TriggerPocketOAL()-clear,
                 -(AR15_MatingLugWidth()/2)-clear,
                 UnitsImperial(0.625)])
      rotate([0,45,0])
      cube([(UnitsImperial(0.75)+clear2)/sqrt(2),
             AR15_MatingLugWidth()+clear2,
             (UnitsImperial(0.75)+clear2)/sqrt(2)]);
      
      // Supporting bar
      translate([AR15_TriggerPocketX()+AR15_TriggerPocketOAL()+UnitsImperial(0.375),
                 -(AR15_MatingLugWidth()/2)-clear,
                 UnitsImperial(0.25)-clear])
      cube([AR15_MatingPinDistance()-AR15_TriggerPocketOAL()-UnitsImperial(1.0),
            AR15_MatingLugWidth()+clear2,
            UnitsImperial(0.75)+clear2]);
      
      AR15_MatingLugFront(cutter=false, extraTop=abs(AR15_PinZ())+UnitsImperial(0.75));
    }
    
    AR15_MatingPins(cutter=true);
  }
}

module AR15_TriggerPocketTestJig(alpha=1) {
  render()
  difference() {
    union() {
      
      // Indexed point
      intersection() {
        AR15_TriggerPocketJigFront();
        
        // Supporting bar
        translate([AR15_TriggerPocketX()+AR15_TriggerPocketOAL(),
                   -AR15_MatingLugWidth(),
                   UnitsImperial(0.25)])
        cube([UnitsImperial(1.25),
              AR15_MatingLugWidth()*2,
              UnitsImperial(0.75)]);
        
      }

      // Bottom Front
      translate([AR15_TriggerPocketX()+AR15_TriggerPocketOAL()+UnitsImperial(0.6),
                 -AR15_MatingLugWidth(),
                 -UnitsImperial(0.255)])
      cube([UnitsImperial(0.65),
            AR15_MatingLugWidth()*2,
            UnitsImperial(0.75)]);
      
      // Bottom
      translate([AR15_RearPinX()-UnitsImperial(0.25),
                 -0.5,
                 AR15_PinZ()-UnitsImperial(0.25)])
      cube([AR15_TriggerPocketX()+AR15_TriggerPocketOAL()+UnitsImperial(1.5),
            1,
            abs(AR15_PinZ())+UnitsImperial(0.25)]);
    }
      
    AR15_MatingLugRear(cutter=true, extraTop=abs(AR15_PinZ()));
    
    AR15_MatingPins(cutter=true);
      
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
    AR15_TriggerPocketJigFront(cutter=true);
    
    AR15_TriggerPocketJigBody();
  //}
}


*AR15_LiberatedLower();
*AR15_TriggerPocketTestJig();

AR15_TriggerPocketJig();

*!scale(25.4) rotate([0,0,0])
AR15_TriggerPocketTestJig();

*!scale(25.4) rotate([90,0,0])
AR15_TriggerPocketJigFront();

*!scale(25.4) rotate([180,0,0])
AR15_TriggerPocketJigBody();

