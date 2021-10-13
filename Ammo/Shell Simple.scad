use <Primer.scad>;

use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;

/* [Shell Parameters] */
CHAMBER_LENGTH        = 2.5;
CHAMBER_DIAMETER      = 0.78;
BORE_DIAMETER         = 0.729;
RIM_DIAMETER          = 0.87;
RIM_HEIGHT            = 0.0576;
RIM_TAPER_HEIGHT      = 0.02;
INTERNAL_TAPER_LENGTH = 0.375;

/* [Rendering] */
DEBUG = false;
SNAPCAP = false;

module ShellSimple(primer=Spec_Primer209(), primerOffset=0,
                   chamberRadius=CHAMBER_DIAMETER/2,
                   chamberLength=CHAMBER_LENGTH,
                   boreRadius=BORE_DIAMETER/2,
                   rimRadius=RIM_DIAMETER/2,
                   rimHeight=RIM_HEIGHT,
                   rimTaperHeight=RIM_TAPER_HEIGHT,
                   taperLength=INTERNAL_TAPER_LENGTH,
                   cutters=true,
                   $fn=60) {
  difference() {
    union() {
      
      // Body
      cylinder(r=chamberRadius,
               h=chamberLength);

      // Rim
      cylinder(r=rimRadius, h=rimHeight);

      // Rim Taper
      translate([0,0,rimHeight])
      cylinder(r1=rimRadius, r2=chamberRadius, h=rimTaperHeight);
    }
    
    if (cutters) {
    
      // Payload Cutout
      translate([0,0,PrimerHeight(primer)+taperLength-ManifoldGap()])
      cylinder(r=boreRadius, h=2.75);

      // Charge Pocket Lower Taper
      translate([0,0,PrimerHeight(primer)])
      cylinder(r1=boreRadius*.66,
               r2=boreRadius,
                h=taperLength);
      
      // Charge pocket torus
      translate([0,0,PrimerHeight(primer)])
      TeardropTorus(majorRadius=(boreRadius/2),
                    minorRadius=3/64);
      
      // Primer
      translate([primerOffset,0,0])
      Primer(primer=primer);
    }
  }
}

scale(25.4)
render()
DebugHalf(DEBUG)
ShellSimple(cutters=!SNAPCAP);