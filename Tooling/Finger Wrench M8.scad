module Nut(od=0.59) {
  circle(r=od/2, $fn=6);
}

module FingerWrench(od=1.2, id=0.75, height=0.26, length=2, open=true, $fn=30) {
  linear_extrude(height=height)
  difference() {
    hull() {
      circle(r=od/2);
      
      translate([length,0])
      circle(r=od/2);
    }
    
    translate([length,0])
    circle(r=id/2);
    
    translate([-1-(id*0.19), -od/2])
    #square([1,od]);
    
    Nut();
  }
}

FingerWrench();
