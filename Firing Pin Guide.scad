include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>

// Firing Pin Extension
module firing_pin_guide(firingPinRod=RodOneEighthInch,
                        height=7/16, od=3_4_tee_id,
                        $fn=50) {
  color("Orange")
  render()
  difference() {
    union() {
      cylinder(r=od/2, h=height);
    }

    // Tapered Entrance
    translate([0,0,height/3*2])
    cylinder(r1=lookup(RodRadius, RodOneEighthInch), r2=1/4, h=height/3);

    // Firing Pin Hole
    translate([0,0,-0.1])
    Rod(rod=firingPinRod, clearance=RodClearanceLoose, length=height+0.2, $fn=50);
  }
}


scale([25.4, 25.4, 25.4])
firing_pin_guide();