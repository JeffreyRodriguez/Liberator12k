include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Square Tube.scad>;

use <../Lower/Receiver Lugs.scad>;
use <../Lower/Trigger.scad>;
use <../Lower/Lower.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Frame.scad>;
use <../Receiver.scad>;

function UpperLength() = 6.75;
function MagazineCenterZ() = 1.5;

module PumpRails(length=UpperLength(), cutter=false, clearance=0.002, extraRadius=0) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  FrameIterator()
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
      PipeHousingBase(mainBodyEnabled=false,
                      length=UpperLength()+clear2,
                      magazineLength=BarrelTravel());

      PumpRails(cutter=cutter);
    }

    hull() {
      *translate([+3-ManifoldGap(),0,0])
      rotate([0,90,0])
      linear_extrude(height=ManifoldGap())
      PumpMagazine2d();

      for (Z = [0,MagazineCenterZ()-ReceiverCenter()])
      translate([-ManifoldGap(),0,MagazineCenterZ()-Z])
      rotate([0,90,0])
      cylinder(r=SquareTubeInner(MagazineSquareTube(),
                                 SquareTubeClearanceLoose())/2,
               h=3+ManifoldGap(),
               $fn=Resolution(12,30));
    }

    if (!cutter)
    hull() for (X = [-ManifoldGap(),BarrelTravel()]) translate([X,0,0])
    Barrel(barrelLength=UpperLength(),
           hollow=false, clearance=PipeClearanceLoose());

    if (!cutter)
    hull() for (X = [-1.5-ManifoldGap(),BarrelTravel()]) translate([X,0,0])
    BarrelCollar(cutter=true);

    if (!cutter)
    hull()
    Breech(cutter=true);

    if (!cutter)
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
        translate([+ForendLength,0,0])
        translate([0,0,ReceiverCenter()])
        rotate([0,90,0])
        ChamferedCylinder(r1=PipeCapRadius(StockPipe())+ForendWall,
                          r2=0.0625,
                          h=ForendLengthExtra,
                          $fn=Resolution(20,50));


        *translate([+6.75,0,0])
        rotate([0,90,0])
        linear_extrude(height=ForendLengthExtra)
        offset(r=0.1875)
        PumpMagazine2d(clearance=SquareTubeClearanceSnug());
      }

      hull() {

        translate([0,0,ReceiverCenter()])
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
               -(SquareTubeOuter(MagazineSquareTube(),SquareTubeClearanceLoose())/2)-0.1875,
               ReceiverCenter()])
    cube([ForendLength+ManifoldGap(2),
           SquareTubeOuter(MagazineSquareTube(), SquareTubeClearanceLoose())+0.375,
          (PipeCapRadius(StockPipe())*sqrt(2))+0.125]);

    PumpRails(cutter=true);

    translate([+1-ManifoldGap(),0,ReceiverCenter()])
    rotate([0,90,0])
    cylinder(r=PipeCapRadius(StockPipe(), clearance=PipeClearanceLoose())+0.01,
                      h=1.5+ManifoldGap(2),
                      $fn=Resolution(20,50));

    translate([-ManifoldGap(),0,0])
    Barrel(hollow=false, cutter=true, clearance=PipeClearanceLoose());

    PumpMagazine(hollow=false, clearance=SquareTubeClearanceLoose());
  }
}

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
  translate([0,0,ReceiverCenter()])
  rotate([0,90,0])
  ShellSlugBall(height=2.0);
}

translate([BarrelTravel()*(Animate(ANIMATION_STEP_UNLOAD)-Animate(ANIMATION_STEP_LOAD)),0,0]) {
  Barrel(hollow=true);
  BarrelCollar();
  PumpForend(alpha=1, debug=true);
}

PumpUpper(alpha=0.75, debug=false);

Receiver();


$t=0.75;
