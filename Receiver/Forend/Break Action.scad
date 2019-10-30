include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../../Components/Cylinder Redux.scad>;
use <../../Components/Pivot.scad>;

use <../Lower/Lower.scad>;

use <../../Shapes/Chamfer.scad>;

use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Lugs.scad>;
use <../Frame.scad>;
use <../Receiver.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "BarrelPivotCollar", "BarrelLatchCollar", "RecoilPlateHousing", "Forend"]

/* [Set Screws] */
BARREL_SET_SCREW = "#8-32"; // ["M4", "#8-32"]
BARREL_SET_SCREW_CLEARANCE = -0.05;

//CHAMBER_OUTSIDE_DIAMETER = 1;
//CHAMBER_INSIDE_DIAMETER = 0.813;


$fs = UnitsFs()*0.5;

// Settings: Vitamins
function BarrelPipe() = Spec_PipeThreeQuarterInch();
function BarrelSleevePipe() = Spec_PipeOneInch();
function ChamberBolt() = Spec_BoltM3();

function BarrelSetScrew() = BoltSpec(BARREL_SET_SCREW);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown BARREL_SET_SCERW?");

// Settings: Lengths
function BarrelLength() = 18;
function BarrelSleeveLength() = 4.5 ;
function WallBarrel() = 0.25;
function WallPivot() = 0.5;

// Shorthand: Measurements
function PivotWidth() = 1.125;
function PivotDiameter() = .25;
function PivotRadius() = PivotDiameter()/2;

function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelSleeveRadius(clearance=undef)
    = PipeOuterRadius(BarrelSleevePipe(), clearance);

function BarrelSleeveDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelSleevePipe(), clearance);


// Calculated: Lengths
function ForendFrontLength() = 1.5;
function ReceiverTopZ() = ReceiverOR();

// Calculated: Positions
function BarrelOffsetZ() = 0; // -0.11 for .22LR rimfire
function ForendMaxX() = FrameUpperBoltExtension();
function ForendMinX() = ForendMaxX()-ForendFrontLength();
function PivotAngle() = -180;
function PivotX() = 5.5;
function PivotZ() = FrameBoltZ()
                  + (FrameUpperBoltRadius()+PivotRadius());

function LatchSpringLength() = 1.25;
function LatchSpringDiameter() = 0.25;
function LatchSpringRadius() = LatchSpringDiameter()/2;
function LatchSpringFloor() = 0.5;
function LatchWall() = 0.125;

function LatchRodY() = 0;
function LatchRodZ() = -1;
function LatchRodDiameter() = 0.25;
function LatchRodRadius() = LatchRodDiameter()/2;
function LatchRodLength() = 2;

function LatchCollarLength() = RecoilPlateRearX()
                             + LatchRodLength()
                             + LatchSpringLength()
                             + LatchSpringFloor();

function ExtractorWidth() = 1/4;
function ExtractorLength() = 1;
function ExtractorWall() = 0.1875;
function ExtractorTravel() = 1;
function ExtractorAngle() = 45;

module ExtractorBit(cutter=false, clearance=0.005) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  rotate([ExtractorAngle(),0,0])
  translate([ExtractorWidth()/8,-0.813/2,0])
  rotate([90,0,25])
  difference() {
    cylinder(r=(ExtractorWidth()/2)+clear, h=ExtractorLength(), $fn=6);

    for (M = [0,1]) mirror([M,0,0])
    hull() for (Z = [0,ExtractorWidth()/2])
    translate([ExtractorWidth()*0.6,0,Z])
    scale([1,1,1.75])
    rotate([90,0,0])
    cylinder(r=ExtractorWidth()/2, h=ExtractorWidth(),
             center=true);
  }
}

module Extractor(alpha=0.5) {
  color("Green", alpha)
  rotate([ExtractorAngle(),0,0])
  render()
  difference() {
    translate([0,0,-((ExtractorWidth()/2)+ExtractorWall())])
    mirror([0,1,0])
    cube([ExtractorWidth()+(ExtractorWall()*2),
           BarrelRadius()+ExtractorLength(),
           ExtractorWidth()+(ExtractorWall()*2)]);

    ExtractorBit(cutter=true);
  }
}

module BreakActionLatchRod(cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Rod
  color("SteelBlue")
  translate([RecoilPlateRearX(), LatchRodY()-(LatchRodRadius()+clear), LatchRodZ()-(LatchRodRadius()+clear)])
  cube([LatchRodLength()+(cutter?LatchSpringLength():0),
        (LatchRodRadius()+clear)*2,
        (LatchRodRadius()+clear)*2]);
}

module BreakActionLatchSpring() {
  color("Silver")
  translate([RecoilPlateRearX()+LatchRodLength(), LatchRodY(), LatchRodZ()])
  rotate([0,90,0])
  cylinder(r=LatchSpringRadius(),
           h=LatchSpringLength());
}

module BreakActionLatch(debug=false, cutter=false, clearance=0.01) {
  clear = cutter?clearance:0;
  clear2 = clear*2;


  // Latch block
  color("Tomato")
  difference() {
    union() {
      translate([-(cutter?0.25:0),LatchRodY()-0.125-clear,LatchRodZ()])
      mirror([0,0,1])
      ChamferedCube([0.75+(cutter?0.5+0.25:0), 0.25+clear2, 1.5], r=1/16);

      translate([0,LatchRodY(),LatchRodZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=(0.7/2)-0.008, r2=1/16,
                         h=1.25);
    }

    LatchScrews(cutter=true, clearance=-0.02);

    BreakActionLatchRod(cutter=true);
  }
}

module LatchScrews(debug=false, cutter=false, clearance=0.008) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("Silver")
  translate([0.375,LatchRodY(),LatchRodZ()])
  rotate([90,0,0])
  cylinder(r=(0.17/2)+clearance, center=true,
           h=LatchSpringDiameter()+(LatchWall()*2));
}

module BreakActionRecoilPlateHousing(debug=false) {
  color("MediumSlateBlue")
  DebugHalf(enabled=debug) render()
  difference() {
    ReceiverFront() {

      // Latch Rod Support
      translate([0,LatchRodY(),LatchRodZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.75, r2=1/16,
                        h=abs(RecoilPlateRearX()),
                        $fn=60);
    }

    BreakActionLatchRod(cutter=true);
  }
}

module BreakActionPivot(factor=0) {
  Pivot2(xyz=[PivotX(),0,PivotZ()],
         angle=[0,PivotAngle(),0],
         factor=factor)
  children();
}


module Barrel(barrel=BarrelPipe(), length=BarrelLength(),
              clearance=PipeClearanceSnug(),
              cutter=false, alpha=1, debug=false) {

  color("Silver") DebugHalf(enabled=!cutter&&debug)
  RenderIf(!cutter)
  translate([0,0,BarrelOffsetZ()])
  rotate([ExtractorAngle(),0,0])
  difference() {
    rotate([0,90,0])
    Pipe(pipe=BarrelSleevePipe(),
         length=BarrelSleeveLength(),
         hollow=!cutter, clearance=clearance);

    if (!cutter)
    translate([0,-0.813*0.5,0])
    rotate(40)
    translate([ExtractorWidth()/4,0.813*0.5*0.1,-ExtractorWidth()/2])
    mirror([1,1,0])
    cube([BarrelDiameter(), BarrelRadius(), ExtractorWidth()]);
  }

  color("SteelBlue", alpha) DebugHalf(enabled=!cutter&&debug) RenderIf(!cutter)
  translate([0,0,BarrelOffsetZ()])
  rotate([ExtractorAngle(),0,0])
  difference() {
    rotate([0,90,0])
    Pipe(pipe=barrel, clearance=clearance,
         hollow=!cutter, length=length);

    if (!cutter)
    translate([0,-0.813*0.5,0])
    rotate(40)
    translate([ExtractorWidth()/4,0.813*0.5*0.1,-ExtractorWidth()/2])
    mirror([1,1,0])
    cube([BarrelDiameter(), BarrelRadius(), ExtractorWidth()]);
  }
}


module BarrelPivotCollar(length=(PivotRadius()+WallPivot())*2, debug=false, alpha=1, cutter=false) {
  echo(length+0.375);

  color("Tomato", alpha) DebugHalf(enabled=!cutter&&debug)
  difference() {
    union() {

      hull() {

        // Around the barrel (flatten the top wall)
        translate([PivotX()+PivotRadius()+WallPivot(), 0, 0])
        intersection() {
          translate([0,0,BarrelOffsetZ()])
          rotate([0,-90,0])
          ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
                   h=length+0.375,
                   $fn=60);

          mirror([1,0,0])
          translate([0,-(BarrelSleeveRadius()+WallBarrel()),
                     -(BarrelSleeveRadius()+WallBarrel())+BarrelOffsetZ()])
          cube([length+0.875,
                (BarrelSleeveRadius()+WallBarrel())*2,
                BarrelSleeveRadius()+BarrelRadius()+(WallBarrel()*2)+abs(BarrelOffsetZ())]);
        }

        // Flat top
        translate([PivotX()+(PivotRadius()+WallPivot()), -PivotWidth()/2, 0])
        mirror([1,0,0])
        ChamferedCube([length+0.375,
                       PivotWidth(),
                       FrameBoltZ()
                         -FrameUpperBoltRadius()
                         -WallFrameUpperBolt()],
                      r=1/16);

        // Set screw support
        translate([PivotX()+(PivotRadius()+WallPivot()), -0.625/2, BarrelOffsetZ()])
        mirror([1,0,0])
        mirror([0,0,1])
        ChamferedCube([length+0.375,
                       0.625,
                       BarrelRadius()+0.5+abs(BarrelOffsetZ())],
                      r=1/16);
      }

      // Pivot support
      hull() {
        translate([PivotX(), -PivotWidth()/2, PivotZ()])
        rotate([-90,0,0])
        ChamferedCylinder(r1=PivotRadius()+WallPivot(), r2=1/16,
                           h=PivotWidth());

        translate([PivotX()-(PivotRadius()+WallPivot()), -PivotWidth()/2, 0])
        ChamferedCube([(PivotRadius()+WallPivot())*2,
                       PivotWidth(),
                       BarrelRadius()+WallBarrel()],
                      r=1/16);
      }
    }

    // Set screw hole
    for (X = [0.25,-0.625])
    translate([PivotX()+X,0,0])
    mirror([0,0,1])
    cylinder(r=1/8/2, h=FrameBoltZ());

    // Pivot hole
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=PivotRadius(), h=3, center=true);

    Barrel(cutter=true);
  }

}

module BarrelLatchCollar(length=LatchCollarLength(),
                         debug=false, alpha=1, cutter=false) {
  color("Tan", alpha) DebugHalf(enabled=!cutter&&debug) render()
  difference() {
    union() {

      // Around the barrel sleeve
      hull() {

        intersection() {
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
                   h=length,
                   $fn=60);

          translate([0,-(BarrelSleeveRadius()+WallBarrel()),
                     -(BarrelSleeveRadius()+WallBarrel())])
          cube([length,
                (BarrelSleeveRadius()+WallBarrel())*2,
                BarrelSleeveRadius()+BarrelRadius()+(WallBarrel()*2)]);
        }

        translate([0, -(BarrelSleeveRadius()), 0])
        ChamferedCube([length,
                       (BarrelSleeveRadius())*2,
                       FrameBoltZ()
                         -FrameUpperBoltRadius()
                         -WallFrameUpperBolt()],
                      r=1/16);
      }

      // Spring support
      color("Silver")
      translate([0, LatchRodY()-(LatchRodRadius()+LatchWall()), LatchRodZ()-(LatchSpringRadius()+LatchWall())])
      ChamferedCube([length,
                     (LatchSpringRadius()+LatchWall())*2,
                     abs(LatchRodZ())],
                     r=1/16);
    }

    // Set screws
    translate([LatchCollarLength()-(LatchSpringFloor()/2),0,0])
    rotate([0,180,0])
    cylinder(r=1/8/2, h=BarrelSleeveDiameter()+WallBarrel());

    // Extractor cutout
    rotate([ExtractorAngle(),0,0])
    translate([0,0,-((ExtractorWidth()/2)+ExtractorWall())])
    mirror([0,1,0])
    cube([ExtractorWidth()+(ExtractorWall()*2)+ExtractorTravel(),
           BarrelRadius()+ExtractorLength(),
           ExtractorWidth()+(ExtractorWall()*2)]);

    Barrel(cutter=true);

    BreakActionLatchRod(cutter=true);

    *BreakActionLatch(cutter=true);

    *hull() for (X = [0,0.5])
    LatchScrews(cutter=true);
  }

}

module BreakActionForend(debug=false, alpha=1) {

  // Forward plate
  color("MediumSlateBlue", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {

      // Pivot support
      hull() {

        translate([ForendMaxX(), 0, 0])
        mirror([1,0,0])
        FrameSupport(length=ForendFrontLength());

        translate([PivotX(), 0, PivotZ()])
        rotate([90,0,0])
        translate([0,0,-FrameBoltY()-FrameUpperBoltRadius()-WallFrameUpperBolt()])
        ChamferedCylinder(r1=0.5, r2=1/16,
                 h=(FrameBoltY()+FrameUpperBoltRadius()+WallFrameUpperBolt())*2,
                 $fn=Resolution(20,60));
      }
    }

    // Pivot slot
    translate([PivotX()-(PivotRadius()+WallPivot()),
                -PivotWidth()/2, 0])
    ChamferedCube([(PivotRadius()+WallPivot())*2,
                   PivotWidth(),
                   FrameBoltZ()+FrameUpperBoltDiameter()+(WallFrameUpperBolt()*2)],
                  r=1/16);

    // Pivot rod
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=PivotRadius()+0.01, h=4, center=true);

    FrameBolts(cutter=true);

    ChargingRod(length=ChargingRodLength(),
                cutter=true);
  }
}

module BreakActionAssembly(receiverLength=12, pipeAlpha=1,
                           pivotFactor=0,
                           stock=true, tailcap=false,
                           debug=false) {


  *BreakActionRecoilPlateHousing();
  *RecoilPlateFiringPinAssembly();
  *RecoilPlate(debug=debug);

  BreakActionLatchRod();

  *ChargingPumpAssembly(debug=debug);

  BreakActionRecoilPlateHousing();

  BreakActionForend(debug=debug);

  // Pivoting barrel assembly
  BreakActionPivot(factor=pivotFactor) {

    %translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=5/16/2, h=3, center=true);

    Barrel(debug=debug);

    ExtractorBit();
    Extractor();

    BarrelPivotCollar(debug=debug);

    *BreakActionLatch(debug=debug);

    BreakActionLatchSpring();

    BarrelLatchCollar(debug=debug);
  }
}

module BreakActionRecoilPlateHousing_print() {
  rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
  BreakActionRecoilPlateHousing();
}

module BarrelPivotCollar_print() {
  rotate([0,90,0])
  translate([-PivotX()-(PivotRadius()+WallPivot()),0,0])
  BarrelPivotCollar();
}

module BarrelLatchCollar_print() {
  rotate([0,90,0])
  translate([-BarrelSleeveLength(),0,0])
  BarrelLatchCollar();
}

module BreakActionForend_print() {
  rotate([0,-90,0])
  translate([-FrameUpperBoltExtension()+ForendFrontLength(),0,-FrameBoltZ()])
  BreakActionForend();
}

scale(25.4) {
  if (_RENDER == "Assembly") {
    BreakActionAssembly(debug=false,
                        pivotFactor=Animate(ANIMATION_STEP_CHARGE)
                                   -Animate(ANIMATION_STEP_CHARGER_RESET));
    PipeUpperAssembly(pipeAlpha=0.5, debug=false,
      triggerAnimationFactor=Animate(ANIMATION_STEP_TRIGGER)
                            -Animate(ANIMATION_STEP_TRIGGER_RESET));

  }

  if (_RENDER == "BarrelPivotCollar")
  BarrelPivotCollar_print();

  if (_RENDER == "BarrelLatchCollar")
  BarrelLatchCollar_print();

  if (_RENDER == "RecoilPlateHousing")
  BreakActionRecoilPlateHousing_print();

  if (_RENDER == "Forend")
  BreakActionForend_print();
}

// Latch
*!scale(25.4) render() rotate([0,-90,0]) translate([0,-LatchRodY(),-LatchRodZ()])
BreakActionLatch();
