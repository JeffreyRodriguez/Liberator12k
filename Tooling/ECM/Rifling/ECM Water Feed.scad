use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Components/Pipe Cap.scad>;
use <../../../Components/Hose Barb.scad>;

PIPE_SPEC = Spec_TubingOnePointOneTwoFive();
PIPE_SPEC = Spec_TubingZeroPointSevenFive();


module ECM_WaterFeed(pipeSpec=PIPE_SPEC,
                     base1=0.125, base2=0.7,
                     extension=1, wall=0.1875,
                     innerDiameter=0.5,
                     inletDiameter=0.25,
                     oRingSection=0.125*1.2, // Includes crush allowance
                     $fn=40) {
  innerRadius = innerDiameter/2;

  inletOffset = (PipeOuterRadius(pipeSpec)+wall)
              + (innerRadius + wall);
  render()
    
  // Main water feed part
  difference() {
    union() {
      PipeCap(pipeSpec=pipeSpec,
              height=base1+base2+extension,
              base=base1+base2,
              wall=wall);
  
      translate([inletOffset,0,base1+base2-0.25])
      HoseBarb(segments=4);
      
      // Channel for barb-to-pipe
      translate([0,-innerRadius-wall,0])
      cube([inletOffset+innerRadius+wall,
            innerDiameter+(wall*2),
            base1+base2-ManifoldGap()]);
    }
    
    // Pipe waterway
    translate([0,0,base1])
    cylinder(r=PipeInnerRadius(pipeSpec, PipeClearanceLoose()),
             h=base2+ManifoldGap(), $fn=20);
    
    // Inlet for hose barb
    translate([inletOffset,0,base1])
    cylinder(r=inletDiameter/2, h=base2+ManifoldGap(), $fn=20);
    
    // Passageway from barb to pipe
    translate([0,-innerRadius,base1])
    cube([inletOffset+innerRadius, innerDiameter, base2/2]);
    
    // Passageway from barb to pipe (45deg angled "celing" for printing)
    translate([0,0,base1+(base2/2)-innerRadius])
    rotate([45,0,0])
    cube([inletOffset+innerRadius,
          innerDiameter/sqrt(2),
          innerDiameter/sqrt(2)]);
    
    // O-Rings
    for (Z = [wall, wall+oRingSection+wall])
    translate([0,0,base1+base2+Z])
    rotate_extrude(convexity=10, $fn=PipeFn(pipeSpec))
    translate([PipeOuterRadius(pipeSpec),0])
    circle(r=oRingSection/2, $fn=12);
  }
}

scale(25.4)
ECM_WaterFeed();