use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Cutaway.scad>;
use <../../Shapes/Chamfer.scad>;
use <Lower.scad>;

function MagazineAngle() = 8;
function MagazineOffsetX(height=0) = (sin(MagazineAngle())*height);

function MagazineBaseWidth() = 0.55;
function MagazineBaseLength() = 1.38;
function MagwellOffsetX() = 0.6+0.4;
function MagwellHeight() = UnitsImperial(2+(3/64));
function MagwellLength() = MagazineBaseLength()
                         +MagazineOffsetX(MagwellHeight())
                         +MagwellOffsetX();

// 9mm 1911
module MagwellTemplate(baseWidth=MagazineBaseWidth(), baseLength=MagazineBaseLength(),
                       sideTrackOffset=0.825, sideTrackDepth=0.08, centerY=true,
                       widthClearance=0.01, backClearance=0.01) {
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

module MagazineCatch(magHeight=1, catchOffsetZ=1.15, catchOffsetX=1,
                     catchLength=0.265+0.0625, catchHeight=UnitsImperial(0.131+0.3),
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

module MagwellInsert(height=MagwellHeight(),
                     taperHeight=UnitsImperial(0.75), taper=true) {
  multmatrix(m=[[1,0,sin(MagazineAngle()),0], // Here's where the magazine is angled
                [0,1,0,0],
                [0,0,1,0],
                [0,0,0,1]]) {

    // Main magazine cutter
    linear_extrude(height=height+ManifoldGap())
    MagwellTemplate();

    // Magazine tapered opening cutter
    if (taper)
    multmatrix(m=[[1,0,sin(MagazineAngle())*2,0], // Here's where the magazine is angled
                 [0,1,0,0],
                 [0,0,1,0],
                 [0,0,0,1]])
    translate([-taperHeight*sin(MagazineAngle()),0,-ManifoldGap()])
    linear_extrude(height=taperHeight+ManifoldGap(), scale=0.5)
    scale([1.2,1.3,1])
    MagwellTemplate(sideTrackDepth=0);
  }
}

module Magwell(width=UnitsImperial(1.25), height=MagwellHeight(),
               wall=UnitsImperial(0.25),
               tabWidth=0.5, tabHeight = 1) {

  color("Orange")
  render()
  difference() {
    union() {
      // Magwell body
      mirror([0,0,1])
      translate([0, -width/2,0])
      ChamferedCube([MagwellLength(), width, height], r=0.0625);

      translate([MagwellOffsetX(),0,0])
      *hull() {
        MagazineCatch(magHeight=height, extraRadius=0.4, extraY=wall, $fn=16);
        MagazineCatch(magHeight=height, extraRadius=0.1, extraY=wall+0.25);
      }

      // Beginnings of a slide stop
      *translate([MagazineBaseLength()+MagazineOffsetX(height)-0.25,0,0])
      cube([0.25, 0.25, 0.25]);
    }

    translate([-MagazineOffsetX(height),0,-height])
    translate([MagwellOffsetX(),0,0]) {
      MagwellInsert(height=height+1);

      #MagazineCatch(magHeight=height);
    }


    translate([-LowerMaxX(),0,0])
    LowerMiddleBoss(clearance=0.02);
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

//render() Cutaway()
translate([LowerMaxX(),0,0])
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
