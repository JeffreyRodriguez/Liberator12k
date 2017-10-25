use <../Vitamins/Rod.scad>;
use <../Finishing/Chamfer.scad>;

module Spindle(pin=Spec_RodOneEighthInch(), center=false,
               radius=0.2, height=0.3,
               $fn=12) {
    difference() {
      ChamferedCylinder(r1=radius, r2=0.05, h=height, center=center);

      if (pin != undef)
      Rod(rod=pin, clearance=RodClearanceLoose(), length=height*3, center=true);
    }
}

Spindle(radius=0.3, $fn=30);