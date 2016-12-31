use <../../Meta/Manifold.scad>;

// Century 1/8" NPT
// tapWidth=0.33, tapHeight=0.4

// Century 1/4" NPT
// tapWidth=0.419, tapHeight=0.423

// Century 3/8" NPT
// tapWidth=0.53, tapHeight=0.49

// Century 1/2" NPT
// tapWidth=0.517, tapHeight=0.65

// Century 3/4" NPT
// tapWidth=0.68, tapHeight=0.675,

// Century 1" NPT
// tapWidth=0.84, tapHeight=0.837,

// Rando amazon AR15 Buffer Tube (this is a bit tall...)
// tapWidth=0.765, tapHeight=1.02
module TapHandle(tapWidth=0.765, tapHeight=0.55, tapWall=0.15,
                 lobeRadius=0.4, lobes=2, lobeOffset=2.5) {
  render()
  difference() {
      union()
      for (i = [0:lobes])
      hull() {
        rotate(360/lobes*i)
        translate([lobeOffset,0,0])
        cylinder(r=lobeRadius, h=tapHeight, $fn=30);

        cylinder(r=tapWidth+tapWall, h=tapHeight, $fn=60);
      }

    translate([-tapWidth/2,-tapWidth/2,-ManifoldGap()])
    cube([tapWidth, tapWidth, tapHeight+ManifoldGap(2)]);
  }
}

scale(25.4)
TapHandle();
