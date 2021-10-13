use <../Shell Base.scad>;
use <../Shell Topper.scad>;
use <../Primer.scad>;

use <../../Meta/Cutaway.scad>;
use <../../Vitamins/Pipe.scad>;

DEFAULT_CHAMBER_DIAMETER = 1.08;

module PATBase(primer=Spec_Primer22PAT(),
                 chamberDiameter=DEFAULT_CHAMBER_DIAMETER,
                 height=1.5, taperHeight=0.5,
                 slug_diameter=0.52,
                 chargeHeight=0.25, chargeWall=0.125, wadHeight=0.1875,
                 rimDiameter=1.25, rimHeight=0.1, alpha=1) {


  chargeDiameter = chamberDiameter-chargeWall;
  chargeRadius   = chargeDiameter/2;
  rimRadius      = rimDiameter/2;
  chamberRadius  = chamberDiameter/2;

  color("Tomato", alpha)
  render()
  ShellBase(primer=primer, primerOffset=0,
            chamberDiameter=chamberDiameter,
            chargeDiameter=chargeDiameter,
            chargeHeight=chargeHeight, wadHeight=wadHeight,
            rimDiameter=rimDiameter, rimHeight=rimHeight);
                   
}

module BatonTop(chamberDiameter=DEFAULT_CHAMBER_DIAMETER, height=1.5, alpha=1, $fn=60) {
  chamberRadius  = chamberDiameter/2;

  render()
  union() {
    cylinder(r=chamberRadius, h=height-chamberRadius);
    
    translate([0,0,height-chamberRadius])
    sphere(r=chamberRadius);
  }
}

//!scale(25.4)
Cutaway()
PATBase(alpha=1);
      
// Primer
color("Red")
Primer(primer=Spec_Primer27PAT());

color("Khaki")
translate([0,0,1.29])
Cutaway()
//*!scale(25.4)
BatonTop();
