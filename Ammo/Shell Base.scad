use <Primer.scad>;

module ShellBase(primer=Spec_Primer209(),
                 chamberDiameter=0.75,
                 rimDiameter=0.87, rimHeight=0.07,
                 chargeDiameter=0.6, chargeHeight=3/8,
                 wadHeight=0.5,
                 $fn=50) {
                   
  chamberRadius = chamberDiameter/2;
  rimRadius     = rimDiameter/2;
  chargeRadius  = chargeDiameter/2;

  shellBaseHeight = PrimerHeight(primer) + chargeHeight + wadHeight;
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
        translate([0,0,rimHeight/2])
        cylinder(r1=rimRadius, r2=chamberRadius, h=rimHeight/2);
      }

      // Charge Pocket
      color("Green")
      translate([0,0,PrimerHeight(primer)])
      cylinder(r=chargeRadius, h=chargeHeight);

      // Primer
      color("Red")
      Primer(primer=primer);
    }

    // Payload
    translate([0,0,shellBaseHeight])
    children();
  }
}

ShellBase()
%cylinder(r=0.78/2);


*!scale([25.4, 25.4, 25.4])
ShellBase(chargeHeight=0, wadHeight=0);