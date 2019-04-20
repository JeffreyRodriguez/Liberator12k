use <Primer.scad>;

use <../Finishing/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;

module ShellBase(primer=Spec_Primer209(), primerOffset=0,
                 chamberDiameter=0.78,
                 rimDiameter=0.87, rimHeight=0.07,
                 chargeDiameter=0.69, chargeHeight=0.7,
                 wadHeight=0.3,
                 $fn=60) {
                   
  chamberRadius = chamberDiameter/2;
  rimRadius     = rimDiameter/2;
  chargeRadius  = chargeDiameter/2;
  rimExtra = rimRadius-chamberRadius;

  shellBaseHeight = PrimerHeight(primer) + chargeHeight + wadHeight+(chargeDiameter/2);
  echo("ShellBase Height: ", shellBaseHeight);

  render()
  union() {

    // Base and rim, minus charge pocket and primer hole
    difference() {
      union() {
        
        // Body
        color("Yellow")
        translate([0,0,rimHeight/2])
        cylinder(r=chamberRadius,
                 h=shellBaseHeight - (rimHeight/2));

        // Rim
        color("Blue")
        cylinder(r=rimRadius, h=rimHeight/2);

        // Rim Taper
        cylinder(r1=rimRadius, r2=chamberRadius, h=rimExtra);
      }
      
      // Charge pocket
      hull() {

        // Charge Pocket Lower Taper
        translate([0,0,PrimerHeight(primer)])
        ChamferedCylinder(r1=chargeRadius,
                          r2=chargeRadius/2,
                           h=chargeHeight,
                           teardropBottom=false, chamferTop=false);

        // Charge Pocket Upper Taper
        translate([0,0,PrimerHeight(primer)+chargeHeight])
        cylinder(r1=chargeRadius,
                 r2=chargeRadius/4,
                  h=chargeRadius);
      }
      
      // Primer
      color("Red")
      translate([primerOffset,0,0])
      Primer(primer=primer);
    }

    // Payload
    translate([0,0,shellBaseHeight])
    children();
  }
}

render()
difference() {
  ShellBase()
  %cylinder(r=0.78/2);
  
  cube(4);
}


*!scale([25.4, 25.4, 25.4])
ShellBase(chargeHeight=0, wadHeight=0);