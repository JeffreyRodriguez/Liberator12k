use <Lower.scad>;
use <../Meta/Manifold.scad>;

// Middle
scale(25.4)
rotate([90,0,90])
translate([0,0.25,0])
LowerMiddle(bossEnabled=false);

// Left
scale(25.4)
rotate([90,0,0])
translate([3,-0.25,-0.125])
LowerSidePlates(showLeft=true, showRight=false);

// Right
scale(25.4)
rotate([-90,0,0])
translate([3,0.25,-0.125])
LowerSidePlates(showLeft=false, showRight=true);
