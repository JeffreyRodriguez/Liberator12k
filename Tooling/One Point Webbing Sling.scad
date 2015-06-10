webbing = 28;
gap = 4;
wall = 5;
height = 8;
hole = 6;

%cube([webbing, webbing, gap/2]);

width = (gap*4) + (wall*5); // webbing + (wall*2);
length = webbing + (gap*3) + (wall*6) + (hole*2);

linear_extrude(height=height)
difference() {
  square([width, length]);
  
  // Width Webbing Slots
  translate([width/2 - webbing/2,0]) {
    translate([0, wall])
    square([webbing, gap]);

    translate([0, gap + (wall*2)])
    square([webbing, gap]);

    translate([0, webbing + (gap*2) + (wall*4)])
    square([webbing, gap]);
  }

  // Center Webbing Slots
  translate([0,(gap*2) + (wall*3)])
  for (i = [0:3]) {
    translate([(gap*i) + (wall*(i+1)), 0])
    square([gap, webbing]);
  }

  // String Hole
  translate([width/2,length - hole - wall,0])
  #circle(r=hole);
}
