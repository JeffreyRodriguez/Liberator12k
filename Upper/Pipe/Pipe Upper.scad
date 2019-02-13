include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Components/Pipe/Cap.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Buttstock.scad>;
use <Frame.scad>;
use <Tailcap.scad>;

function TriggerTravelFactor() = Animate(ANIMATION_STEP_TRIGGER)
                           - Animate(ANIMATION_STEP_TRIGGER_RESET);

module PipeUpperAssembly(receiver=Spec_PipeThreeQuarterInch(),
                         receiverLength=ReceiverLength(),
                         pipeAlpha=1,
                         frameUpper=true, frameLower=true, stock=false, tailcap=false,
                         triggerTravelFactor=TriggerTravelFactor(),
                         debug=true) {

  translate([-receiverLength,0,0]) {
      if (tailcap)
      Tailcap();

      if (stock)
      Buttstock();
  }

  translate([-LowerMaxX(),0,0]) {

    FrameAssembly(upper=frameUpper, lower=frameLower);

    PipeLugAssembly(length=receiverLength,
                    stock=stock, tailcap=tailcap,
                    center=!frameLower, triggerAnimationFactor=triggerTravelFactor,
                    debug=debug, pipeAlpha=pipeAlpha);

  }
}

PipeUpperAssembly(receiverLength=12, stock=true, tailcap=false,
                  debug=false, pipeAlpha=0.25);
