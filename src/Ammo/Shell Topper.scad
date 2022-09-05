module ShellTopper(chamberDiameter=0.78,
                   taperDiameter=0.31,
                   height=1.5, taperHeight=0.5) {

  union() {

    // Straight Section
    cylinder(r=chamberDiameter/2, h=height-taperHeight);

    // Tapered Section
    translate([0,0,height-taperHeight])
    cylinder(r1=chamberDiameter/2, r2=taperDiameter/2, h=taperHeight);
  }
}
