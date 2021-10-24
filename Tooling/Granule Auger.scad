use <L12k/Shapes/Teardrop.scad>;
use <L12k/Shapes/Chamfer.scad>;

baseHeight=1;

hopperLength=1;
hopperDepth=2;


augerExtension=1;
augerZ = 0.5;
spigotLength=1;

rotate([-90,0,0])
scale(25.4)
render()
difference() {
  union() {
  
    // Base
    translate([-0.75,-hopperLength,0])
    ChamferedCube([1.5, augerExtension+hopperLength, baseHeight],
                  r=1/16, teardropFlip=[true,true,true]);
  
    // Spigot
    translate([0,-hopperLength+(1/8),0.5])
    rotate([90,0,0])
    ChamferedCylinder(r1=baseHeight/2, r2=1/16, h=spigotLength);
  }
  
  // Auger Hole
  translate([0,hopperLength,augerZ])
  rotate([90,0,0])
  cylinder(r=(0.5/2), h=2+spigotLength, $fn=50);
  
  // Hopper
  #hull() {
    translate([-0.25, 0, augerZ])
    cube([0.5, 0.5, baseHeight-augerZ]);
  
    translate([-0.5, -0.75, baseHeight])
    cube([1, 1.25,  hopperDepth]);
  }
}