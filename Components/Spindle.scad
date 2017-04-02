use <../Vitamins/Rod.scad>;

module Spindle(pin=Spec_RodOneEighthInch(), center=false,
               radius=0.2, height=0.26,
               $fn=12) {
    difference() {
      cylinder(r=radius, h=height, center=center);

      if (pin != undef)
      Rod(rod=pin, clearance=RodClearanceLoose(), length=height*3, center=true);
    }
}

Spindle();