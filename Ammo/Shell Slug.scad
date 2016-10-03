use <Shell Base.scad>;
use <Shell Topper.scad>;
use <Primer.scad>;
use <Fins.scad>;

use <../Vitamins/Pipe.scad>;

module ShellSlug(primer=Spec_Primer209(),
                 chamberDiameter=0.78,
                 height=1.5, taperHeight=0.5,
                 slug_diameter=0.52,
                 chargeDiameter=0.6, chargeHeight=0.25, wadHeight=0.25,
                 rimDiameter=0.87, rimHeight=0.07) {
                   
  chamberRadius = chamberDiameter/2;
  rimRadius     = rimDiameter/2;
  chargeRadius  = chargeDiameter/2;

  ShellBase(primer=primer,
            chamberDiameter=chamberDiameter,
            chargeDiameter=chargeDiameter,
            chargeHeight=chargeHeight, wadHeight=wadHeight,
            rimDiameter=rimDiameter, rimHeight=rimHeight)

    color("Orange")
    render()
    difference() {
      intersection() {
        ShellTopper(taperHeight=taperHeight);
                     
        Fins(major=chamberRadius,
             minor=chamberRadius-0.125,
            height=height);
      }
      
      translate([0,0,height])
      #children();
    }
    
    echo("Shell Top Height: ", height);
}

scale(25.4)
ShellSlug(taperHeight=0.6) {
  translate([0,0,-0.5]) {
    sphere(r=0.26, $fn=20);
    cylinder(r=.26, h=1);
  }
  
  translate([0,0,-0.4])
  cylinder(r=1, h=1);
}
