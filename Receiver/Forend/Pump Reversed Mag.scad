include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;
use <../../Meta/Resolution.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Square Tube.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Frame.scad>;
use <../Lower.scad>;
use <../Receiver.scad>;


BARREL_OUTSIDE_DIAMETER = 1.0001;
BARREL_INSIDE_DIAMETER = 0.813;
BARREL_CLEARANCE = 0.005;
BARREL_LENGTH = 18;
RIM_WIDTH = 0.0301;
RIM_DIAMETER = 0.8875;

function BarrelTravel() = 3;
function BarrelLength() = 18;

function UpperLength() = 6.75;
function MagazineCenterZ() = 1.5;

// Vitamins
module Barrel(od=BARREL_OUTSIDE_DIAMETER, id=BARREL_INSIDE_DIAMETER, length=BarrelLength(), clearance=BARREL_CLEARANCE, cartridgeRimThickness=RIM_WIDTH, cutter=false, alpha=1, debug=false) {

  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([(cutter?0:cartridgeRimThickness),0,0])
  difference() {
    
    rotate([0,90,0])
    cylinder(r=(od/2)+clear, h=length, $fn=60);

    if (!cutter) {
      
      // Hollow inside
      rotate([0,90,0])
      cylinder(r=(id/2)+clear, h=length);
      
      // Extractor notch
      *#rotate([90,0,0])
      translate([0,-0.813*0.5,0])
      rotate(40)
      translate([ExtractorBitWidth()/4,0.813*0.5*0.1,-ExtractorBitWidth()/2])
      mirror([1,1,0])
      cube([BarrelDiameter(), BarrelRadius(), ExtractorBitWidth()]);
    }
  }
}


module PumpRails(length=UpperLength(), cutter=false, clearance=0.002, extraRadius=0) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  *FrameIterator()
  translate([-clear,0,0])
  rotate([0,90,0])
  rotate(180)
  linear_extrude(height=length+clear2)
  Teardrop(r=WallFrameSide()+RodRadius(FrameRod())+extraRadius+clear,
  $fn=Resolution(20,30));
}

module ShellLoadingSupport() {
}

module PumpUpper(cutter=false, clearance=0.002, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Yellow", alpha) DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([-clear,0,0])
      mirror([1,0,0])
      Receiver_Segment(length=UpperLength());

      PumpRails(cutter=cutter);
    }

    hull() {
      *translate([+3-ManifoldGap(),0,0])
      rotate([0,90,0])
      linear_extrude(height=ManifoldGap())
      PumpMagazine2d();

      for (Z = [0,MagazineCenterZ()])
      translate([-ManifoldGap(),0,MagazineCenterZ()-Z])
      rotate([0,90,0])
      cylinder(r=0.813/2,
               h=3+ManifoldGap(),
               $fn=Resolution(12,30));
    }

    if (!cutter)
    hull() for (X = [-ManifoldGap(),BarrelTravel()]) translate([X,0,0])
    Barrel(cutter=true);

    if (!cutter)
    hull() for (X = [-1.5-ManifoldGap(),BarrelTravel()]) translate([X,0,0])
    *BarrelCollar(cutter=true);

    *if (!cutter)
    hull()
    Breech(cutter=true);

    *if (!cutter)
    Frame(cutter=true);
  }
}

module PumpForend(alpha=1, debug=false) {
  ForendWall=0.25;
  ForendLength=BarrelTravel();
  ForendLengthExtra=0;

  color("Green", alpha) DebugHalf(enabled=debug)
  difference() {
    union() {
      hull() {
        translate([ForendLength,0,0])Receiver_Segment(length=ForendLengthExtra);


        *translate([+6.75,0,0])
        rotate([0,90,0])
        linear_extrude(height=ForendLengthExtra)
        offset(r=0.1875)
        PumpMagazine2d(clearance=SquareTubeClearanceSnug());
      }

      hull() {

        rotate([0,90,0])
        intersection() {

          ChamferedCylinder(r1=PipeCapRadius(StockPipe())+ForendWall,
                            r2=0.0625,
                            h=ForendLength+ForendLengthExtra,
                            $fn=Resolution(20,50));

          translate([-ManifoldGap(),
                     -PipeCapRadius(StockPipe())-ForendWall-ManifoldGap(),
                     -ManifoldGap()])
          cube([PipeCapDiameter(StockPipe())+(ForendWall*2)+ManifoldGap(2),
                PipeCapDiameter(StockPipe())+(ForendWall*2)+ManifoldGap(2),
                ForendLength+ForendLengthExtra+ManifoldGap(2)]);
        }

        PumpRails(extraRadius=0.1875, length=ForendLength+ForendLengthExtra);
      }
    }

    translate([-ManifoldGap(),
               -(SquareTubeOuter(MagazineSquareTube(),SquareTubeClearanceLoose())/2)-0.1875,0])
    cube([ForendLength+ManifoldGap(2),
           SquareTubeOuter(MagazineSquareTube(), SquareTubeClearanceLoose())+0.375,
          (PipeCapRadius(StockPipe())*sqrt(2))+0.125]);

    PumpRails(cutter=true);

    translate([+1-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=PipeCapRadius(StockPipe(), clearance=PipeClearanceLoose())+0.01,
                      h=1.5+ManifoldGap(2),
                      $fn=Resolution(20,50));

    translate([-ManifoldGap(),0,0])
    Barrel(cutter=true, clearance=PipeClearanceLoose());

    PumpMagazine(hollow=false, clearance=SquareTubeClearanceLoose());
  }
}


scale(25.4)
if ($preview) {
  ShellLoadingSupport();

  color("Red") {
    for (i = [1:3])
    translate([-3-((i-1)*2.75),0,MagazineCenterZ()])
    rotate([0,90,0])
    ShellSlugBall(height=1.95);

    // Mid-load
    translate([0,0,MagazineCenterZ()])
    rotate([0,90,0])
    ShellSlugBall(height=2.0);


    // In position for load
    rotate([0,90,0])
    ShellSlugBall(height=2.0);
  }

  translate([BarrelTravel()*(Animate(ANIMATION_STEP_UNLOAD)-Animate(ANIMATION_STEP_LOAD)),0,0]) {
    Barrel();
    //BarrelCollar();
    *PumpForend(alpha=1, debug=true);
  }

  PumpUpper(alpha=0.75, debug=false);

  Receiver();
}


$t=0.75;
