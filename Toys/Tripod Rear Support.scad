use <../Meta/Manifold.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Upper/Cross/Reference.scad>;

Receiver();
Stock();
Butt();


module TripodRearSupport(wall=0.1625) {
  
  barWidth = 0.758;
  barHeight = 0.258;
  
  outerRad = PipeOuterRadius(StockPipe());
  outerDia = PipeOuterDiameter(StockPipe());
  
  render()
  translate([-ReceiverLength(),0,0])
  difference() {
    translate([0,
               -outerRad-wall,
               -outerRad-barHeight-wall])
    cube([barWidth+(wall*2),
          outerDia+(wall*2),
          barHeight+wall+(outerRad*1.25)]);
    
    // Through-bar
    translate([wall,
               -outerRad-wall-ManifoldGap(),
               -outerRad-barHeight])
    cube([barWidth, outerDia+(wall*2)+ManifoldGap(2),barHeight]);
    
    translate([ReceiverLength(),0,0])
    Stock(hollow=false, cutter=true);
    
    // Bolt hole
    mirror([0,0,1])
    translate([wall+(barWidth/2),0,0])
    NutAndBolt(cutter=true, teardrop=true);
  }
  
}


!scale(25.4) rotate([0,-90,0]) translate([ReceiverLength(),0,0])
TripodRearSupport();