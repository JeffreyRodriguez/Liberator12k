use <L12K/Shapes/Components/Semicircle.scad>;
use <L12K/Meta/Manifold.scad>;
use <L12K/Meta/Units.scad>;
use <L12K/Shapes/Chamfer.scad>;
use <L12K/Vitamins/Nuts And Bolts.scad>;

laserPcbLength = 24;
laserPcbWidth = 14.2;
laserPcbThickness = 1.6;
laserPcbTop = 2;
laserPcbTopInset = 4;
laserPcbBottom = 5;
laserPcbBottomLength = 11;
laserPcbBottomOffsetFront = 6.1;

module LaserPcb() {
  color("Green")
  union() {
    cube([laserPcbLength, laserPcbWidth, laserPcbThickness]);
    
    translate([laserPcbTopInset,0,laserPcbThickness])
    cube([laserPcbLength-(laserPcbTopInset*2), laserPcbWidth, laserPcbTop]);
    
    translate([laserPcbBottomOffsetFront,0,0])
    mirror([0,0,1])
    cube([laserPcbBottomLength, laserPcbWidth, laserPcbTop]);
  }
}

module XL4005Psu() {
}

LaserPcb();