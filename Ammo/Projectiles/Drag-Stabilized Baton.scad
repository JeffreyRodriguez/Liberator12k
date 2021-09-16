boreDiameter = 0.925*25.4;
baseHeight = 10;

coreDiameter = 7.5;
coreHeight   = 20;
wall = 3;

$fs=0.02;

render()
difference() {
  union() {
    
    // Core
    cylinder(r=(coreDiameter/2)+wall, h=coreHeight+baseHeight);
    
    // Base Taper
    translate([0,0,baseHeight])
    cylinder(r1=boreDiameter/2, h=boreDiameter);
    
    // Base
    cylinder(r=boreDiameter/2, h=baseHeight);
  }
  
  translate([0,0,baseHeight])
  cylinder(r=(coreDiameter/2), h=coreHeight+baseHeight);
  
  // Base Taper
  cylinder(r1=(boreDiameter/2)-wall, h=baseHeight+(coreDiameter*sqrt(2)/2));
}