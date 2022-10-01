use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();


module HoseBarb(barbOuterMajorDiameter=0.6,
                barbOuterMinorDiameter=0.5,
                barbInnerDiameter=0.26,
                barbBottomAngle=60,
                segments=4, segmentSpacing=0.125,
                extraTop=0, extraBottom=0.25) {

  /* FIXME: I know this is wrong.
   * I want barbBottomAngle so I can tweak minimum overhang angle.
   * I haven't bothered to figure out what I'm doing wrong yet.
   * This is 'good enough' for now.
   */
  segmentHeight = tan(barbBottomAngle)
                  * (barbOuterMajorDiameter-barbOuterMinorDiameter);

  height = ((segmentHeight+segmentSpacing)*segments)
         + extraTop
         + extraBottom;

  render()
  difference() {
    union() {

      // Barb minor OD body
      cylinder(r=barbOuterMinorDiameter/2, h=height);

      // Barb segments
      translate ([0,0,extraBottom])
      for (s = [0:segments-1])
      translate ([0,0,(segmentHeight+segmentSpacing)*s])
      hull() {

        // Segment bottom (support)
        cylinder(r1=barbOuterMinorDiameter/2,
                 r2=barbOuterMajorDiameter/2,
                  h=segmentHeight/2);

        // Segment top
        translate([0,0,(segmentHeight/2)])
        cylinder(r1=barbOuterMajorDiameter/2,
                 r2=barbOuterMinorDiameter/2,
                  h=(segmentHeight*0.5)+segmentSpacing);
      }
    }

    // Barb ID
    translate([0,0,-ManifoldGap()])
    cylinder(r=barbInnerDiameter/2,
             h=height+ManifoldGap(2), $fn=10);
  }
}

ScaleToMillimeters()
color("White", 0.5)
HoseBarb();
