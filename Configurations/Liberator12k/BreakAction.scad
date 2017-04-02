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

use <../../Components/Pipe Cap.scad>;

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

use <Base.scad>;

module Liberator12k_BreakAction(barrelLength=18) {

  translate([LowerPivotX(),0,LowerPivotZ()])
  rotate([0,-PivotAngle()*Animate(ANIMATION_STEP_LOAD),0])
  rotate([0,PivotAngle()*Animate(ANIMATION_STEP_UNLOAD),0])
  translate([-LowerPivotX(),0,-LowerPivotZ()]) {

    Barrel(barrelLength=barrelLength, hollow=true);

    BarrelShaftCollar();
  }
  
  PivotRod(cutter=false);
  LockRod(cutter=false);

  translate([ReceiverLugFrontMaxX()+1.8125+ManifoldGap(2),0,0])
  rotate([0,90,0])
  color("Gold",0.25)
  render()
  linear_extrude(height=ForendSlottedLength()-ManifoldGap(3))
  ForendSlotted2d(slotAngles=[180]);

  ForendPivoted(alpha=0.5);
  ForendPivotLock(alpha=0.5);
}

//rotate([0,0,360*$t])
Liberator12k_PlainFrame();
Liberator12k_BreakAction();
Liberator12k_Base();
Liberator12k_Stock();
