include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;
include <Vitamins/Angle Stock.scad>;
include <Components.scad>;
use     <Forend Rail.scad>;

forendLatchRod = RodOneQuarterInch;
forendLatchPipe = PipeOneInch;

module forend_latch(wall=3/16, latchPipeLength=1, $fn=50,
                     receiverTee=Spec_TeeThreeQuarterInch(), barrelPipe=barrelPipe,
                     latchPipe=forendLatchPipe, latchRod=forendLatchRod) {
  length = latchPipeLength+RodDiameter(latchRod);
  pipe_diameter    = lookup(PipeOuterDiameter, forendLatchPipe);
  pipe_radius      = lookup(PipeOuterDiameter, forendLatchPipe)/2;

  // Latch Pipe
  translate([0,0,-0.5])
  %Pipe(pipe=forendLatchPipe, clearance=PipeClearanceSnug, length=latchPipeLength);

  // Barrel Pipe
  translate([0,0,latchPipeLength +0.1])
  *%Pipe(pipe=barrelPipe, clearance=PipeClearanceSnug, length=10);

  // Receiver Tee
  translate([-TeeCenter(receiverTee),0,-(TeeWidth(receiverTee)/2) - 0.5])
  rotate([0,90,0])
  %Tee(receiverTee);

  // Breech Bushing
  translate([0,0,-0.6])
  %cylinder(r=3/8, h=0.6);

  difference() {
    union() {
      render(convexity=2)
      linear_extrude(height=length)
      ForendRail(wall=wall);

      // Latch Pipe Sleeve
      cylinder(r=pipe_radius + wall, h=length);
      cylinder(r=lookup(TeeRimDiameter, receiverTee)/2 + 4/32, h=length);
    }

    // Barrel Pipe
    translate([0,0,-0.1])
    Pipe(pipe=barrelPipe, length=length + 0.2);

    // Latch Pipe Hole
    translate([0,0,-0.1])
    Pipe(pipe=forendLatchPipe, clearance=PipeClearanceSnug, length=length + 0.2);

    // Latch Rod and Slot
    translate([-PipeOuterRadius(barrelPipe),0,latchPipeLength]) {

      // Latch Rod
      translate([-RodRadius(latchRod),0,0])
      rotate([90,0,0])
      #Rod(rod=latchRod, length=3, clearance=RodClearanceSnug, center=true);

      // Latch Slot
      #translate([-2,-RodRadius(latchRod, RodClearanceLoose),0])
      #cube([2, RodDiameter(latchRod, RodClearanceLoose), RodDiameter(latchRod)*4]);
    }


  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  forend_latch();
}
