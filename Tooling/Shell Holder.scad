module ShellHolder(count=4, shellOd=0.79, wall=1/16, height=1/2, base=3/16, width=1.1) {
  linear_extrude(height=height)
  translate([(shellOd/2) + wall,(shellOd/2) + max(base, wall)])
  rotate([0,0,-90])
  difference() {
    for (i = [0:count-1])
    translate([0,width*i,0])
    difference() {
      union() {

        // Shell Holder Body
        circle(r=(shellOd/2) + wall, $fn=30);

        // Base
        translate([(shellOd/2), -(shellOd/2) -wall])
        #square([max(base, wall), width]);

        // Infill
        translate([0,-(shellOd/2) - wall])
        square([shellOd/2, shellOd + (wall*2)]);
      }

      // Cut out the shell hole
      circle(r=shellOd/2, $fn=30);

      // Cut off the edge of the shell hole
      translate([-shellOd*.7,0])
      square([shellOd, shellOd*2], center=true);
    }

    // Cut off the tab of the last holder
    translate([0,(width*(count-1)) + (shellOd/2) + wall,0])
    square([base+1, width+1]);
  }
}

scale([25.4, 25.4, 25.4])
union() {
  ShellHolder(count=3, base=1/8, height=9/16);
  
  mirror([0,1,0])
  ShellHolder(count=3, base=1/8, height=9/16);
}