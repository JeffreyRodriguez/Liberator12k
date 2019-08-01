use <../Meta/Manifold.scad>
use <../Shapes/Teardrop.scad>
use <../Finishing/Chamfer.scad>

od=1.5;
gap=1/8;
grooveRadius=3/8;
id=3/32;
wall=3/16;
grooveOffset = grooveRadius*sin(45);
clearance=0.01;

module StraightenerPulley($fn=80) {
  render()
  translate([0,0,-grooveRadius])
  difference() {
    cylinder(r=od/2, h=grooveRadius*2);
    
    translate([0,0,-ManifoldGap()])
    cylinder(r=id/2, h=(grooveRadius*2)+ManifoldGap(2), $fn=10);
    
    translate([0,0,grooveRadius])
    rotate_extrude(angle=360)
    translate([(od/2)+grooveOffset,0])
    rotate(90) {
      circle(r=grooveRadius);
      Teardrop(r=grooveRadius, truncated=false);
    }
  }
}

//StraightenerPulley();


module StraightenerBodySegment() {
  
  translate([grooveRadius+clearance,0,0])
  ChamferedCube([(grooveRadius*2)+wall, od*2, od*4]);
  
}


for (n = [0:2])
translate([0,od/2,n*(od+gap)])
rotate([0,90,0])
StraightenerPulley();

StraightenerBodySegment();