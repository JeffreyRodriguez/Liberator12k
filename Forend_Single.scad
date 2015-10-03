include <Vitamins/Pipe.scad>;
include <Vitamins/Angle Stock.scad>;
include <Components.scad>;
use     <Forend Rail.scad>;

module forend_single(wall=3/16, length=1, $fn=50,
                     receiverTee=receiverTee, barrelPipe=barrelPipe) {

  pipe_diameter    = lookup(PipeOuterDiameter, barrelPipe);
  pipe_radius      = lookup(PipeOuterDiameter, barrelPipe)/2;

  render(convexity=2)
  difference() {
    union() {
      linear_extrude(height=length)
      hull() {
        ForendRail(wall=wall);
        
        circle(r=TeeRimRadius(receiverTee)+wall);
      }
      
      *intersection() {
        translate([0,0,length/2])
        sphere(r=TeeRimRadius(receiverTee) + tee_overlap*2);
        
        translate([-2,-2,0])
        #cube([4,4,length]);
      }
    }

    linear_extrude(height=length) {
      // Barrel/Gas-Sealing Pipe Hole
      translate([0,0,-0.1])
      Pipe2d(pipe=barrelPipe, clearance=PipeClearanceSnug);
      
      ForendRods(clearance=RodClearanceLoose);
    }
  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  forend_single();
}
