include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Components/Firing Pin.scad>;

use <../../Components/Pipe/Cap.scad>;
use <../../Components/Pipe/Charging Handle.scad>;
use <../../Components/Pipe/Lugs.scad>;
use <../../Components/Pipe/Frame.scad>;
use <../../Components/Pipe/Tailcap.scad>;
use <../../Components/Pipe/Buttstock.scad>;
use <../../Components/Pipe/Linear Hammer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

module PipeUpperAssembly(receiver=Spec_PipeThreeQuarterInch(),
                         receiverLength=ReceiverLength(),
                         pipeAlpha=1,
                         chargingHandle=true, frame=true, stock=false, tailcap=false,
                         debug=true) {
                   
  translate([-LowerMaxX(),0,0]) {
    PipeLugAssembly(length=receiverLength,
                    stock=stock, tailcap=tailcap,
                    center=false,
                    debug=debug);
    
    if (frame)
    FrameAssembly();
    
  }
               
  translate([-receiverLength,0,0]) {
      if (tailcap)
      Tailcap();
  
      if (stock)
      Buttstock();
  }
  
  if (chargingHandle) {
    ChargingHandle();
    ChargingHandleHousing();
  }
}

PipeUpperAssembly(receiverLength=12, stock=true, tailcap=false,
                  debug=true);