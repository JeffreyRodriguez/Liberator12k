include <../Vitamins/Pipe.scad>;
include <../Vitamins/Rod.scad>;
use <../Forend Rail.scad>;
include <../Components.scad>;

module trunnion(receiverTee=TeeThreeQuarterInch, barrelPipe=PipeThreeQuarterInch,
                breechBushing=BushingThreeQuarterInch, trunnionPipe=PipeOneInch,
                latchRod=RodOneQuarterInch,
                trunnionLength=1/2, wall=tee_overlap/2, $fn=40) {
                  
  length = BushingHeight(breechBushing) - BushingDepth(breechBushing)+trunnionLength+TeeRimWidth(receiverTee);
  
  latchRodOffset= TeeRimRadius(receiverTee) +RodRadius(latchRod) +wall/2;
                  
  difference() {
    //hull()
    union() {
      
      // Body
      cylinder(r=TeeRimRadius(receiverTee) + wall, h=length);
      
      translate([-latchRodOffset,0,0])
      cylinder(r=RodRadius(latchRod)+wall, h=length);
      
      render(convexity=2)
      linear_extrude(height=length)
      ForendRail(angles=[180, 50,-50],wall=wall);
    }
    
    translate([0,0,-0.1])
    linear_extrude(height=length+0.2)
    ForendRods(angles=[180, 50,-50], railClearance=RodClearanceSnug);
    
    // Bushing
    translate([0,0,BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiverTee)])
    rotate([0,0,360/6/2])
    mirror([0,0,1])
    Bushing(breechBushing);
    
    // Tee Rim
    translate([0,0,-0.001])
    TeeRim(tee=receiverTee, height=TeeRimWidth(receiverTee));

    // Trunnion Pipe
    translate([0,0,BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiverTee)-0.001])
    Pipe(pipe=trunnionPipe, length=3,clearance=PipeClearanceLoose);
    
    // Latch Rod
    translate([-latchRodOffset,0,-0.1])
    Rod(rod=latchRod, length=length+0.2, clearance=RodClearanceLoose);
  }
  
}

scale([25.4, 25.4, 25.4])
trunnion();
