use <Lower.scad>;


scale([25.4, 25.4, 25.4]) {
  
  // Trigger Guard Center
  rotate([90,0,90])
  translate([0,0.25,0])
  LowerMiddle();

  // Trigger Guard Sides
  for (i = [1,-1])
  rotate([i*90,0,0])
  translate([3,i* -0.25,-0.125])
  LowerSidePlates(showLeft=i > 0, showRight=i<0);
}
