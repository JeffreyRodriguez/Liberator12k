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

use <../../Components/Firing Pin Retainer.scad>;

use <../../Components/Cylinder.scad>;

//Spec_PipeThreeQuarterInchSch80()
//Spec_PipeOneInch()
//Spec_PipeOneInchSch80()
//Spec_Tubing1628x1125()

DEFAULT_STRIKER = Spec_RodFiveSixteenthInch();
DEFAULT_BARREL = Spec_RodFiveSixteenthInch();
BARREL_PIPE = Spec_FiveSixteenthInchBrakeLine();
RECEIVER_PIPE = Spec_FiveSixteenthInchBrakeLine();
WALL = 0.25;

EXTRA_REAR = 0.6;
EXTRA_FRONT = LowerWallFront();

function FiringPinZ() = 0.5;

module PrintedUpperFiringPinCutter() {  
  translate([0.5,0,FiringPinZ()])
  FiringPinRetainer(springLength=0);
}

module PrintedUpperFront(extraFront=EXTRA_FRONT, extraRear=0) {
  color("Tan")
  render()
  difference() {
    union() {
        
      // Match the top of the lower-receiver
      linear_extrude(height=1)
      hull()
      intersection() {
        translate([ReceiverLugFrontMinX()-extraRear,-1])
        square([ReceiverLugFrontLength()+extraFront+extraRear, 2]);
        
        projection(cut=true)
        translate([0,0,ManifoldGap()])
        Lower(showTrigger=false);
      }
      
      ReceiverLugFront(extraHeight=ManifoldGap(2));
    }
    
    PrintedUpperFiringPinCutter();
  }
}

module PrintedUpperRear(extraRear=EXTRA_REAR) {
  color("Tan")
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
        translate([ReceiverLugRearMaxX(),0,FiringPinZ()])
        rotate([0,-90,0])
        cylinder(r=PipeOuterRadius(RECEIVER_PIPE)+WALL,
                 h=ReceiverLugRearLength()+extraRear,
               $fn=40);
      }
      
      ReceiverLugRear(extraHeight=ManifoldGap(2));
    }
    
    // Striker Rod
    translate([0,0,FiringPinZ()])
    rotate([0,-90,0])
    Rod(rod=DEFAULT_STRIKER, clearance=RodClearanceLoose(), length=5);
  }
}


module FrontSlideCutouts() {
  // Front slide cutouts
  for (m = [0,1])
  mirror([0,m,0]) {
    translate([ReceiverLugFrontMinX()-ManifoldGap(),
               PipeOuterRadius(pipe=BARREL_PIPE)+WALL,
               WALL-(PipeClearance(BARREL_PIPE, PipeClearanceLoose())/2)])
    cube([2,
          GripWidth(),
          PipeOuterDiameter(pipe=BARREL_PIPE, clearance=PipeClearanceLoose())]);
  }
}

module Slide() {
  color("LightBlue", 0.5)
  render()
  difference() {
    union() {
      translate([ReceiverLugRearMinX(),-0.125-(GripWidth()/2),WALL])
      *cube([LowerMaxX()+abs(ReceiverLugRearMinX())+SLIDE_TRAVEL, GripWidth()+0.25, PipeOuterDiameter(BARREL_PIPE)]);
      
      // Block to fill the space between receiver lugs
      translate([ReceiverLugRearMaxX()+ManifoldGap(),-GripWidth()/2,0])
      cube([ReceiverLugFrontMinX()+abs(ReceiverLugRearMaxX())-0.01,
            GripWidth(),
            1]);
    }
    
    *translate([ReceiverLugFrontMinX() - 0.01,-PipeOuterRadius(BARREL_PIPE) - WALL,0])
    cube([ReceiverLugFrontLength()+SLIDE_TRAVEL+0.01, PipeOuterDiameter(BARREL_PIPE) + (WALL*2), 1]);
    
    *translate([ReceiverLugRearMaxX() - 0.01,-PipeOuterRadius(BARREL_PIPE) - WALL,0])
    cube([SLIDE_TRAVEL+0.01, PipeOuterDiameter(BARREL_PIPE) + (WALL*2), 1]);
    

    PrintedUpperFiringPinCutter();
  }
}

Lower();



module PrintedUpper() {

  PrintedUpperFront();

  PrintedUpperRear();
  
  PrintedUpperFiringPinCutter();

  Slide();
}

PrintedUpper();

*!scale(25.4)
rotate([0,-90,0])
translate([-ReceiverLugFrontMinX(),0,0])
PrintedUpperFront();

*!scale(25.4)
rotate([0,90,0])
translate([-ReceiverLugRearMaxX(),0,0])
PrintedUpperRear();
