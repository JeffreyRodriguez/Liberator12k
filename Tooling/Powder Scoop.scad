module PowderScoop(chargeDiameter=0.6, chargeHeight=3/8, wall=1/32,
                   handleLength=4, handleHeight=1/4, handleWidth=1/8) {
  difference() {
    union() {
      
      // Handle
      translate([0,-handleWidth/2,0])
      cube([handleLength, handleWidth, handleHeight/2]);
      
      // Handle Curve
      translate([0,0,handleHeight/2])
      rotate([0,90,0])
      cylinder(r=handleWidth/2, h=handleLength, $fn=20);
      
      // Scoop Body
      cylinder(r=(chargeDiameter/2) + wall, h=chargeHeight + wall, $fn=20);
    }
    
    translate([0,0,wall])
    cylinder(r=chargeDiameter/2, h=chargeHeight + 0.1, $fn=20);
  }
}

scale([25.4, 25.4, 25.4]) PowderScoop();