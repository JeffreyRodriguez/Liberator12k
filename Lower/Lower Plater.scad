use <Lower.scad>;
use <../Meta/Manifold.scad>;

module LowerMiddlePlater() {
  rotate([90,0,90])
  translate([0,0.25,0])
  children();
}


scale(25.4) {
  
  // Trigger Guard Center
  LowerMiddlePlater()
  LowerMiddle();

  // Trigger Guard Sides
  for (i = [1,-1])
  rotate([i*90,0,0])
  translate([3,i* -0.25,-0.125])
  LowerSidePlates(showLeft=i > 0, showRight=i<0);
  
  rotate([-90,0,0])
  translate([-2.75,-0.25-ManifoldGap(),4.5])
  LowerTriggerPocket(cutter=false);
}
