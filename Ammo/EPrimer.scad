use <../Shapes/Chamfer.scad>;

module EPrimer(bodyDiameter=0.31, bodyHeight=0.375,
               rimDiameter=7/16, rimHeight=3/32,
               holeDiameter=0.0625+0.008, $fn=40) {
  
  render()
  difference() {
    union() {
      
      // Body
      ChamferedCylinder(r1=bodyDiameter/2, r2=1/16,
                        h=bodyHeight,
                        chamferBottom=false);
      
      // Body/rim fillet
      translate([0,0,rimHeight])
      HoleChamfer(r1=bodyDiameter/2, r2=1/32, teardrop=false, edgeSign=1);
      
      // Rim
      ChamferedCylinder(r1=rimDiameter/2, r2=1/128, h=rimHeight);
    }
    
    // Hole
    cylinder(r=holeDiameter/2, h=bodyHeight, $fn=12);
    
    // Hole chamfer
    cylinder(r1=holeDiameter, r2=0, h=holeDiameter, $fn=18);
  }
}

scale(25.4)
EPrimer();
