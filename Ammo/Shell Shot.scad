use <Shell Base.scad>;
use <Shell Topper.scad>;
use <Primer.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;

module ShellShot(primer=Spec_Primer209(),
                 chamberDiameter=0.78,
                 height=1.5, taperHeight=0.5,
                 slug_diameter=0.52,
                 fins=false, wall=3/64,
                 chargeDiameter=0.68, chargeHeight=0.7, wadHeight=0.25,
                 rimDiameter=0.87, rimHeight=0.09) {
                   
  chamberRadius = chamberDiameter/2;
  rimRadius     = rimDiameter/2;
  chargeRadius  = chargeDiameter/2;

  shellBaseHeight = PrimerHeight(primer) + chargeHeight + wadHeight;

  difference() {
    union() {
      echo("ShellBase Height: ", shellBaseHeight);
      ShellBase(primer=primer,
                chamberDiameter=chamberDiameter,
                chargeDiameter=chargeDiameter,
                chargeHeight=chargeHeight, wadHeight=wadHeight,
                rimDiameter=rimDiameter, rimHeight=rimHeight)
        
      color("Orange")
      ShellTopper(chamberDiameter=chamberDiameter,
                  height=height,
                  taperHeight=0);
    }
    
    translate([0,0,shellBaseHeight])
    cylinder(r=(chamberRadius)-wall, h=height+ManifoldGap(), $fn=40);
  }
}

scale([25.4, 25.4, 25.4])
//DebugHalf()
ShellShot();
