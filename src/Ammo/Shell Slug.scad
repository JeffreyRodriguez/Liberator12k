use <Shell Base.scad>;
use <Shell Topper.scad>;
use <Primer.scad>;
use <Fins.scad>;

use <../Vitamins/Pipe.scad>;

module ShellSlug(primer=Spec_Primer209(),
                 chamberDiameter=0.78,
                 height=1.5, taperHeight=0.5,
                 slug_diameter=0.52,
                 fins=false,
                 chargeDiameter=0.68, chargeHeight=0.7, wadHeight=0.25,
                 rimDiameter=0.87, rimHeight=0.09) {

  chamberRadius = chamberDiameter/2;
  rimRadius     = rimDiameter/2;
  chargeRadius  = chargeDiameter/2;

  render()
  ShellBase(primer=primer,
            chamberDiameter=chamberDiameter,
            chargeDiameter=chargeDiameter,
            chargeHeight=chargeHeight, wadHeight=wadHeight,
            rimDiameter=rimDiameter, rimHeight=rimHeight)

    render()
    difference() {
      intersection() {
        ShellTopper(chamberDiameter=chamberDiameter,
                    height=height,
                    taperHeight=taperHeight);

        if (fins)
        Fins(major=chamberRadius,
             minor=0.23,
             width=0.25,
            height=height);
      }

      translate([0,0,height])
      children();
    }

    echo("Shell Top Height: ", height);
}

module ShellSlugBall(height=1.5) {
  render()
  difference() {
    ShellSlug(fins=false, height=height, taperHeight=0.75) {
      for (i = [1])
      translate([0,0,-0.26 - (i*0.5)]) {
        sphere(r=0.275, $fn=20);
        cylinder(r=.24, h=0.5);
      }

      // Flatten the tip
      translate([0,0,-0.5])
      cylinder(r=1, h=1);

      // Internal void for buffering and material savings
      translate([0,0,-1.5])
      cylinder(r=0.25, h=0.375);

    }

    *cube(5);
  }
}

scale(25.4*1.015) // Taulman Bridge shrinkage factor
ShellSlugBall();
