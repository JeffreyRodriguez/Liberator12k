//$t=0.7267;
include <../../Meta/Animation.scad>;

use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;

use <../../Upper/Cross/Reference.scad>;
use <../../Upper/Cross/Cross Upper.scad>;
use <../../Upper/Cross/Forend/Forend.scad>;
use <../../Upper/Cross/Forend/Forend Slotted.scad>;
use <../../Upper/Cross/Forend/Single/Pivot/Forend Pivoted.scad>;

use <Base.scad>;

module Liberator12k_BreakAction(barrelLength=18, alpha=1) {

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
  color("Gold",alpha)
  render()
  linear_extrude(height=ForendSlottedLength()-ManifoldGap(3))
  ForendSlotted2d(slotAngles=[180]);

  ForendPivoted(alpha=alpha);
  ForendPivotLock(alpha=alpha);
}

//rotate([0,0,360*$t])
Liberator12k_PlainFrame();
Liberator12k_BreakAction();
Liberator12k_Base();
Liberator12k_Stock();
