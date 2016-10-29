use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;

use <../../Components/Internal Thread Cutter.scad>;

//Spec_PipeThreeQuarterInchSch80()
//Spec_PipeOneInch()
//Spec_PipeOneInchSch80()
//Spec_Tubing1628x1125()

DEFAULT_STRIKER = Spec_RodFiveSixteenthInch();
DEFAULT_BARREL = Spec_RodFiveSixteenthInch();
RECEIVER_PIPE = Spec_PipeThreeQuarterInchSch80Stainless();
DEFAULT_TEE = Spec_AnvilForgedSteel_TeeThreeQuarterInch();
WALL = 0.25;
PIPE_LENGTH = 3;

PIPE_EXTRA = PIPE_LENGTH
           - ReceiverLugFrontMaxX()
           + ReceiverLugRearMinX();

EXTRA_REAR = 0;
EXTRA_FRONT = max(0.5,PIPE_EXTRA - EXTRA_REAR);
//1.95+(PipeThreadLength(RECEIVER_PIPE)-PipeThreadDepth(RECEIVER_PIPE))


module PipeHousingFront(extraFront=EXTRA_FRONT) {
  render()
  difference() {
    union() {
      hull() {
        
        // Match the top of the lower-receiver
        linear_extrude(height=ManifoldGap())
        intersection() {
          translate([ReceiverLugFrontMinX(),-1])
          square([ReceiverLugFrontLength()+extraFront, 2]);
          
          projection(cut=true)
          translate([0,0,ManifoldGap()])
          Lower(showTrigger=false);
        }
        
        // Main body
        translate([ReceiverLugFrontMinX(),0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
        rotate([0,90,0])
        cylinder(r=PipeOuterRadius(RECEIVER_PIPE)+WALL,
                 h=ReceiverLugFrontLength()+extraFront,
               $fn=50);
      
        // Front cap
        translate([ReceiverLugFrontMaxX()+extraFront,0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
        rotate([0,90,0])
        cylinder(r=PipeOuterRadius(RECEIVER_PIPE),
                 h=0.25,
               $fn=PipeFn(RECEIVER_PIPE));
      }
      
      ReceiverLugFront(extraHeight=ManifoldGap(2));
    }
    
    // Threadable Pipe Hole
    translate([ReceiverLugFrontMaxX()+extraFront,
               0,
               PipeOuterRadius(RECEIVER_PIPE)+WALL])
    rotate([0,-90,0])
    InternalThreadCutter(length=ReceiverLugFrontMaxX()+extraFront);
    
    // Striker Rod
    translate([0,0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
    rotate([0,90,0])
    Rod(rod=DEFAULT_STRIKER, clearance=RodClearanceSnug(), length=5);
  }
}

module RearBoltIterator() {
       
  // Rear Sights/Bolts
  for (i=[0,1])
  mirror([0,i,0])
  translate([ReceiverLugRearMaxX(),
             (PipeOuterRadius(RECEIVER_PIPE)+(WALL/2)),
             PipeOuterRadius(RECEIVER_PIPE)])
  rotate([0,-90,0])
  rotate([0,0,15])
  children();
}

module PipeHousingRear(extraRear=EXTRA_REAR) {
  render()
  difference() {
    union() {
      hull() {
        
        // Match the top of the lower-receiver
        linear_extrude(height=ManifoldGap())
        intersection() {
          translate([ReceiverLugRearMinX()-extraRear,-1])
          square([ReceiverLugRearLength()+extraRear, 2]);
          
          projection(cut=true)
          translate([0,0,ManifoldGap()])
          Lower(showTrigger=false);
        }
        
        // Main body
        translate([ReceiverLugRearMaxX(),0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
        rotate([0,-90,0])
        cylinder(r=PipeOuterRadius(RECEIVER_PIPE)+WALL,
                 h=ReceiverLugRearLength()+extraRear,
               $fn=50);
        
        // Rear cap
        translate([ReceiverLugRearMaxX()
                      -PipeThreadLength(RECEIVER_PIPE)
                      -extraRear,0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
        rotate([0,-90,0])
        cylinder(r=PipeOuterRadius(RECEIVER_PIPE),
                 h=0.5,
               $fn=PipeFn(RECEIVER_PIPE));
      
        // Rear bolts
        RearBoltIterator()
        hull()
        NutAndBolt(bolt=Spec_BoltM4(), boltLength=UnitsMetric(30),
                   capRadiusExtra=0.125, nutRadiusExtra=0.125);
      }
      
      ReceiverLugRear(extraHeight=ManifoldGap(2));
    }
    
    // Rear bolt holes
    RearBoltIterator()
    NutAndBolt(bolt=Spec_BoltM4(), boltLength=UnitsMetric(30),
               boltLengthExtra=UnitsMetric(1), nutBackset=UnitsMetric(1),
               clearance=true, capHeightExtra=1, nutHeightExtra=0,
               nutSideExtra=1);
    
    // Threadable Pipe Hole
    translate([ReceiverLugRearMaxX()
                 -PipeThreadLength(RECEIVER_PIPE)
                 +ManifoldGap()-extraRear,
               0,
               PipeOuterRadius(RECEIVER_PIPE)+WALL])
    rotate([0,90,0])
    InternalThreadCutter(length=2);
    
    // Striker Rod
    translate([0,0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
    rotate([0,-90,0])
    Rod(rod=DEFAULT_STRIKER, clearance=RodClearanceLoose(), length=5);
  }
}

Lower();

// Rear bolt holes
RearBoltIterator()
NutAndBolt(bolt=Spec_BoltM4(), boltLength=UnitsMetric(30),
           nutBackset=UnitsMetric(1));

color("Silver")
translate([ReceiverLugRearMinX()-EXTRA_REAR,0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
rotate([0,90,0])
Pipe(pipe=RECEIVER_PIPE, length=PIPE_LENGTH,
     hollow=true, clearance=undef);

color("Tan", 0.5)
PipeHousingFront();

color("Tan", 0.5)
PipeHousingRear();

*!scale(25.4)
rotate([0,-90,0])
translate([-ReceiverLugFrontMinX(),0,0])
PipeHousingFront();

*!scale(25.4)
rotate([0,90,0])
translate([-ReceiverLugRearMaxX(),0,0])
PipeHousingRear();
