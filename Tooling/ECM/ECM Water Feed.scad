use <../../Meta/Animation.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Components/Teardrop.scad>;
use <../../Components/ORing.scad>;
use <../../Components/Pipe Cap.scad>;
use <../../Components/Hose Barb.scad>;
use <../../Components/Printable Shaft Collar.scad>;


PIPE_SPEC = Spec_TubingZeroPointSevenFive();
//PIPE_SPEC = Spec_TubingOnePointOneTwoFive();
ROD_SPEC = Spec_RodOneQuarterInch();
BOLT_SPEC = Spec_BoltM4();


module ECM_WaterFeed(pipeSpec=PIPE_SPEC, rodSpec=ROD_SPEC, boltSpec=BOLT_SPEC,
                     wall=0.125, extension=0.375,

                     pipeORingSection=1/8,
                     rodORingSection=1/8,

                     barbOffset=0.1875,
                     barbMajorDiameter=0.6,
                     barbMinorDiameter=0.5,
                     barbInnerDiameter=0.25,
                     
                     $fn=40) {

  base2       = barbInnerDiameter+wall;
  base        = wall + rodORingSection + base2;
  inletRadius = barbInnerDiameter/2;

  inletOffset = (PipeOuterRadius(pipeSpec)+wall)
              + (barbMajorDiameter/2) + wall
              + barbOffset;
  render()

  // Main water feed part
  difference() {
    union() {
      intersection() {
        union() {
          PipeCap(pipeSpec=pipeSpec,
                  base=base,
                  oRingSection=pipeORingSection,
                  wall=wall+pipeORingSection,
             extension=ManifoldGap());

        rotate(15)
        PrintableShaftCollar(pipeSpec=pipeSpec,
                             setScrewSpec=boltSpec,
                             screwOffsetZ=base+extension+(wall*2)+pipeORingSection-BoltNutRadius(boltSpec)-wall,
                             height=base+extension+(wall*2)+pipeORingSection,
                             wall=wall+pipeORingSection);
        }

        // Shave off the bottom of the pipe cap
        // that's a lot of material otherwise
        translate([0,0,-ManifoldGap()])
        cylinder(r1=PipeInnerRadius(pipeSpec)+wall,
                  r2=(PipeOuterDiameter(pipeSpec)+wall),
                  h=base+(wall*2)+extension+pipeORingSection+ManifoldGap(2));
      }

      translate([inletOffset,0,base-0.25])
      HoseBarb(barbOuterMajorDiameter=barbMajorDiameter,
               barbOuterMinorDiameter=barbMinorDiameter,
               segments=4);

      // Channel for barb-to-pipe
      translate([0,-inletRadius-wall,0])
      cube([inletOffset+inletRadius+wall,
            barbInnerDiameter+(wall*2),
            base-ManifoldGap()]);
    }

    // Pipe waterway
    translate([0,0,wall])
    cylinder(r1=RodRadius(rodSpec)+(rodORingSection/2),
             r2=PipeInnerRadius(pipeSpec),
             h=base+ManifoldGap(), $fn=20);

    // Inlet for hose barb
    translate([inletOffset,0,wall+rodORingSection+inletRadius])
    cylinder(r=barbInnerDiameter/2, h=base2-inletRadius+ManifoldGap(), $fn=20);

    // Passageway from barb to pipe
    translate([0,0,wall+rodORingSection+inletRadius])
    rotate([0,90,0])
    linear_extrude(height=inletOffset+inletRadius)
    Teardrop(r=barbInnerDiameter/2,
             rotation=180, truncated=true);

    // Rod Guide
    translate([0,0,-ManifoldGap()])
    Rod(rod=rodSpec,
        clearance=RodClearanceLoose(),
        length=base);

    // Rod O-Ring
    translate([0,0,wall+(rodORingSection/2)])
    ORing(innerDiameter=RodDiameter(rodSpec),
                section=rodORingSection);

    // Pipe O-Ring
    translate([0,0,base+(pipeORingSection/2)])
    ORing(innerDiameter=PipeOuterDiameter(pipeSpec),
                section=pipeORingSection);

    // Remove the extra-long tip of the extension
    for (r = [0,45,-45])
    translate([inletOffset+inletRadius+wall+ManifoldGap(),0,wall])
    rotate([r,0,0])
    rotate([0,45,0])
    translate([0,-inletOffset,-inletOffset])
    cube([inletOffset, inletOffset*2, inletOffset*2]);
  }
}

scale(25.4)
//AnimateSpin() render() DebugHalf(dimension=4.1)
ECM_WaterFeed();
