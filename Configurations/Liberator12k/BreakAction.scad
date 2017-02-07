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
use <../../Upper/Cross Fitting/Forend/Forend Pivoted.scad>;
use <../../Upper/Cross Fitting/Forend/Forend Slotted.scad>;
use <../../Upper/Cross Fitting/Firing Pin Guide.scad>;
use <../../Upper/Cross Fitting/Sear Bolts.scad>;
use <../../Upper/Cross Fitting/Sear Guide.scad>;
use <../../Upper/Cross Fitting/Striker.scad>;

use <Liberator12k.scad>;

//echo($vpr);

//$vpr = [80, 0, 360*$t];

function SearLength() = 2;

DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();


module Liberator12k_BreakAction(barrel=DEFAULT_BARREL) {
  
  ForendBaseplate();

  translate([LowerPivotX(),0,LowerPivotZ()])
  rotate([0,-PivotAngle()*Animate(ANIMATION_STEP_LOAD),0])
  rotate([0,PivotAngle()*Animate(ANIMATION_STEP_UNLOAD),0])
  translate([-LowerPivotX(),0,-LowerPivotZ()]) {

    Barrel();

    BarrelShaftCollar();
  }
  

  Liberator12k_PlainFrame();
  
  Liberator12k_Base();
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
Liberator12k_BreakAction();
