use <../../Vitamins/Pipe.scad>;

module PipeCone(nutHeight=0.26, nutDiameter=0.6, boltDiameter=0.38, major=2.5, id=0.32) {
  difference() {

    // Body
    cylinder(r1=major/2, r2=boltDiameter*.6, h=(major/2), $fn=50);

    // Nut
    translate([0,0,(major/2) - nutHeight])
    *cylinder(r=nutDiameter/2, h=nutHeight+0.1, $fn=6);

    // Bolt
    translate([0,0,-0.1])
    cylinder(r=boltDiameter/2, h=major, $fn=12);
  }
}

scale([25.4, 25.4, 25.4])
PipeCone();
