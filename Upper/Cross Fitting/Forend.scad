//$t=0.8;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Double Shaft Collar.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;
use <../../Reference.scad>;
use <Frame.scad>;
use <Cross Upper.scad>;

module ForendAlignmentLugs(barrelSpec=BarrelPipe(), wall=WallTee(),
                           alignmentSide=0.25, clearance=0) {
  for (i = [0,180,90,270])
  rotate([i,0,0])
  hull()
  //for (r = [15,-15]) rotate([r,0,0])
  rotate([0,0,45])
  translate([-(alignmentSide/2)-clearance,
             -(alignmentSide/2)-clearance,
             PipeOuterRadius(barrelSpec, PipeClearanceLoose())+wall-clearance])
  cube([alignmentSide+(clearance*2),
        alignmentSide+(clearance*2),
        0.45+(clearance*2)]);
}

module Forend(barrelSpec=BarrelPipe(), length=1, wall=WallTee(), wallTee=0.7,
              alignmentLugs=false, alignmentSlots=false,
              clearCeiling=false, clearFloor=false, $fn=40) {
  color("DimGrey")
  render(convexity=4)
  //mirror([1,0,0])
  difference() {
    union() {
      rotate([0,90,0])
      linear_extrude(height=length)
      Quadrail2d(wall=wall, wallTee=wallTee,
                 clearCeiling=clearCeiling, clearFloor=clearFloor);

      if (alignmentLugs)
      translate([length,0,0])
      ForendAlignmentLugs(barrelSpec=barrelSpec, wall=wall);
    }

    if (alignmentSlots)
    ForendAlignmentLugs(barrelSpec=barrelSpec, clearance=0.01, wall=wall);

    Frame();

    translate([-BreechFrontX()-ManifoldGap(),0,0])
    Barrel();
  }
}

module ForendFront() {
  color("DimGrey")
  render()
  difference() {
    union() {
      Forend(length=0.5);

      rotate([0,90,0])
      cylinder(r1=FrameRodOffset()-RodRadius(FrameRod(), RodClearanceLoose()),
               r2=PipeOuterRadius(BarrelPipe())+0.25,
                h=1,
              $fn=PipeFn(BarrelPipe()));
    }

    translate([-BreechFrontX()-ManifoldGap(),0,0])
    Barrel();

    translate([0.23,0,0])
    FrameNuts();
  }
}

module ForendBaseplate(length=0.5) {
  color("DimGrey")
  render()
  difference() {
    hull() {
      Forend(length=ManifoldGap(), clearFloor=true, clearCeiling=true);

      translate([length,0,0])
      Forend(length=ManifoldGap(), clearFloor=true, clearCeiling=false);
    }

    Frame();

    // Larger center hole for the hex plug
    translate([-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=(BushingCapWidth(Spec_BushingThreeQuarterInch())/2)+0.1,
             h=length*2, $fn=30);
  }
}

translate([0,0,-ReceiverCenter()]) {
  Trigger();
  Lower();
}


UpperReceiverFront();
UpperReceiverBack();

translate([ReceiverLugFrontMaxX()+LowerWallFront()+ManifoldGap(),0,0])
ForendFront();

translate([ReceiverLugFrontMaxX(),0,0])
ForendBaseplate();

%Frame();

Reference();


// Plated Forend
*!scale(25.4)
rotate([0,-90,0])
Forend(length=0.375);

// Plated Far Forend
*!scale(25.4)
rotate([0,-90,0])
render()
ForendFront();

// Plated Forend Baseplate
!scale(25.4) rotate([0,90,0]) translate([-LowerWallFront(),0,0])
ForendBaseplate();
