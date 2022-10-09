use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Shapes/Chamfer.scad>;

_WALL_FRONT=0.125;
_WALL_BACK=0.5;

function AR15_MagazineRearTabLength() = 0.137;
function AR15_MagazineBaseWidth() = 0.89;
function AR15_MagazineBaseLength() = 2.4;

function AR15_MagCatchZ() = -0.813;
function AR15_MagCatchX() = -0.058;

function AR15_MagwellDepth() = Inches(2.375); //Inches(2);

module AR15_MagwellTemplate(baseWidth=AR15_MagazineBaseWidth(), baseLength=AR15_MagazineBaseLength(),
                       sideTrackOffset=0.825, sideTrackDepth=0.08, centerY=true,
                       widthClearance=0.008, backClearance=0.01,
                       showRearTab=true, showCatch=true) {

  translate([0,centerY ? -(baseWidth/2) : 0,0])
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
                     springOffsetY=-0.125,
                     catchLength=0.265, catchHeight=Inches(0.131),
                     extraY = 0.25, extraRadius=0.02, $fn=8) {

  translate([AR15_MagCatchX(),
             catchOffsetY,AR15_MagCatchZ()]) {

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
             h=Inches(1.26),
           $fn=20);

    // Spring
    translate([0,springOffsetY,0])
    rotate([90,0,0])
    cylinder(r=(0.3125/2)+extraRadius,
             h=Inches(1.26),
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
                          extraTop=0,
                     taperHeight=Inches(0.5),
                          catch=true) {
  union() {
    translate([AR15_MagazineRearTabLength(),0,-height]) {

      // Main magazine cutter
      linear_extrude(height=height+extraTop+ManifoldGap())
      AR15_MagwellTemplate();

      // Magazine tapered opening cutter
      hull() {
				translate([0,0,ManifoldGap()])
				linear_extrude(height=taperHeight+ManifoldGap())
				AR15_MagwellTemplate(showCatch=false, showRearTab=false);
				
				linear_extrude(height=ManifoldGap())
				translate([-0.125,0,0])
				scale([1.5,1.5,1])
				AR15_MagwellTemplate(showCatch=true, showRearTab=true);
			}
    }

    if (catch)
    AR15_MagazineCatch();
  }
}

module AR15_Magwell(width=Inches(1.125),
                  height=AR15_MagwellDepth(),
                    wall=Inches(0.125),
               wallFront=Inches(0),
                wallBack=Inches(0),
                tabWidth=0.5, tabHeight = 1, cut=true) {
                  
  length = AR15_MagazineBaseLength()
         + AR15_MagazineRearTabLength()
         + wallFront;

  color("Orange")
  difference() {
    union() {

      // Magwell body
      mirror([0,0,1])
      linear_extrude(height=height)
      hull() {

        translate([AR15_MagazineRearTabLength()-wallBack, -(width/2)-wall])
        mirror([1,0])
        rotate(90)
        ChamferedSquare([width+(wall*2),
                         length], r=1/8);

        translate([0, -(width/2)])
        mirror([1,0])
        rotate(90)
        ChamferedSquare([width, length + wallFront], r=1/8);
      }
    }

    if (cut)
    AR15_MagwellInsert(height=height);

    // Remove the front bottom corner
    translate([1.25,-1,-height])
    rotate([0,60,0])
    cube([height,2,height*2]);
  }
}

//ScaleToMillimeters() rotate([180,0,0])
*AR15_Magwell(wallFront=_WALL_FRONT, wallBack=_WALL_BACK);
%AR15_MagwellInsert();
