use <../Components/Teardrop.scad>
use <../Finishing/Chamfer.scad>

module StraightenerPulley(grooveRadius=5/16, od=1.5, $fn=60) {
  difference() {
    cylinder(r=od/2, h=grooveRadius*2);
    
    translate([0,0,grooveRadius])
    #rotate_extrude(angle=360)
    translate([(od/2)+(grooveRadius*sqrt(2)/2),0])
    rotate(90)
    Teardrop(r=grooveRadius, truncated=true);
  }
}
StraightenerPulley();