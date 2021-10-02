use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <Lower.scad>;

function MagazineAngle() = 8;
function MagazineOffsetX(height=0) = (sin(MagazineAngle())*height);

function MagazineBaseWidth() = 0.55;
function MagazineBaseLength() = 1.38;

// 9mm 1911
module MagwellTemplate(baseWidth=MagazineBaseWidth(), baseLength=MagazineBaseLength(),
                       sideTrackOffset=0.825, sideTrackDepth=0.08, centerY=true,
                       widthClearance=0.004, backClearance=0.008) {
  straightLength = baseLength-(baseWidth/2);

  translate([0,centerY ? -(baseWidth/2) : 0,0])
  render()
  difference() {
    union() {

      // Straight back-section
      translate([-backClearance, -widthClearance])
      square([straightLength+backClearance, baseWidth+(widthClearance*2)]);

      // Curved front-end
      translate([straightLength,baseWidth/2])
      circle(r=(baseWidth/2)+widthClearance, $fn=20);
    }

    for (i = [-widthClearance,baseWidth+widthClearance])
    translate([sideTrackOffset,i])
    rotate(45)
    square([sideTrackDepth,sideTrackDepth], center=true);
  }
}

module MagazineCatch(magHeight=1, catchOffsetZ=-1.15, catchOffsetX=1.04,
                     catchLength=0.265, catchHeight=UnitsImperial(0.131),
                     extraY = 1, extraRadius=0, $fn=8) {

  translate([MagazineOffsetX(magHeight)+catchOffsetX,
             -(MagazineBaseWidth()/2)-extraY,catchOffsetZ]) {
     rotate([0,MagazineAngle(),0])
    *cube([catchLength,0.15+extraY,catchHeight]);

    translate([catchLength/2,0,catchHeight/2])
    rotate([-90,0,0])
    cylinder(r=0.0625+extraRadius, h=0.15+extraY);
  }
}

module MagwellInsert(height=UnitsImperial(1.725), taperHeight=UnitsImperial(0.75)) {
  union() {
    translate([-MagazineOffsetX(height),0,-height])
    multmatrix(m=[[1,0,sin(MagazineAngle()),0], // Here's where the magazine is angled
                  [0,1,0,0],
                  [0,0,1,0],
                  [0,0,0,1]]) {

      // Main magazine cutter
      linear_extrude(height=height+ManifoldGap())
      MagwellTemplate();

      // Magazine tapered opening cutter
      multmatrix(m=[[1,0,sin(MagazineAngle())*2,0], // Here's where the magazine is angled
                   [0,1,0,0],
                   [0,0,1,0],
                   [0,0,0,1]])
      translate([-taperHeight*sin(MagazineAngle()),0,-ManifoldGap()])
      linear_extrude(height=taperHeight+ManifoldGap(), scale=0.7)
      scale([1.2,1.3,1])
      MagwellTemplate(sideTrackDepth=0);
    }

    MagazineCatch(magHeight=height);
  }
}

module Magwell(width=UnitsImperial(1), height=UnitsImperial(1.75),
               wall=UnitsImperial(0.25), wallFront=UnitsImperial(0.5), magOffsetX=0.90,
               tabWidth=0.5, tabHeight = 1) {

  magwellLength = MagazineBaseLength()+MagazineOffsetX(height)+magOffsetX+wallFront;

  color("Orange")
  render()
  difference() {
    translate([(LowerMaxX()+0.25),0,0])
    union() {
      // Magwell body
      mirror([0,0,1])
      linear_extrude(height=height)
      translate([0, -width/2])
      square([magwellLength, width]);

      translate([magOffsetX,0,0])
      *hull() {
        MagazineCatch(magHeight=height, extraRadius=0.4, extraY=wall, $fn=16);
        MagazineCatch(magHeight=height, extraRadius=0.1, extraY=wall+0.25);
      }

      // Beginnings of a slide stop
      *translate([MagazineBaseLength()+MagazineOffsetX(height)-0.25,0,0])
      cube([0.25, 0.25, 0.25]);
    }

    translate([(LowerMaxX()+0.25),0,0])
    translate([magOffsetX,0,0])
    MagwellInsert(height=height);

    GripAccessoryBosses(holes=false, cutter=true);

    GripAccessoryBossBolts(clearance=true);

    translate([magwellLength-0.5,0,0])
    GripAccessoryBossBolts(clearance=true);

  }
}

module PlateMagwell(left=true, right=true) {
  color("Yellow")
  render()
  if (left)
  difference() {
    Magwell();

    translate([0,-ManifoldGap(),ManifoldGap()])
    mirror([0,1,0])
    mirror([0,0,1])
    cube([6,1,2]);
  }

  color("Orange")
  render()
  if (right)
  difference() {
    Magwell();

    translate([0,ManifoldGap(),ManifoldGap()])
    mirror([0,0,1])
    cube([6,1,2]);
  }
}

Magwell();

%Lower();

*!#scale(25.4) {
  translate([0,0.1,0])
  rotate([90,0,0])
  PlateMagwell(left=false, right=true);

  translate([0,-0.1,0])
  rotate([-90,0,0])
  PlateMagwell(left=true, right=false);
}
