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

// 0.44 Magnum
BARREL_ID = 0.429-0.01;
TWIST_RATE = 1/20;
module ECM_RiflingMandrel(outsideDiameter = BARREL_ID,
                          rodSpec=undef,//Spec_RodOneEighthInch(),
                            length = 1,
                         twistRate = TWIST_RATE,
                         twistSign = -1,
                       grooveCount = 5,
                       grooveDepth = 0.17,
                              taper=true, baseWidth=0.125, base=0.0625) {

  outsideRadius = outsideDiameter/2;

  render()
  union() {
    intersection() {
      linear_extrude(height=length,
                      twist=twistSign*length*twistRate*360,
                     slices=length*10)
      difference() {
        circle(r=outsideRadius, $fn=grooveCount*4);

        if (rodSpec != undef)
        Rod2d(rod=rodSpec, clearance=RodClearanceLoose());

        // Grooves
        for (groove = [0:grooveCount-1])
        rotate(360/(grooveCount)*groove)
        scale([1,0.75])
        translate([outsideRadius,0])
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

    linear_extrude(height=base)
    difference() {
      circle(r=outsideRadius+baseWidth, $fn=grooveCount*4);

      circle(r=outsideRadius-ManifoldGap(), $fn=grooveCount*4);
    }
  }

}

// 0.44 Magnum (Pistol-Length twist rate)
scale(25.4)
ECM_RiflingMandrel(length=5.75-1.25+0.0625, twistRate=1/20, taper=true);


// .22 cal prototype
*!scale(25.4)
ECM_RiflingMandrel(length=2.795-0.65+0.0625, twistRate=1/20, taper=true, grooveDepth=0.1, outsideDiameter = 0.225);
