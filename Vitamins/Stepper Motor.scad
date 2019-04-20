module NEMA17(cutter=false) {
  color("DimGrey")
  render()
  scale(1/25.4) {
    
    // Output Shaft
    mirror([0,0,1])
    cylinder(r=5/2, h=25, $fn=16);
    
    // Motor Body
    translate([-21, -21,0])
    cube([42, 42, 42]);
    
    // Center boss
    mirror([0,0,1])
    cylinder(r=(24/2), h=2 + (cutter?25:0), $fn=16);
    
    // Mounting bolts
    for (X = [1,-1]) for (Y=[1,-1])
    translate([X*31/2, Y*31/2, 0])
    mirror([0,0,1])
    cylinder(r=3.5/2, h=15, $fn=10);
    
    // Mounting bolts
    for (X = [1,-1]) for (Y=[1,-1])
    translate([X*31/2, Y*31/2, -12])
    mirror([0,0,1])
    cylinder(r=6/2, h=3+(cutter?12:0), $fn=15);
  }
}

module PlanetaryNEMA17(cutter=false) {
  color("DimGrey")
  render()
  scale(1/25.4) {
    
    // Output Shaft
    mirror([0,0,1])
    cylinder(r=8/2, h=16, $fn=16);
    
    // Motor Body
    translate([-21, -21,38])
    cube([42, 42, 42]);
    
    // Gearbox
    cylinder(r=(36/2), h=38 + (cutter?25:0), $fn=50);
    
    // Center boss
    mirror([0,0,1])
    cylinder(r=(22/2)+1, h=2 + (cutter?25:0), $fn=30);
    
    // Mounting bolts
    for (R = [0:90:360]) rotate(45+R)
    translate([28/2, 0, 0])
    mirror([0,0,1])
    cylinder(r=4/2, h=8+(cutter?10:0), $fn=6);
  }
}
NEMA17();

translate([0,2,0])
PlanetaryNEMA17();