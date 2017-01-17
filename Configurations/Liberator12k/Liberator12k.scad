//$t=0.7267;
include <../../Meta/Animation.scad>;

use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Double Shaft Collar.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <../../Reference.scad>;

use <../../Upper/Cross Fitting/Charger.scad>;
use <../../Upper/Cross Fitting/Cross Upper.scad>;
use <../../Upper/Cross Fitting/Frame.scad>;
use <../../Upper/Cross Fitting/Forend/Barrel Lugs.scad>;
use <../../Upper/Cross Fitting/Forend/Forend.scad>;
use <../../Upper/Cross Fitting/Forend/Forend Pivoted 608.scad>;
use <../../Upper/Cross Fitting/Forend/Forend Slotted.scad>;
use <../../Upper/Cross Fitting/Firing Pin Guide.scad>;
use <../../Upper/Cross Fitting/Sear Bolts.scad>;
use <../../Upper/Cross Fitting/Sear Guide.scad>;
use <../../Upper/Cross Fitting/Striker.scad>;

//echo($vpr);

//$vpr = [80, 0, 360*$t];

function SearLength() = 2;


module Liberator12k() {
  %Stock(alpha=0.25);

  Breech();

  %Receiver();

  Butt();

  Frame();

  // Rear Frame Nuts
  translate([ReceiverLugRearMinX(),0,0])
  mirror([1,0,0])
  FrameNuts();

  // Front Frame Nuts
  translate([FrameRodLength()+OffsetFrameBack()-ManifoldGap(),0,0])
  mirror([1,0,0])
  FrameNuts();

  Striker();
  ChargingHandle();
  ChargingInsert();
  
  SearBolts();
  
  translate([0,0,-ReceiverCenter()]) {
    Sear();
    SearSupportTab();
    Trigger();
  }

  translate([0,0,-ManifoldGap()])
  SearGuide();

  FiringPinGuide(debug=true);

  CrossInserts(alpha=1);
  CrossUpperFront(alpha=0.25);
  CrossUpperBack(alpha=0.25);

  //
  // Twist-lock Forend
  //
  ForendBaseplate();
  *LuggedForend(alpha=0.25);
  *ForendMidsection();
  *ForendSlotted12k(alpha=0.25);
  *ForendFront();

  // Barrel, lugs and shaft collar (animated)
  *translate([LowerMaxX()+ForendMidsectionLength()+ForendSlottedLength(),0]) {

    translate([ForendSlottedLength()*Animate(ANIMATION_STEP_UNLOAD),0,0])
    translate([-ForendSlottedLength()*Animate(ANIMATION_STEP_LOAD),0,0]) {

      rotate([BarrelLugAngle(),0,0])
      rotate([-BarrelLugAngle()*Animate(ANIMATION_STEP_UNLOCK),0,0])
      rotate([BarrelLugAngle()*Animate(ANIMATION_STEP_LOCK),0,0]) {
        BarrelLugs();

        color("Black")
        rotate([45+15,0,0])
        rotate([0,90,0])
        DoubleShaftCollar();
      }

      translate([-(LowerMaxX()+0.25)-ForendSlottedLength(),0,0])
      Barrel(hollow=true);
    }
  }
  
  //
  // Pivoted Forend
  //
  translate([LowerPivotX(),0,LowerPivotZ()])
  rotate([0,-PivotAngle()*Animate(ANIMATION_STEP_LOAD),0])
  rotate([0,PivotAngle()*Animate(ANIMATION_STEP_UNLOAD),0])
  translate([-LowerPivotX(),0,-LowerPivotZ()]) {

    BarrelPivotLug();
    Barrel();

    BarrelShaftCollar();
    PivotBearings();
  }

  translate([LowerMaxX()+ManifoldGap(2),0,0])
  rotate([0,90,0])
  color("Gold",0.25)
  render()
  linear_extrude(height=ForendSlottedLength()-ManifoldGap(3))
  ForendSlotted2d(slotAngles=[180]);

  ForendPivoted(alpha=0.25);


  // Lower
  translate([0,0,-ReceiverCenter()]) {
    ReceiverLugBoltHoles(clearance=false);
    GuardBolt(clearance=false);
    HandleBolts(clearance=false);
    Lower(showTrigger=false);
  }
}

module ForendSlotted12k(alpha=1) {

  translate([LowerMaxX()+ManifoldGap(2),0,0])
  rotate([0,90,0])
  color("Gold", alpha)
  render()
  linear_extrude(height=ForendSlottedLength()-ManifoldGap(3))
  ForendSlotted2d(slotAngles=[0,180]);
}

//rotate([0,0,360*$t])
Liberator12k();
