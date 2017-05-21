use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;

function MagazineAngle() = 0;

function MagazineBaseWidth() = 0.89;
function MagazineBaseLength() = 2.4;

function AR15_MagCatchZ() = -0.9125;
function AR15_MagCatchX() = -0.20;

module MagwellTemplate(baseWidth=MagazineBaseWidth(), baseLength=MagazineBaseLength(),
                       sideTrackOffset=0.825, sideTrackDepth=0.08, centerY=true,
                       widthClearance=0.008, backClearance=0.01,
                       showRearTab=true, showCatch=true) {

  translate([0,centerY ? -(baseWidth/2) : 0,0])
  render()
  difference() {
    union() {

      // Straight back-section
      translate([-backClearance, -widthClearance])
      square([baseLength+backClearance, baseWidth+(widthClearance*2)]);

      // Rear alignment tab
      if (showRearTab)
      mirror([1,0])
      translate([backClearance,(0.45/2)+widthClearance])
      square([0.137+backClearance, 0.45+(widthClearance*2)]);

      // Magazine Catch Stop
      if (showCatch)
      translate([0.46-backClearance,baseWidth+widthClearance])
      square([0.40+backClearance,0.053]);
    }
  }
}

module MagazineCatch(magHeight=1,
                     catchOffsetY=0.4,
                     catchLength=0.265, catchHeight=UnitsImperial(0.131),
                     extraY = 0.25, extraRadius=0.01, $fn=8) {

  translate([AR15_MagCatchX(),
             catchOffsetY,AR15_MagCatchZ()]) {
     rotate([0,MagazineAngle(),0])

    // Magazine interface
    rotate([-90,0,0])
    hull()
    for (i = [-0.1605,1.111])
    translate([i,0,0])
    cylinder(r=0.123+extraRadius, h=0.15+extraY, $fn=20);

    // Bolt
    translate([0,catchOffsetY,0])
    rotate([90,0,0])
    cylinder(r=(0.186/2)+extraRadius,
             h=UnitsImperial(1.26),
           $fn=12);

    // User Interface
    hull()
    for (i = [-0.097,0.097])
    translate([0,-0.25,i])
    rotate([90,0,0])
    cylinder(r=0.15+extraRadius, h=1.75, $fn=20);
  }
}

*!scale(25.4) translate([-AR15_MagCatchX(), 0, -AR15_MagCatchZ()])
MagazineCatch();

module MagwellInsert(height=UnitsImperial(2.7),
                     taperHeight=UnitsImperial(0.5)) {
  union() {
    translate([0.137,0,-height])
    multmatrix(m=[[1,0,sin(MagazineAngle()),0], // Here's where the magazine is angled
                  [0,1,0,0],
                  [0,0,1,0],
                  [0,0,0,1]]) {

      // Main magazine cutter
      linear_extrude(height=height+ManifoldGap())
      MagwellTemplate();

      // Magazine tapered opening cutter

      multmatrix(m=[[1,0,0,0],
                    [0,1,0,0],
                    [0,0,1,0],
                    [0,0,0,1]])
      translate([0,0,taperHeight-ManifoldGap()])
      mirror([0,0,1])
      hull()
      linear_extrude(height=taperHeight+ManifoldGap(), scale=1.5)
      MagwellTemplate(showCatch=false, showRearTab=false);
    }

    #MagazineCatch();
  }
}

module AR15_Magwell(width=UnitsImperial(1.25),
                   height=UnitsImperial(2.7),
               wall=UnitsImperial(0.125),
              wallFront=UnitsImperial(0.5), magOffsetX=0,
               tabWidth=0.5, tabHeight = 1) {

  magwellLength = MagazineBaseLength()+magOffsetX+wallFront;

  color("Orange")
  render()
  //translate([-magOffsetX,0,0])
  difference() {
    union() {

      // Magwell body
      mirror([0,0,1])
      linear_extrude(height=height)
      hull() {

        translate([magOffsetX, -(width/2)-wall])
        square([MagazineBaseLength(), width+(wall*2)]);

        translate([0, -width/2])
        square([magwellLength, width]);
      }
    }

    translate([magOffsetX,0,0])
    MagwellInsert(height=height);

    // Remove the front bottom corner
    translate([magOffsetX+1.75,-1,-height-0.1])
    rotate([0,45,0])
    cube([height,2,height*2]);

    *translate([0,0,ReceiverCenter()]) {
      GripAccessoryBosses(holes=false, cutter=true);

      GripAccessoryBossBolts(clearance=true);

      translate([magwellLength-0.5,0,0])
      GripAccessoryBossBolts(clearance=true);
    }


  }
}

module PlateMagwell(left=true, right=true) {
  color("Yellow")
  render()
  if (left)
  difference() {
    AR15_Magwell();

    translate([0,-ManifoldGap(),ManifoldGap()])
    mirror([0,1,0])
    mirror([0,0,1])
    cube([6,1,2]);
  }

  color("Orange")
  render()
  if (right)
  difference() {
    AR15_Magwell();

    translate([0,ManifoldGap(),ManifoldGap()])
    mirror([0,0,1])
    cube([6,1,2]);
  }
}

scale(25.4)
rotate([180,0,0])
AR15_Magwell();

translate([0.375,0,0])
//%MagwellInsert();

*!#scale(25.4) {
  translate([0,0.1,0])
  rotate([90,0,0])
  PlateMagwell(left=false, right=true);

  translate([0,-0.1,0])
  rotate([-90,0,0])
  PlateMagwell(left=true, right=false);
}
