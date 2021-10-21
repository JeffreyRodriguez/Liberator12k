module 2dTri18650(diameter=18.35, distance=(18.35/2)*1.16) {
  radius = (diameter/2);

  for (i = [0:2])
  rotate(360/3*i)
  translate([distance,0])
  circle(r=radius, $fn=35);

  // Central cutout
  circle(r=radius, $fn=35);
}

module Tri18650(length=64.7, floorHeight=2, clearance=0.5, wall=4) {
  union() {

    linear_extrude(height=floorHeight)
    difference() {
      hull()
      offset(r=wall)
      2dTri18650();

      2dTri18650(diameter=5);
    }

    translate([0,0,floorHeight])
    linear_extrude(height=length)
    difference() {
      hull()
      offset(r=wall)
      2dTri18650();

      offset(r=clearance)
      2dTri18650();
    }
  }
}

*for (i=[0:2])
rotate(60+(120*i))
translate([(8+(18.35*0.58))*2,0,0])
Tri18650();

Tri18650();
