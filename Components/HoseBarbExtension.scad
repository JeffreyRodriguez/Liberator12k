use <../Meta/Manifold.scad>;
use <Teardrop.scad>;
use <Hose Barb.scad>;




module HoseBarbExtension(wall=0.125, heightExtra=0.5,
                     length=2,
                     majorDiameter=0.6,
                     minorDiameter=0.5,
                     innerDiameter=0.25,
                     cutter=false) {

    inletOffset = length;
    innerRadius = innerDiameter/2;
    width       = innerDiameter + (wall*2);
    height      = width + heightExtra;

    if (cutter == false)
    difference() {
      union() {
        translate([length,0,height-ManifoldGap()])
        HoseBarb(barbOuterMajorDiameter=majorDiameter,
                 barbOuterMinorDiameter=minorDiameter,
                 barbInnerDiameter=innerDiameter,
                 extraBottom=0,
                 segments=4);

        // Channel for barb-to-pipe
        translate([0,-innerRadius-wall,0])
        cube([length+innerRadius+wall,
              innerDiameter+(wall*2),
              innerDiameter+(wall*2)+heightExtra]);
      }


      // Remove the extra-long tip of the extension
      for (r = [0,45,-45])
      translate([length+innerRadius+wall+ManifoldGap(),0,wall])
      rotate([r,0,0])
      rotate([0,45,0])
      translate([0,-length,-length])
      cube([length, length*2, length*2]);
    }

    if (cutter == true)
    union() {

      // Inlet for hose barb
      translate([length,0,height-innerRadius-wall])
      cylinder(r=innerDiameter/2, h=length+ManifoldGap(), $fn=20);

      // Passageway from barb to pipe
      translate([-ManifoldGap(),0,height-innerRadius-wall])
      rotate([0,90,0])
      linear_extrude(height=length+innerRadius)
      Teardrop(r=innerRadius,
        rotation=180,
       truncated=true);
    }
}


scale(25.4)
render() {

  %HoseBarbExtension(cutter=true);

  difference() {
    color("White", 0.5)
    HoseBarbExtension();

    HoseBarbExtension(cutter=true);
  }
}
