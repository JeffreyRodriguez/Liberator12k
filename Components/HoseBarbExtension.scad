use <../Meta/Manifold.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;
use <Hose Barb.scad>;




module HoseBarbExtension(wall=0.125, heightExtra=0.5,
                     length=2,
                     majorDiameter=0.6,
                     minorDiameter=0.5,
                     innerDiameter=0.25,
                     cutter=false,
                     $fn=40) {

    inletOffset = length;
    majorRadius = majorDiameter/2;
    innerRadius = innerDiameter/2;
    width       = innerDiameter + (wall*2);
    height      = width + heightExtra;

    channelHeight = innerDiameter+(wall*2)+heightExtra;
    channelWidth  = innerDiameter+(wall*2);

    if (cutter == false)
    union() {
      translate([length,0,height-ManifoldGap()])
      HoseBarb(barbOuterMajorDiameter=majorDiameter,
               barbOuterMinorDiameter=minorDiameter,
               barbInnerDiameter=innerDiameter,
               extraBottom=0,
               segments=4);

      hull() {
        // Channel for barb-to-pipe
        translate([0,-innerRadius-wall,0])
        rotate([90,0,90])
        linear_extrude(height=wall)
        ChamferedSquare(xy=[channelWidth, channelHeight],
                        r=wall/4);

        // Rounded tip
        translate([length,0,0])
        ChamferedCylinder(
          r1=max(majorRadius, (channelWidth/2)),
          r2=wall/4, h=channelHeight, $fn=$fn);
      }

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
