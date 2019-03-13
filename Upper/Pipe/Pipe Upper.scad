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

module PipeUpperAssembly(receiver=Spec_PipeThreeQuarterInch(),
                         receiverLength=ReceiverLength(),
                         pipeOffsetX=FrameExtension(),
                         pipeAlpha=1, centerLug=false,
                         frame=true, lower=true, stock=false, tailcap=false,
                         triggerAnimationFactor=TriggerAnimationFactor(),
                         debug=true) {

  translate([-receiverLength,0,0]) {
      if (tailcap)
      Tailcap(debug=debug);

      if (stock)
      Buttstock(debug=debug);
  }

  translate([-LowerMaxX()-FrameExtension(),0,0]) {

    if (lower)
    translate([0,0,LowerOffsetZ()])
    Lower(showTrigger=true, alpha=1, triggerAnimationFactor=triggerAnimationFactor,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+WallLower()+ReceiverPipeWall()+SearTravel());

    if (frame)
    FrameAssembly(extension=pipeOffsetX);

    PipeLugAssembly(pipeOffsetX=pipeOffsetX, length=receiverLength,
                    center=centerLug,
                    debug=debug, pipeAlpha=pipeAlpha);

  }
}

PipeUpperAssembly(receiverLength=12, stock=true, tailcap=false,
                  debug=false, pipeAlpha=0.25);
