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

use <../../Upper/Cross Fitting/Charger.scad>;
use <../../Upper/Cross Fitting/Cross Upper.scad>;
use <../../Upper/Cross Fitting/Frame.scad>;
use <../../Upper/Cross Fitting/Forend/Barrel Lugs.scad>;
use <../../Upper/Cross Fitting/Forend/Forend.scad>;
use <../../Upper/Cross Fitting/Forend/Forend Slotted.scad>;
use <../../Upper/Cross Fitting/Firing Pin Guide.scad>;
use <../../Upper/Cross Fitting/Sear Bolts.scad>;
use <../../Upper/Cross Fitting/Sear Guide.scad>;
use <../../Upper/Cross Fitting/Striker.scad>;

use <../../Reference.scad>;

use <Base.scad>;

module Liberator12k_TwistAction(barrelLength=BarrelLength()) {

  // Barrel, lugs and shaft collar (animated)
  translate([LowerMaxX()+ForendMidsectionLength()+ForendSlottedLength(),0]) {

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
      Barrel(hollow=true, barrelLength=barrelLength);
    }
  }

  ForendBaseplate();
  ForendFront();
  LuggedForend(alpha=0.25);
  ForendMidsection();
  ForendSlotted12k(alpha=0.25);
}

module ForendSlotted12k(alpha=1) {

  translate([LowerMaxX()+ManifoldGap(2),0,0])
  rotate([0,90,0])
  color("Gold", alpha)
  render()
  linear_extrude(height=ForendSlottedLength()-ManifoldGap(3))
  ForendSlotted2d(slotAngles=[0,180]);
}

Liberator12k_PlainFrame();
Liberator12k_TwistAction();
Liberator12k_Base();
Liberator12k_Stock();