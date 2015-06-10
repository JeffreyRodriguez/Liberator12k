include <Shell Base.scad>;
include <../Vitamins/Pipe.scad>;

module ShellShot(chamber=PipeThreeQuartersInch, primer=Primer209, wall=3/64) {
  ShellBase(chamber=chamber, primer=primer) {
    radius = PipeInnerRadius(pipe=chamber, clearance=lookup(PipeClearanceLoose, chamber));
    
    color("Orange")
    linear_extrude(height=2) 
    difference() {
      circle(r=radius);
      circle(r=radius - wall);
    }
  }
}

scale([25.4, 25.4, 25.4]) ShellShot();
