include <../..//Vitamins/Pipe.scad>;
include <../../Ammo/Primer.scad>;

module PowderFunnel(socketDiameter=lookup(PipeOuterDiameter, PipeThreeQuarterInch),
                    socketDepth=1/8,
                    primer=Primer209,
                    wall=3/64,
                    $fn=50) {
  height = socketDiameter * 2;

  difference() {

    // Funnel Body
    cylinder(r=(socketDiameter/2) + wall, h=height);

    translate([0,0,height - socketDepth]) {

      // Socket
      cylinder(r=socketDiameter/2, h=socketDepth + 0.1);
    }

    // Funnel
    translate([0,0,-0.001])
    cylinder(r1=socketDiameter/2,
             r2=lookup(PrimerMajorDiameter, primer)/2,
             h=height - socketDepth + 0.002);
  }
}

scale([25.4, 25.4, 25.4]) PowderFunnel();
