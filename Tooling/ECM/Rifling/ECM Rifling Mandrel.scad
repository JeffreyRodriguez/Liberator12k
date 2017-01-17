use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Components/T Lug.scad>;
use <../../../Components/Printable Shaft Collar.scad>;

CATHODE_SCREW_SPEC = Spec_BoltM3();
ANODE_SCREW_SPEC = Spec_BoltM3();
PIPE_SPEC = Spec_TubingOnePointOneTwoFive();

BARREL_OD = 1.125+0.025;

BARREL_ID = 0.813+0.015;
BARREL_ID = 0.75+0.008;

BARREL_ID = 0.428;
module ECM_RiflingMandrel(outsideDiameter = BARREL_ID,
                            length = 1,
                         twistRate = 1/12,
                         twistSign = -1,
                       grooveCount = 6,
                       grooveDepth = 0.125,
                       taper=true) {

  outsideRadius = outsideDiameter/2;

  render()
  intersection() {
    linear_extrude(height=length,
                    twist=twistSign*length*twistRate*360,
                   slices=length*10)
    difference() {
      circle(r=outsideRadius, $fn=grooveCount*4);
      
      // Grooves
      for (groove = [0:grooveCount-1])
      rotate(360/(grooveCount)*groove)
      translate([outsideRadius,0])
      scale([1,0.75])
      rotate(45)
      square(grooveDepth, center=true);
    }
    
    // Taper the top
    union() {
      
      if (taper)
      translate([0,0,length-outsideRadius])
      cylinder(r1=outsideRadius+ManifoldGap(),
               r2=outsideRadius/2,
                h=outsideRadius, $fn=50);
      
      cylinder(r=outsideRadius+ManifoldGap(), h=length-outsideRadius+ManifoldGap(), $fn=50);
    }
  }
  
}

!scale(25.4)
ECM_RiflingMandrel(length=1, taper=false, insideDiameter=0);
