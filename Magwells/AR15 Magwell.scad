use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;

function MagazineAngle() = 0;

function AR15_MagazineRearTabLength() = 0.137;
function AR15_MagazineBaseWidth() = 0.89;
function AR15_MagazineBaseLength() = 2.4;

function AR15_MagCatchZ() = -0.813;
function AR15_MagCatchX() = -0.058;

function AR15_MagwellDepth() = UnitsImperial(2.6); //UnitsImperial(2);

module AR15_MagwellTemplate(baseWidth=AR15_MagazineBaseWidth(), baseLength=AR15_MagazineBaseLength(),
                       sideTrackOffset=0.825, sideTrackDepth=0.08, centerY=true,
                       widthClearance=0.008, backClearance=0.01,
                       showRearTab=true, showCatch=true) {

  translate([0,centerY ? -(baseWidth/2) : 0,0])
  render()
  difference() {
    union() {

      // Main body section
      translate([AR15_MagazineRearTabLength()-backClearance, -widthClearance])
      square([baseLength+backClearance, baseWidth+(widthClearance*2)]);

      // Rear alignment tab
      if (showRearTab)
      translate([-backClearance,(0.45/2)-widthClearance])
      square([AR15_MagazineRearTabLength()+backClearance, 0.45+(widthClearance*2)]);

      // Magazine Catch Stop
      if (showCatch)
      translate([AR15_MagazineRearTabLength()+0.4-backClearance,baseWidth+widthClearance])
      square([0.55+backClearance,0.053]);
    }
  }
}

module AR15_MagazineCatch(magHeight=1,
                     catchOffsetY=0.4,
                     catchLength=0.265, catchHeight=UnitsImperial(0.131),
                     extraY = 0.25, extraRadius=0.02, $fn=8) {

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
           $fn=20);

    // User Interface
    hull()
    for (i = [-0.097,0.097])
    translate([0,-0.25,i])
    rotate([90,0,0])
    cylinder(r=0.15+extraRadius, h=1.75, $fn=20);
  }
}

module AR15_MagwellInsert(height=AR15_MagwellDepth(),
                     taperHeight=UnitsImperial(0.5)) {
  union() {
    translate([AR15_MagazineRearTabLength(),0,-height])
    multmatrix(m=[[1,0,sin(MagazineAngle()),0], // Here's where the magazine is angled
                  [0,1,0,0],
                  [0,0,1,0],
                  [0,0,0,1]]) {

      // Main magazine cutter
      linear_extrude(height=height+ManifoldGap())
      AR15_MagwellTemplate();

      // Magazine tapered opening cutter
      multmatrix(m=[[1,0,0,0],
                    [0,1,0,0],
                    [0,0,1,0],
                    [0,0,0,1]])
      translate([0,0,taperHeight-ManifoldGap()])
      mirror([0,0,1])
      hull()
      linear_extrude(height=taperHeight+ManifoldGap(), scale=1.5)
      AR15_MagwellTemplate(showCatch=false, showRearTab=false);
    }

    AR15_MagazineCatch();
  }
}

module AR15_Magwell(width=UnitsImperial(1.25),
                  height=AR15_MagwellDepth(),
                    wall=UnitsImperial(0.125),
               wallFront=UnitsImperial(0),
                wallBack=UnitsImperial(0),
                tabWidth=0.5, tabHeight = 1) {

  color("Orange")
  render()
  difference() {
    union() {

      // Magwell body
      mirror([0,0,1])
      linear_extrude(height=height)
      hull() {

        translate([AR15_MagazineRearTabLength()-wallBack, -(width/2)-wall])
        square([AR15_MagazineBaseLength()+AR15_MagazineRearTabLength()+wallBack, width+(wall*2)]);

        translate([0, -(width/2)])
        square([AR15_MagazineBaseLength()+AR15_MagazineRearTabLength()+wallFront, width]);
      }
    }

    AR15_MagwellInsert(height=height);

    // Remove the front bottom corner
    translate([1.25,-1,-height])
    rotate([0,50,0])
    cube([height,2,height*2]);
  }
}

scale(25.4) rotate([180,0,0])
AR15_Magwell();

*%translate([0.375,0,0])
AR15_MagwellInsert();
