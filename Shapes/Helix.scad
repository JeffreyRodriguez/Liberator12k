include<../Meta/Animation.scad>;

use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Shapes/Semicircle.scad>;

RADIUS=1; // [0.1:0.1:2]
TWIST_RATE=1; // [0.1:0.1:2]
ANGLE=22.5; // [0:0.5:360]

module HelixShape2D(radius, depth, cutter_angle, width,
                    twist_rate=1) {
  hull() {
    *semidonut(major=(radius+depth)*2,
              minor=(radius-depth)*2,
              angle=cutter_angle, center=true,
              $fn=50);

    translate([radius-depth,-width/2/twist_rate])
    square([depth*2, width/twist_rate]);
  }
}

module HelixSegment(radius=2, depth=3/16, width=0.25,
                    angle=360, twist_rate=1,
                    top=0.125, bottom=0.125,
                    teardropTop=true, teardropBottom=true) {

  diameter   = radius*2;
  circumf    = PI * diameter;
  segment    = circumf*(angle/360)/twist_rate;
                      
  echo("Helix twist_rate: ", twist_rate);
  echo("Helix radius: ", radius);
  echo("Helix circumference: ", circumf);
  echo("Helix segment: ", segment);
  
  height       = radius/twist_rate;
  twistedWidth = width/twist_rate;
  cutter_angle = 360*(width*sqrt(2)/circumf)*twist_rate;
      
  intersection() {
    union() {
      linear_extrude(height=height,
                     slices=Resolution(30, 50),
                     twist = angle)
      HelixShape2D(radius=radius,
                   depth=depth,
                   cutter_angle=cutter_angle,
                   width=width,
                   twist_rate=twist_rate);

      // Top
      if (top > 0)
      rotate(-angle)
      translate([radius-depth,-twistedWidth/2,height-ManifoldGap()])
      linear_extrude(height=top+ManifoldGap())
      square([depth*2, twistedWidth]);
      
      if (teardropTop)
      rotate(-angle)
      translate([radius-depth,-twistedWidth/2,height+top-ManifoldGap()])
      rotate(90)
      rotate([90,0,0])
      linear_extrude(height=depth*2)
      polygon([[0,0], [twistedWidth,0],
               [(twistedWidth)/2,(twistedWidth/2)*sqrt(2)]]);
      
      // Bottom
      if (bottom > 0)
      translate([radius-depth,-twistedWidth/2,-bottom])
      linear_extrude(height=bottom+ManifoldGap())
      square([depth*2, twistedWidth]);
      
      if (teardropBottom)
      translate([radius-depth,twistedWidth/2,-bottom+ManifoldGap()])
      rotate(-90)
      rotate([-90,0,0])
      linear_extrude(height=depth*2)
      polygon([[0,0], [twistedWidth,0],
               [(twistedWidth)/2,(twistedWidth/2)*sqrt(2)]]);
      
    }
    
    translate([0,0,-bottom-(twistedWidth*sqrt(2)/2)])
    linear_extrude(height=height+bottom+top+(twistedWidth*sqrt(2)))
    hull() {
      
      // Top profile
      rotate(-angle)
      translate([radius-depth,-width/2/twist_rate])
      square([depth*2, twistedWidth]);

      // Bottom profile
      translate([radius-depth,-width/2/twist_rate])
      square([depth*2, twistedWidth]);
    }
  }
}

radius = 0.25+(2*$t);

difference() {
  cylinder(r=radius, h=(radius/TWIST_RATE)+0.5, $fn=50);
  
  translate([0,0,0.25])
  HelixSegment(radius=radius, angle=ANGLE,
               twist_rate=TWIST_RATE,
               top=0, bottom=0,
               teardropTop=true, teardropBottom=true);
}
