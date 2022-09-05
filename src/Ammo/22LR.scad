include <../Vitamins/Pipe.scad>;
include <Shell Base.scad>;

// Uses 5/16" brakeline insert
module insert_22lr(chamberPipe=12GaugeChamber, shellDiameter = 0.34, shellLength=3) {

  difference() {
    ShellBase(chamberPipe=chamberPipe, chargeHeight=0, wadHeight=shellLength - 0.01, primer = PrimerDummy, dummy=true);

    translate([0.1,0,0]) {
      // Shell Body
      translate([0,0,-0.001])
      #cylinder(r=shellDiameter/2, h=shellLength, $fn=16);

      // Primer Base
      //translate([0,0,-0.001])
      //#cylinder(r2=shellDiameter/2, r1=.15, h=0.04, $fn=16);
    }
  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  insert_22lr();
}
