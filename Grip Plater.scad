use <Trigger Guard.scad>;
use <Reference.scad>;

safetyCutout=false;
resetCutout=false;


scale([25.4, 25.4, 25.4]) {
  // Trigger Guard Center
  color("CornflowerBlue")
  render()
  rotate([-90,0,-0])
  translate([-2,-0.25/2,0])
  GripMiddle(safetyCutout=safetyCutout, resetCutout=resetCutout);

  // Trigger Guard Sides
  color("Khaki")
  render()
  for (i = [true,false])
  rotate([(i?1:-1)* 90,0,0])
  translate([3,(i?1:-1)* -0.125,0])
  GripSides(showLeft=i, showRight=!i);
}