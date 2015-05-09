include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>

// Firing Pin Extension
module firing_pin_guide(firingPin=RodOneEighthInch, extension=3/8, extension_od=3_4_tee_id, anchor=1/8, anchor_od=0.42, $fn=50) {
  color("Orange")
  difference() {
    union() {
      cylinder(r=extension_od/2, h=extension);
      cylinder(r=anchor_od/2, h=extension + anchor);
    }

    translate([0,0,-0.1])
    Rod(rod=RodOneEighthInch, clearance=RodClearanceLoose, length=extension+anchor+0.2);

    translate([0,0,-0.01])
    cylinder(r1=1/4, r2=lookup(RodRadius, RodOneEighthInch), h=1/8);
  }
}


scale([25.4, 25.4, 25.4])
firing_pin_guide();