include <../Vitamins/Pipe.scad>;
include <Primer.scad>;

function ShellRadius(chamber) = PipeInnerRadius(chamber, lookup(PipeClearanceSnug, chamber));

module ShellBase(chamber=PipeThreeQuartersInch, primer=Primer209,
                 chargeDiameter=0.6, chargeHeight=3/8, wadHeight=4/16,
                 rimHeight=0.1, dummy=false, $fn=50) {
                   
  shellBaseHeight = lookup(PrimerHeight, primer) + chargeHeight + wadHeight;
  echo("ShellBase Height: ", shellBaseHeight);

  difference() {
    union() {

      // Body
      color("Yellow")
      translate([0,0,rimHeight/2])
      cylinder(r=ShellRadius(chamber),
               h=shellBaseHeight - (rimHeight/2));

      // Rim
      color("Blue")
      cylinder(r=PipeOuterRadius(chamber), h=rimHeight);
  
      // Payload
      translate([0,0,lookup(PrimerHeight, primer) + chargeHeight + wadHeight])
      children();
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
}

//scale([25.4, 25.4, 25.4]) ShellBase() {%cylinder(r=ShellRadius(PipeThreeQuartersInch));};