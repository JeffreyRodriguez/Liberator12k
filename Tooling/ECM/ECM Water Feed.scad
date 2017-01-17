use <../../Meta/Animation.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Components/Teardrop.scad>;
use <../../Components/ORing.scad>;
use <../../Components/Pipe Cap.scad>;
use <../../Components/Hose Barb.scad>;

PIPE_SPEC = Spec_TubingOnePointOneTwoFive();
ROD_SPEC = Spec_RodOneHalfInch();

PIPE_SPEC = Spec_TubingZeroPointSevenFive();
ROD_SPEC = Spec_RodOneQuarterInch();


module ECM_WaterFeed(pipeSpec=PIPE_SPEC, rodSpec=ROD_SPEC,
                     base1=0.125, wall=0.125, extension=0.125,
                     
                     pipeORingSection=1/8,
                     rodORingSection=1/8,
                     
                     barbOffset=0.125,
                     barbMajorDiameter=0.6,
                     barbMinorDiameter=0.5,
                     barbInnerDiameter=0.25,
                     
                     $fn=40) {
  
  base2       = barbInnerDiameter+wall;
  inletRadius = barbInnerDiameter/2;

  inletOffset = (PipeOuterRadius(pipeSpec)+wall)
              + (barbMajorDiameter/2) + wall
              + barbOffset;
  render()
    
  // Main water feed part
  difference() {
    union() {
      intersection() {
        PipeCap(pipeSpec=pipeSpec,
                base=base1+base2,
                oRingSection=pipeORingSection,
                wall=wall+pipeORingSection,
           extension=extension+(wall*2)+pipeORingSection);
        
        // Shave off the bottom of the pipe cap
        // that's a lot of material otherwise
        translate([0,0,-ManifoldGap()])
        cylinder(r1=PipeInnerRadius(pipeSpec)+wall,
                  r2=(PipeOuterDiameter(pipeSpec)+wall),
                  h=base1+base2+(wall*2)+extension+pipeORingSection+ManifoldGap(2));
      }
  
      translate([inletOffset,0,base1+base2-0.25])
      HoseBarb(barbOuterMajorDiameter=barbMajorDiameter,
               barbOuterMinorDiameter=barbMinorDiameter,
               segments=4);
      
      // Channel for barb-to-pipe
      translate([0,-inletRadius-wall,0])
      cube([inletOffset+inletRadius+wall,
            barbInnerDiameter+(wall*2),
            base1+base2-ManifoldGap()]);
    }
    
    // Pipe waterway
    translate([0,0,base1])
    cylinder(r=PipeInnerRadius(pipeSpec),
             h=base2+ManifoldGap(), $fn=20);
    
    // Inlet for hose barb
    translate([inletOffset,0,base1+inletRadius])
    cylinder(r=barbInnerDiameter/2, h=base2-inletRadius+ManifoldGap(), $fn=20);
    
    // Passageway from barb to pipe
    translate([0,0,base1+inletRadius])
    rotate([0,90,0])
    linear_extrude(height=inletOffset+inletRadius)
    Teardrop(r=barbInnerDiameter/2,
             rotation=180, truncated=true);
    
    // Rod Guide
    translate([0,0,-ManifoldGap()])
    Rod(rod=rodSpec,
        clearance=RodClearanceSnug(),
        length=base1+base2);
        
    // Rod O-Ring
    translate([0,0,base1])
    ORing(innerDiameter=RodDiameter(rodSpec),
                section=rodORingSection);

    // Pipe O-Ring
    translate([0,0,base1+base2+wall+extension])
    ORing(innerDiameter=PipeOuterDiameter(pipeSpec),
                section=pipeORingSection);
    
    // Remove the extra-long tip of the extension
    for (r = [0,45,-45])
    translate([inletOffset+inletRadius+wall+ManifoldGap(),0,base1])
    rotate([r,0,0])
    rotate([0,45,0])
    translate([0,-inletOffset,-inletOffset])
    cube([inletOffset, inletOffset*2, inletOffset*2]);
  }
}

scale(25.4)
//AnimateSpin() render() DebugHalf(dimension=4.1)
ECM_WaterFeed();