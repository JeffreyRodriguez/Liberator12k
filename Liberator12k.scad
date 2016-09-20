//$t=0.7267;
include <Meta/Animation.scad>;

use <Meta/Debug.scad>;
use <Meta/Manifold.scad>;
use <Meta/Resolution.scad>;

use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Double Shaft Collar.scad>;

use <Lower/Receiver Lugs.scad>;
use <Lower/Trigger.scad>;
use <Lower/Lower.scad>;

use <Reference.scad>;

use <Striker.scad>;

use <Upper/Cross Fitting/Barrel Lugs.scad>;
use <Upper/Cross Fitting/Charger.scad>;
use <Upper/Cross Fitting/Cross Upper.scad>;
use <Upper/Cross Fitting/Frame.scad>;
use <Upper/Cross Fitting/Forend.scad>;
use <Upper/Cross Fitting/Forend Slotted.scad>;
use <Upper/Cross Fitting/Sear Bolts.scad>;
use <Upper/Cross Fitting/Firing Pin Guide.scad>;
use <Upper/Cross Fitting/Sear Guide.scad>;

//echo($vpr);

//$vpr = [80, 0, 360*$t];


module Liberator12k() {

  Frame();
  
  // Rear Frame Nuts
  translate([ReceiverLugRearMinX(),0,0])
  mirror([1,0,0])
  FrameNuts();
  
  // Front Frame Nuts
  translate([FrameRodLength()+OffsetFrameBack()-ManifoldGap(),0,0])
  mirror([1,0,0])
  FrameNuts();
  
  
  translate([0,0,-ReceiverCenter()]) {
    Lower(showTrigger=true);
    ReceiverLugBoltHoles(clearance=false);
    GuardBolt(clearance=false);
    HandleBolts(clearance=false);
  }
  
  Striker();
  Charger(showRetainer=false);
  //ChargerRetainer();
  translate([0,0,-ManifoldGap()])
  SearGuide();
  SearBolts();
  
  FiringPinGuide(debug=true);
  
  UpperReceiverFront();
  UpperReceiverBack();
  ChargerRetainer();
  
  CrossInserts();

  Reference();
  
  
  translate([ReceiverLugFrontMaxX(),0,0])
  ForendBaseplate();
  
  color("DimGrey")
  translate([LowerMaxX()+ForendSlottedLength(),0,0])
  Forend(length=ForendUnslottedLength());
  
  translate([LowerMaxX()+ForendSlottedLength()+ForendSlottedLength()+BarrelLugLength()+0.05+ForendUnslottedLength(),0,0])
  ForendFront();

  translate([LowerMaxX()+ForendUnslottedLength()+ForendSlottedLength(),0]) {
    
    translate([ForendSlottedLength()*Animate(ANIMATION_STEP_UNLOAD),0,0])
    translate([-ForendSlottedLength()*Animate(ANIMATION_STEP_LOAD),0,0]) {
      
      rotate([BarrelLugAngle(),0,0])
      rotate([-BarrelLugAngle()*Animate(ANIMATION_STEP_UNLOCK),0,0])
      rotate([BarrelLugAngle()*Animate(ANIMATION_STEP_LOCK),0,0]) {      
        BarrelLugs();
          
        color("Black")
        rotate([45+15,0,0])
        DoubleShaftCollar();
      }

      translate([-(LowerMaxX()+0.25)-ForendSlottedLength(),0,0])
      Barrel(hollow=true);
    }
    
    translate([ManifoldGap(),0,0])
    LuggedForend(lengthClosed=ForendSlottedLength());
  }
  
  color("Gold")
  ForendSlotted(slotAngles=[90,270]);
}

//rotate([0,0,360*$t])
Liberator12k();
