include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Shapes/Components/Cylinder Redux.scad>;
use <../../Shapes/Components/Pivot.scad>;
use <../../Shapes/Components/Pump Grip.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Lugs.scad>;
use <../Frame.scad>;
use <../Receiver.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Action Rod.scad>;

use <Bipod.scad>;


/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "BarrelPivotCollar", "BarrelLatchCollar", "RecoilPlateHousing", "Forend", "Extractor"]

// Cut assembly view in half
_DEBUG_ASSEMBLY = false;

/* [Screws] */
GP_SCREW = "#8-32"; // ["M4", "#8-32"]
GP_SCREW_CLEARANCE = 0.015;

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

function GPScrew() = BoltSpec(GP_SCREW);
assert(GPScrew(), "GPScrew() is undefined. Unknown GP_SCREW?");

// Settings: Lengths
function BarrelLength() = 18;
function BarrelSleeveLength() = 3;
function WallBarrel() = 0.1875;
function WallPivot() = (7/16);
function ExtractorTravel() = 0.5;

// Settings: Positions
function ActionRodZ() = FrameBoltZ()-WallFrameUpperBolt()-(ActionRodWidth()/2);

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
function FiringPinMinX() = -1.5-2;
function BarrelOffsetZ() = 0; // -0.11 for .22LR rimfire
function ForendMaxX() = FrameUpperBoltExtension();
function ForendMinX() = ForendMaxX()-ForendFrontLength();
function PivotAngle() = -30;
function PivotX() = 5.5;
function PivotZ() = FrameBoltZ()
                  + (FrameUpperBoltRadius()+PivotRadius());


function ExtractorAngles() = [90,-90];
function ExtractorWidth() = (1/4);
function ExtractorLength() = 1;
function ExtractorWall() = 0.1875;
function ExtractorTravel() = 1;
function ExtractorGuideLength() = 3;
function ExtractorGuideZ() = -BarrelSleeveRadius()
                             -WallBarrel()
                             -(ActionRodWidth()/2);

function LatchSpringLength() = 1.25;
function LatchSpringDiameter() = 0.25;
function LatchSpringRadius() = LatchSpringDiameter()/2;
function LatchSpringFloor() = 0.25;
function LatchWall() = 0.125;

function LatchRodDiameter() = ActionRodWidth();
function LatchRodRadius() = LatchRodDiameter()/2;
function LatchRodLength() = 4.5;
function LatchRodY() = 0;
function LatchRodZ() = ExtractorGuideZ();
function LatchCollarLength() = 3;

module ExtractorBit(cutter=false, clearance=0.003) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("DimGrey") render()
  for (R = ExtractorAngles()) rotate([R,0,0])
  translate([ExtractorWidth()/8,0,-(11/32)])
  rotate([0,155,0])
  difference() {
    rotate(30)
    cylinder(r=((ExtractorWidth()/2)/cos(30))+clear,
             h=ExtractorLength(), $fn=6);

    if (!cutter)
    for (M = [0,1]) mirror([M,0,0])
    hull() for (Z = [0,ExtractorWidth()/2])
    translate([ExtractorWidth()*0.7,0,Z])
    scale([1,1,1.75])
    rotate([90,0,0])
    cylinder(r=ExtractorWidth()/2,
             h=ExtractorWidth()*(1+cos(30)),
             center=true);
  }
}

module ExtractorScrew(cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Secure the extractor to the guide rod
  color("Silver")
  for (R = ExtractorAngles()) rotate([R,0,0])
  translate([0.5+0.5, 0,ExtractorGuideZ()+(ActionRodWidth()/2)])
  mirror([0,0,1])
  Bolt(bolt=GPScrew(),
       length=0.5+ManifoldGap(), clearance=clear,
       head="flat", capHeightExtra=(cutter?1:0));

  // Actuator pin for the guiderod
  color("Silver")
  for (R = ExtractorAngles()) rotate([R,0,0])
  translate([3.125+0.375, 0,ExtractorGuideZ()+(ActionRodWidth()/2)])
  Bolt(bolt=GPScrew(),
       length=ActionRodWidth()+ManifoldGap(),
       head="socket", capHeightExtra=(cutter?1:0),
        capOrientation=true);
}

module ExtractorGuideRod(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Rod
  color("SteelBlue")
  for (R = ExtractorAngles()) rotate([R,0,0])
  translate([0.625, 0,ExtractorGuideZ()])
  translate([0,-LatchRodRadius()-clear, -(ActionRodWidth()/2)-clear])
  cube([ExtractorGuideLength(),
        (LatchRodRadius()+clear)*2,
        (LatchRodRadius()+clear)*2]);
}

module Extractor(cutter=false, clearance=0.01, alpha=0.5) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Tan", alpha)
  RenderIf(!cutter)
  for (R = ExtractorAngles()) rotate([R,0,0])
  difference() {
    union() {
      
      // Long lower section
      translate([+clear,
                 -(0.625/2)-clear,
                 ExtractorGuideZ()+(ActionRodWidth()/2)+clear])
      mirror([0,0,1])
      ChamferedCube([1.375+clear,
                     0.625+clear2,
                     ActionRodWidth()+0.25+clear2], r=1/16);
      
      // Tall portion to hold the bit
      translate([clear,
                 -(0.625/2)-clear,
                 ExtractorGuideZ()-0.375])
      ChamferedCube([0.625+clear,
                     0.625+clear2,
                     (BarrelRadius()+ExtractorLength())],
                    r=1/16);
    }
    
    if (!cutter) {
      Barrel(cutter=true);

      ExtractorBit(cutter=true);
      
      ExtractorScrew(cutter=true);

      translate([0,0,clearance])
      ExtractorGuideRod(cutter=true);
    }
  }
}

module LatchRod(cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Rod
  color("SteelBlue")
  for (M = [0,1]) mirror([0,M,0])
  translate([RecoilPlateRearX(), LatchRodY()-(LatchRodRadius()+clear), LatchRodZ()-(LatchRodRadius()+clear)])
  cube([LatchRodLength()+(cutter?LatchSpringLength():0),
        (LatchRodRadius()+clear)*2,
        (LatchRodRadius()+clear)*2]);
}

module LatchSpring() {
  *color("Silver")
  for (M = [0,1]) mirror([0,M,0])
  translate([RecoilPlateRearX()+LatchRodLength(), LatchRodY(), LatchRodZ()])
  rotate([0,90,0])
  cylinder(r=LatchSpringRadius(),
           h=LatchSpringLength());
}

module Latch(debug=false, cutter=false, clearance=0.01) {
  clear = cutter?clearance:0;
  clear2 = clear*2;


  // Latch block
  color("Tomato") render()
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

    LatchRod(cutter=true);
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

module BreakActionRecoilPlateHousing(debug=false, alpha=1) {
  color("MediumSlateBlue", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    ReceiverFront() {

      // Latch Rod Support
      *translate([0,LatchRodY(),LatchRodZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.75, r2=1/16,
                        h=abs(RecoilPlateRearX()),
                        $fn=60);
    }
  
    RecoilPlate(cutter=true);

    RecoilPlateFiringPinAssembly(cutter=true);

    translate([RecoilPlateThickness(),0,0])
    ActionRod(cutter=true);

    LatchRod(cutter=true);
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
  difference() {
    rotate([0,90,0])
    union() {
      Pipe(pipe=BarrelSleevePipe(),
           length=BarrelSleeveLength(),
           hollow=!cutter, clearance=(cutter?clearance:undef));
      
      Pipe(pipe=barrel, clearance=(cutter?clearance:undef),
           hollow=!cutter, length=length);
    }

    // Extractor notch
    if (!cutter)
    for (R = ExtractorAngles()) rotate([R,0,0])
    rotate([90,0,0])
    translate([0,-0.813*0.5,0])
    rotate(40)
    translate([ExtractorWidth()/4,0.813*0.5*0.1,-ExtractorWidth()/2])
    mirror([1,1,0])
    cube([BarrelDiameter(), BarrelRadius(), ExtractorWidth()]);
  }
}


module BarrelPivotCollar(length=(PivotRadius()+WallPivot())*2, debug=false, alpha=1, cutter=false) {
  echo(length+0.375);

  color("DarkSlateBlue", alpha) DebugHalf(enabled=!cutter&&debug)
  difference() {
    union() {

      hull() {

        // Around the barrel (flatten the top wall)
        translate([PivotX()+PivotRadius()+WallPivot(), 0, 0])
        intersection() {
          translate([0,0,BarrelOffsetZ()])
          rotate([0,-90,0])
          ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
                   h=length,
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
        ChamferedCube([length,
                       PivotWidth(),
                       FrameBoltZ()
                         -FrameUpperBoltRadius()
                         -WallFrameUpperBolt()],
                      r=1/16);

        // Set screw support
        translate([PivotX()+(PivotRadius()+WallPivot()), -0.625/2, BarrelOffsetZ()])
        mirror([1,0,0])
        mirror([0,0,1])
        ChamferedCube([length,
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

    // Set screws
    for (X = [0.25,-0.25])
    translate([PivotX()+X,0,-BarrelRadius()])
    rotate([0,180,0])
    NutAndBolt(bolt=GPScrew(),
               boltLength=0.5+ManifoldGap(2),
               head="none", nut="heatset",
               teardrop=true,
               clearance=0.005);

    // Pivot hole
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=PivotRadius(), h=3, center=true);

    Barrel(cutter=true);
  }

}

module BarrelLatchCollar(length=LatchCollarLength(),
                         debug=false, alpha=1, cutter=false) {
  color("DarkSlateBlue", alpha)
  DebugHalf(enabled=!cutter&&debug) render()
  difference() {
    union() {

      // Around the barrel sleeve
      hull() {

        rotate([0,90,0])
        ChamferedCylinder(r1=2/2, r2=1/16,
                 h=length,
                 $fn=60);

        // Flat top
        translate([0, -(BarrelSleeveRadius()), 0])
        ChamferedCube([length,
                       (BarrelSleeveRadius())*2,
                       FrameBoltZ()
                         -FrameUpperBoltRadius()
                         -WallFrameUpperBolt()],
                      r=1/16);
      }
      
      // Extractor Support
      for (R = ExtractorAngles()) rotate([R,0,0])
      translate([0,
                 -(LatchRodRadius()+ExtractorWall()),
                 ExtractorGuideZ()-(ExtractorWidth()/2)-ExtractorWall()])
      ChamferedCube([LatchCollarLength(),
                     (LatchRodRadius()+ExtractorWall())*2,
                     BarrelSleeveRadius()+0.5],
                     r=1/16);

      // Latch support
      translate([0, LatchRodY()-(LatchRodRadius()+LatchWall()),
                 LatchRodZ()-(LatchSpringRadius()+LatchWall())])
      ChamferedCube([length,
                     (LatchSpringRadius()+LatchWall())*2,
                     abs(LatchRodZ())],
                     r=1/16);
    }
    
    // Set screws
    for (R = [90,-90]) rotate([R,0,0])
    translate([0.5,0,BarrelSleeveRadius()])
    mirror([1,0,0])
    NutAndBolt(bolt=GPScrew(),
               boltLength=0.5+ManifoldGap(2),
               head="none", nut="heatset",
               teardrop=true,
               clearance=0.005);

    for (X = [0,-0.5]) translate([X,0,0])
    Extractor(cutter=true);
    
    ExtractorGuideRod(cutter=true);

    Barrel(cutter=true);

    LatchRod(cutter=true);

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

    ActionRod(length=12,
                cutter=true);
  }
}

module BreakActionAssembly(receiverLength=12, pipeAlpha=1,
                           pivotFactor=0, extractFactor=0, chargeFactor=0, lockFactor=0,
                           stock=true, tailcap=false,
                           debug=false) {

  BreakActionForend(debug=debug);

  translate([0,0,0]) {
    RecoilPlateFiringPinAssembly();
    RecoilPlate(debug=debug);
    BreakActionRecoilPlateHousing();
  }

  // Pivoting barrel assembly
  BreakActionPivot(factor=pivotFactor) {

    translate([(0.5*lockFactor)-(1.5*chargeFactor),0,0]) {
      translate([8,0,0]) 
      rotate([0,90,0])
      color("Tan") render()
      PumpGrip();
      
    
      translate([0,0,ActionRodZ()])
      ActionRod();
    }
    
    *ChargingPumpAssembly(debug=debug);

    translate([0.5*lockFactor,0,0])
    LatchRod();

    %translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=5/16/2, h=3, center=true);

    Barrel(debug=debug);

    translate([-ExtractorTravel()*extractFactor,0,0]) {
      ExtractorBit();
      ExtractorGuideRod();
      ExtractorScrew();
      Extractor();
    }
    
    BarrelPivotCollar(debug=debug);

    *Latch(debug=debug);

    LatchSpring();

    BarrelLatchCollar(debug=debug, alpha=0.5);
    
    translate([BarrelLength()-1,0,0])
    Bipod();
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
  translate([-LatchCollarLength(),0,0])
  BarrelLatchCollar();
}

module BreakActionForend_print() {
  rotate([0,-90,0])
  translate([-FrameUpperBoltExtension()+ForendFrontLength(),0,-FrameBoltZ()])
  BreakActionForend();
}

module Extractor_print() {
  translate([0,0,-ExtractorGuideZ()+0.625])
  Extractor();
}



if (_RENDER == "Assembly") {
  BreakActionAssembly(debug=_DEBUG_ASSEMBLY,
                      pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -Animate(ANIMATION_STEP_LOAD),
                      chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                 -Animate(ANIMATION_STEP_CHARGER_RESET),
                      lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                 -Animate(ANIMATION_STEP_EXTRACT),
                      extractFactor=Animate(ANIMATION_STEP_EXTRACT)
                                 -Animate(ANIMATION_STEP_LOAD));

  translate([FiringPinMinX(),0,0])
  HammerAssembly(insertRadius=0.75, alpha=0.5,
                 travelFactor=Animate(ANIMATION_STEP_FIRE)
                            - Animate(ANIMATION_STEP_CHARGE));
  
  FrameAssembly(debug=_DEBUG_ASSEMBLY);

  *Charger();
  
  Receiver(pipeAlpha=0.25, buttstockAlpha=1, debug=_DEBUG_ASSEMBLY,
    triggerAnimationFactor=Animate(ANIMATION_STEP_TRIGGER)
                          -Animate(ANIMATION_STEP_TRIGGER_RESET));
}

scale(25.4) {

  if (_RENDER == "BarrelPivotCollar")
  BarrelPivotCollar_print();

  if (_RENDER == "BarrelLatchCollar")
  BarrelLatchCollar_print();

  if (_RENDER == "RecoilPlateHousing")
  BreakActionRecoilPlateHousing_print();

  if (_RENDER == "Forend")
  BreakActionForend_print();

  if (_RENDER == "Extractor")
  Extractor_print();
}

// Latch
*!scale(25.4) render() rotate([0,-90,0]) translate([0,-LatchRodY(),-LatchRodZ()])
Latch();
