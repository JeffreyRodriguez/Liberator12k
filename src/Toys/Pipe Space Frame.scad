use <L12K/Shapes/Chamfer.scad>;
$fn=60;

module PSF(angle=45) {
  pipeOD = 1.9;
  pipeR = 1.9/2;
  wall = 0.1875;
  chamferRadius = 0.0625;
  cutWidth = 1;
  height = 1*sqrt(2);

  scale(25.4)
  translate([0,0,cutWidth/2])
  rotate([90,0,0])
  intersection() {
    difference() {
      hull() {
        ChamferedCylinder(r1=pipeR+wall, r2=chamferRadius, h=height);
        
        translate([0,0,height])
        rotate([0, angle, 0])
        ChamferedCylinder(r1=pipeR+wall, r2=chamferRadius, h=height, chamferBottom=false);
      }
      
      ChamferedCircularHole(r1=pipeR, r2=chamferRadius, h=height*2, chamferTop=false);
      
      translate([0,0,height])
      rotate([0, angle, 0])
      ChamferedCircularHole(r1=pipeR, r2=chamferRadius, h=height*2, chamferBottom=false);
    }
    
    translate([0,-cutWidth/2,0])
    cube([2, cutWidth, height*2*cos(angle)]);
  }

}

PSF(angle=45);