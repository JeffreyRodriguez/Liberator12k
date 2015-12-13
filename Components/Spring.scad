use <Semicircle.scad>;

module SpringFlat2d(segmentLength=2.25, segmentWidth=0.06,
                         segments=5, angle=15, infill=1) {

  opposite = sin(angle) * segmentLength;
  adjacent = cos(angle) * segmentLength;
  spacing = opposite*2;

  render()
  union() {

    // Spring
    for(i = [0:segments-1]) {

      // Main Section
      translate([ceil(i/2) * spacing,0,0])
      rotate([0,0,(i % 2 == 0 ? -1 : 1) * angle])
      translate([-segmentWidth/2,0])
      square([segmentWidth, segmentLength]);

      // Strain Relief
      if (i != 0)
      translate([i * opposite,(i%2 == 0) ? 0 : adjacent,0])
      rotate([0,0,(i%2==0) ? 90 : -90])
      difference() {
        rotate([0,0,angle])
        semicircle(angle=angle*2, od=infill*2);

        translate([segmentWidth*3,0])
        rotate([0,0,angle*1.5])
        semicircle(angle=angle*3, od=infill*2);
      };
    }

    // Origin Print Adhesion Anchor
    translate([segmentWidth,segmentWidth*2,0])
    *circle(r=segmentWidth*2, $fn=36);

    // Final Segment Print Adhesion Anchor
    translate([(opposite * segments),adjacent -(segmentWidth*2),0])
    *circle(r=segmentWidth*2, $fn=36);
  }
}

SpringFlat2d(segments=3);
