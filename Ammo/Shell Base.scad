include <../Vitamins/Pipe.scad>;
include <Primer.scad>;

function ShellRadius(chamber) = PipeInnerRadius(chamber);

module ShellBase(chamber=12GaugeChamber, primer=Primer22PAT,
                 chargeDiameter=0.6, chargeHeight=3/8, wadHeight=0.5,
                 rimDiameter=0.87, rimHeight=0.07,
                 dummy=false, $fn=50) {

  shellBaseHeight = lookup(PrimerHeight, primer) + chargeHeight + wadHeight;
  echo("ShellBase Height: ", shellBaseHeight);

  union() {

    // Base and rim, minus charge pocket and primer hole
    difference() {
      union() {
        // Body
        color("Yellow")
        translate([0,0,rimHeight/2])
        cylinder(r=ShellRadius(chamber),
                 h=shellBaseHeight - (rimHeight/2));

        // Rim
        color("Blue")
        cylinder(r=rimDiameter/2, h=rimHeight/2);

        // Rim Taper
        translate([0,0,rimHeight/2])
        cylinder(r1=rimDiameter/2, r2=ShellRadius(chamber), h=rimHeight/2);
      }

      if (dummy == false) {

        // Charge Pocket
        color("Green")
        translate([0,0,lookup(PrimerHeight, primer)])
        cylinder(r=chargeDiameter/2, h=chargeHeight);

        // Primer
        color("Red")
        Primer(primer=primer);
      }
    }

    // Payload
    translate([0,0,lookup(PrimerHeight, primer) + chargeHeight + wadHeight])
    children();
  }
}

scale([25.4, 25.4, 25.4])
ShellBase() {
  %cylinder(r=ShellRadius(PipeThreeQuarterInch));
};
