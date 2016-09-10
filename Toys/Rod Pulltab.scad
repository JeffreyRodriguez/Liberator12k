use <../Meta/Manifold.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

module RodPulltab(rodSpec=Spec_RodFiveSixteenthInch(),
                  boltSpec=Spec_BoltM3(),
                  holeRadius=0.5, wall=0.15, $fn=30) {
  height = RodDiameter(rodSpec)+(wall*2)+BoltNutHeight(boltSpec);
  length = holeRadius+BoltNutDiameter(boltSpec)+(wall*2);
  
  render()
  translate([-holeRadius,0,-wall-RodRadius(rod=rodSpec, clearance=RodClearanceLoose())])
  difference() {
    linear_extrude(height)
    difference() {
      hull() {
        
        // Rod-holding section
        intersection() {
          translate([0,-height/2])
          square([length,height]);
          
          rotate(45)
          square(length*sqrt(2)*1.25, center=true);
        }
        
        // Pull tab
        circle(r=holeRadius+wall);
      }
      circle(r=holeRadius);
    }
    
    translate([0,0,RodRadius(rod=rodSpec, clearance=RodClearanceLoose())+wall])
    rotate([0,90,0])
    Rod(rod=rodSpec, clearance=RodClearanceLoose(), length=length+ManifoldGap());
    
    translate([length-BoltNutDiameter(boltSpec),0,height])
    rotate([0,0,90])
    mirror([0,0,1])
    NutAndBolt(boltSpec, boltLength=height+ManifoldGap(2),
               nutHeightExtra=ManifoldGap(), clearance=true);
    
    // Pulltab angle cutter
    translate([-holeRadius-wall-ManifoldGap(),-1,height/2])
    rotate([0,-16,0]) // TODO: Calculate this so we don't hit the nut. and keep nice wide walls.
    cube([2, 2, 2]);
  }
}

scale(25.4)
RodPulltab();