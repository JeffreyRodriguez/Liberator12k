use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Receiver.scad>;



module PipeHousing() {
  render()
  difference() {
      hull() {
        
        // Match the top of the lower-receiver
        linear_extrude(height=ReceiverCenter())
        hull()
        projection(cut=true)
        translate([0,0,ManifoldGap()])
        Lower(showMiddle=false, showTrigger=false);
        
        // Main body
        translate([LowerMaxX(),0,ReceiverCenter()])
        rotate([0,-90,0])
        ChamferedCylinder(
          r1=PipeOuterRadius(StockPipe())+WallLower(),
          r2=0.0625,
          h=LowerMaxX()-ReceiverLugRearMinX()+ReceiverLugRearLength(),
          $fn=50);
      }
      
      ReceiverLugFront(extraTop=ReceiverCenter(), cutter=true);
      ReceiverLugRear(extraTop=ReceiverCenter(), cutter=true);
      SearCutter(searLengthExtra=ReceiverCenter(), teardrop=true);
      
      translate([BreechFrontX(),0,0])
      Stock(hollow=false, cutter=true);
  }
}


translate([-LowerMaxX(),0,0]) {
    color("Yellow") render() DebugHalf()
    PipeHousing();
    
    *Lower(alpha=1,
          showTrigger=true,
          searLength=SearLength()+ReceiverCenter());
    
}


color("SteelBlue") render() DebugHalf()
Receiver();
Barrel(hollow=true);