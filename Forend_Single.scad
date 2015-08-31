include <Vitamins/Pipe.scad>;
include <Vitamins/Angle Stock.scad>;
include <Components.scad>;
use     <Forend Rail.scad>;

module forend_single(wall=3/16, length=2, $fn=50,
                     receiverTee=receiverTee, barrelPipe=barrelPipe) {

  pipe_diameter    = lookup(PipeOuterDiameter, barrelPipe);
  pipe_radius      = lookup(PipeOuterDiameter, barrelPipe)/2;

  difference() {
    union() {
      render(convexity=2)
      linear_extrude(height=length)
      ForendRail(wall=wall);

      // Barrel Sleeve
      cylinder(r=pipe_radius + wall, h=length);
      cylinder(r=lookup(TeeRimDiameter, receiverTee)/2 + 4/32, h=length);
    }

    // Barrel/Gas-Sealing Pipe Hole
    translate([0,0,-0.1])
    Pipe(pipe=barrelPipe, clearance=PipeClearanceSnug, length=length + 0.2);
  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  forend_single();
}
