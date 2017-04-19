//$t=0.7267;
include <../../Meta/Animation.scad>;

use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Double Shaft Collar.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;

use <../../Upper/Cross/Reference.scad>;
use <../../Upper/Cross/Cross Upper.scad>;
use <../../Upper/Cross/Forend/Forend.scad>;
use <../../Upper/Cross/Forend/Extras/Forend Baseplate.scad>;
use <../../Upper/Cross/Forend/Forend Slotted.scad>;
use <../../Upper/Cross/Forend/Single/Twist/Barrel Lugs.scad>;
use <../../Upper/Cross/Forend/Single/Twist/Lugged Forend.scad>;


use <Base.scad>;

module Liberator12k_TwistAction(barrelLength=BarrelLength(), alpha=1) {

  // Barrel, lugs and shaft collar (animated)
  translate([ForendSlottedLength()*Animate(ANIMATION_STEP_UNLOAD),0,0])
  translate([-ForendSlottedLength()*Animate(ANIMATION_STEP_LOAD),0,0]) {

    rotate([BarrelLugAngle(),0,0])
    rotate([-BarrelLugAngle()*Animate(ANIMATION_STEP_UNLOCK),0,0])
    rotate([BarrelLugAngle()*Animate(ANIMATION_STEP_LOCK),0,0]) {
      translate([ForendX()+ForendSlottedLength()+ForendMidsectionLength(),0,0])
      BarrelLugs();

      color("Black")
      rotate([45+15,0,0])
      rotate([0,90,0])
      DoubleShaftCollar();
    }

    Barrel(hollow=true, barrelLength=barrelLength);
  }

  LuggedForend(alpha=alpha);

  ForendBaseplate();
  translate([ForendFrontMinX(),0,0])
  ForendFront();
  ForendMidsection();
  ForendSlotted(length=ForendSlottedLength()-ManifoldGap(),
                alpha=alpha,
                width=PipeOuterDiameter(pipe=BarrelPipe(), clearance=PipeClearanceLoose()),
                slotAngles=[180], scallopAngles=[90,-90,0]);
}

Liberator12k_PlainFrame(length=12);
Liberator12k_TwistAction();
Liberator12k_Base();
Liberator12k_Stock();
