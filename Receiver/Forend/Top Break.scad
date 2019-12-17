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
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Lugs.scad>;
use <../Frame.scad>;
use <../Receiver.scad>;
use <../Recoil Plate.scad>;
use <../Compact Linear Hammer.scad>;
use <../Action Rod.scad>;

use <Bipod.scad>;


/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "BarrelLatchCollar", "RecoilPlateHousing", "Forend", "Foregrip", "Extractor", "Latch"]

// Cut assembly view in half
_DEBUG_ASSEMBLY = false;

/* [Screws] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

SUPPORT_BOLT ="1/4\"-20"; // ["1/4\"-20", "1/2\"-13"]

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

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function SupportBolt() = BoltSpec(SUPPORT_BOLT);
assert(SupportBolt(), "SupportBolt() is undefined. Unknown SUPPORT_BOLT?");



// Settings: Dimensions
function BarrelLength() = 18;
function BarrelSleeveLength() = 3;
function WallBarrel() = 0.1875;

function FrameBoltLength() = 10;

function WallPivot() = 0.5;
function PivotAngleBack() = -15;
function PivotAngle() = 35;
function PivotX() = 4.5;
function PivotZ() = -1.3125;// (FrameBoltZ() + (FrameBoltRadius()+PivotRadius()));
function PivotWidth() = 1.375;
function PivotRadius() = 0.625;
function PivotDiameter() = PivotRadius()*2;
function PivotClearance() = 0.01;

function ActionRodLength() = 10;
function LatchSpringLength() = 2.5+3;
function LatchSpringDiameter() = 0.625;

function ReceiverFrontLength() = 1;
function ForendLength() = FrameExtension(length=FrameBoltLength())
                        -ReceiverFrontLength()-0.5;
function ChargerTravel() = 1.125;
function LatchCollarLength() = 5.5;//ForendLength();



// Calculated: Dimensions
function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelSleeveRadius(clearance=undef)
    = PipeOuterRadius(BarrelSleevePipe(), clearance);

function BarrelSleeveDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelSleevePipe(), clearance);
    
function LatchSpringRadius() = LatchSpringDiameter()/2;
function LatchSupportWidth() = (LatchSpringRadius()+LatchWall())*2;


// Calculated: Lengths
function ForegripOffsetX() = 6+ChargerTravel();
function ForegripLength() = 4.625;

// Calculated: Positions
function ActionRodZ() = FrameBoltZ()-WallFrameBolt()-(ActionRodWidth()/2);
function BarrelOffsetZ() = 0; // -0.11 for .22LR rimfire

function ExtractorWidth() = (1/4);
function ExtractorLength() = 1;
function ExtractorWall() = 0.1875;
function ExtractorTravel() = 0.5;
function ExtractorGuideLength() = 3;
function ExtractorGuideZ() = -BarrelSleeveRadius()
                             -WallBarrel()
                             -(ActionRodWidth()/2);

function LatchX() = -0.25;
function LatchZ() = ActionRodZ();
function LatchLength() = 0.75+ChargerTravel();
function LatchWall() = 0.1875;

function BarrelCollarBottomZ() = PivotZ()-(PivotRadius()*0.5);

function WallSupportBolt() =0.25;
function SupportBoltY() = -2;
function SupportBoltZ() = -2;
function SupportBottomZ() = SupportBoltZ()-WallSupportBolt();

module BreakActionPivot(factor=0) {
  Pivot2(xyz=[PivotX(),0,PivotZ()],
         angle=[0,PivotAngle(),0],
         factor=factor)
  children();
}
module ExtractorBit(cutter=false, clearance=0.003) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("DimGrey") RenderIf(!cutter)
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
  color("Silver") RenderIf(!cutter)
  translate([0.5+0.5, 0,ExtractorGuideZ()+(ActionRodWidth()/2)])
  mirror([0,0,1])
  Bolt(bolt=GPBolt(),
       length=0.5+ManifoldGap(), clearance=clear,
       head="flat", capHeightExtra=(cutter?1:0));
}

module ExtractorGuideRod(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Rod
  color("Silver") RenderIf(!cutter) 
  translate([0.625, 0,ExtractorGuideZ()])
  translate([0,-(ActionRodWidth()/2)-clear, -(ActionRodWidth()/2)-clear])
  cube([ExtractorGuideLength(),
        ((ActionRodWidth()/2)+clear)*2,
        ((ActionRodWidth()/2)+clear)*2]);
}

module LatchSpring(length=LatchSpringLength(), compress=0,
                   cutter=false, clearance=0.015,
                   alpha=1) {
  clear = cutter?clearance:0;

  color("SteelBlue", alpha) RenderIf(!cutter)
  translate([LatchLength()+LatchSpringLength(), 0, LatchZ()])
  rotate([0,-90,0])
  cylinder(r=LatchSpringRadius()+clear,
           h=length-compress);
}

module LatchScrews(debug=false, cutter=false, clearance=0.008) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the latch block to the latch rod
  color("Gold") RenderIf(!cutter)
  translate([LatchX()+ChargerTravel()+0.375,0,LatchZ()-(ActionRodWidth()/2)])
  Bolt(bolt=GPBolt(),
       length=ActionRodWidth()+ManifoldGap(), clearance=clear,
       head="socket", capHeightExtra=(cutter?1:0));

  // Actuator pin for the guiderod
  *color("Gold") RenderIf(!cutter)
  translate([0.3125-ReceiverFrontLength(),
             0,
             LatchZ()])
  rotate([180,0,0])
  Bolt(bolt=GPBolt(),
       length=0.5+ManifoldGap(),
       head="flat", capHeightExtra=(cutter?1:0));
}


module Barrel(barrel=BarrelPipe(), length=BarrelLength(),
              clearance=PipeClearanceSnug(),
              cutter=false, alpha=1, debug=false) {

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
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
    rotate([90,0,0])
    translate([0,-0.813*0.5,0])
    rotate(40)
    translate([ExtractorWidth()/4,0.813*0.5*0.1,-ExtractorWidth()/2])
    mirror([1,1,0])
    cube([BarrelDiameter(), BarrelRadius(), ExtractorWidth()]);
  }
}




module SupportBolt(length=ForendLength()+ReceiverFrontLength(),
              debug=false, cutter=false, clearance=0.005, alpha=1) {
  clear = cutter ? clearance : 0;

  color("Silver", alpha) RenderIf(!cutter)
  translate([-ReceiverFrontLength()-ManifoldGap(),0,SupportBoltZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=SupportBolt(), boltLength=length,
             nutHeightExtra=cutter?0.1:0,
             head="hex", nut="hex", clearance=clear);
}
module Extractor(cutter=false, clearance=0.01,
                 debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("DeepSkyBlue", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
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
      Barrel(cutter=true, clearance=PipeClearanceLoose());

      ExtractorBit(cutter=true);

      ExtractorScrew(cutter=true);

      translate([0,0,clearance])
      ExtractorGuideRod(cutter=true);
    }
  }
}

module Extractor_print() {
  translate([0,0,-ExtractorGuideZ()+0.625])
  Extractor();
}

module ExtractorAssembly(debug=false, cutter=false) {
  ExtractorBit(cutter=cutter);
  ExtractorGuideRod(cutter=cutter);
  ExtractorScrew(cutter=cutter);
  Extractor(debug=debug, cutter=cutter);
}
module Latch(debug=false, cutter=false, clearance=0.015, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Latch block
  color("Tomato", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([LatchX(), 0, LatchZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=LatchSpringRadius()+clear,
                      r2=3/16,
                      h=LatchLength()+(cutter?LatchSpringLength():0),
                      teardropTop=true,
                      $fn=Resolution(15,40));

    if (!cutter) {
      hull() for (X = [0,-ChargerTravel()]) translate([X,0,0])
      LatchScrews(cutter=true);
    }
  }
}
module Latch_print() {
  rotate([0,-90,0])
  translate([-LatchX(),0,-LatchZ()])
  Latch();
}
module BreakActionRecoilPlateHousing(debug=false, alpha=1) {
  color("MediumSlateBlue", alpha) render() DebugHalf(enabled=debug)
  difference() {
    mirror([1,0,0])
    union() {
      ReceiverCouplingPattern(length=ReceiverFrontLength(),
                              frameLength=ReceiverFrontLength());
      
      hull() {
        
        // Coupling bolt faceplate
        translate([0,-ReceiverCouplingWidth()/2, LowerOffsetZ()])
        ChamferedCube([ReceiverFrontLength(),
                       ReceiverCouplingWidth(),
                       abs(LowerOffsetZ())],
                      r=1/16);

        // Support bolt support
        translate([0,0,SupportBoltZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=NutHexRadius(SupportBolt()), r2=1/16,
                          h=ReceiverFrontLength(),
                        $fn=Resolution(12,40));
      }
    }

    RecoilPlate(cutter=true);

    RecoilPlateFiringPinAssembly(cutter=true);

    translate([-ReceiverFrontLength(),0,ActionRodZ()])
    ActionRod(length=ActionRodLength(), cutter=true);
  }
}

module BreakActionRecoilPlateHousing_print() {
  rotate([0,-90,0]) translate([--ReceiverFrontLength(),0,0])
  BreakActionRecoilPlateHousing();
}

module BreakActionForend(clearance=0.01, debug=false, alpha=1) {
  color("MediumSlateBlue", alpha) render() DebugHalf(enabled=debug)
  difference() {
    union() {
      ReceiverCouplingPattern(length=ForendLength(),
                              frameLength=ForendLength());
      
      // Support bolt support
      hull() {
        
        // Coupling bolt faceplate
        translate([0,-ReceiverCouplingWidth()/2, BarrelCollarBottomZ()])
        ChamferedCube([ForendLength(),
                       ReceiverCouplingWidth(),
                       abs(LowerOffsetZ())],
                      r=1/16);

        // Support bolt support
        translate([0,0,SupportBoltZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=NutHexRadius(SupportBolt()), r2=1/16,
                          h=ForendLength(),
                        $fn=Resolution(12,40));
      }
    }
    
    for (A = [PivotAngleBack():10:PivotAngle()])
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(),
          angle=A, factor=1) {
      Barrel(cutter=true);
      BarrelLatchCollar(cutter=true);
     }
          
    // Square bottom/back
    difference() {
      hull() {
        translate([PivotX(), -(PivotWidth()/2)-clearance, BarrelCollarBottomZ()])
        mirror([1,0,0])
        ChamferedCube([PivotX()+2,
                       PivotWidth()+(clearance*2),
                       abs(PivotZ())+(PivotRadius()*0.5)+FrameBottomZ()], r=1/16);
          
        // Pivoted position - the bottom half of the barrel
        Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=PivotAngle(), factor=1)
        translate([PivotX(), -(PivotWidth()/2)-clearance, PivotZ()])
        mirror([1,0,0])
        ChamferedCube([PivotX()+2,
                       PivotWidth()+(clearance*2),
                       abs(PivotZ())], r=1/16);
      }
      
      // Pivot radius
      translate([PivotX(), -PivotWidth(), PivotZ()])
      rotate([-90,0,0])
      ChamferedCylinder(r1=PivotRadius()+WallPivot(), r2=1/16,
                         h=PivotWidth()*2, $fn=Resolution(20,80));
    }

    FrameBolts(cutter=true);
    SupportBolt(cutter=true);
     
    Extractor(cutter=true);
    ExtractorGuideRod(cutter=true);

    translate([-ReceiverFrontLength(),0,ActionRodZ()])
    ActionRod(length=ActionRodLength(), cutter=true);
  }
}
module BreakActionForend_print() {
  rotate([0,90,0])
  translate([-ForendLength(),0,-FrameBoltZ()])
  BreakActionForend();
}


module BarrelLatchCollar(cutter=false, clearance=0.01,
                         debug=false, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("Tan", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {

      // Around the barrel sleeve
      translate([LatchCollarLength(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=(PivotWidth()/2)+clear, r2=1/16,
               h=LatchCollarLength(),
               $fn=60);
      
      // Extractor support
      translate([PivotX(), -(ExtractorWidth()/2)-ExtractorWall()-clear, PivotZ()])
      mirror([1,0,0])
      ChamferedCube([PivotX()-1.375,
                     ExtractorWidth()+(ExtractorWall()*2)+clear2,
                     abs(PivotZ())], r=1/16);
      
      // Latch support
      translate([0,-(LatchSupportWidth()/2)-clear,0])
      ChamferedCube([LatchCollarLength(),
                         LatchSupportWidth()+clear2,
                         FrameTopZ()+clear], r=1/16);
      
      *hull() for (Z = [0,LatchZ()])
      translate([0, 0, Z])
      rotate([0,90,0])
      ChamferedCylinder(r1=(LatchSupportWidth()+clear2)/2, r2=1/16,
                        h=LatchCollarLength());
      
      // Pivot Support Extension (to recoil plate)
      translate([0, -(PivotWidth()/2)-clear, BarrelCollarBottomZ()])
      ChamferedCube([PivotX(),
                     PivotWidth()+clear2,
                     abs(BarrelCollarBottomZ())], r=1/16);
      
      // Pivot Support Curve
      intersection() {
        hull() {

          // Around the barrel sleeve
          translate([LatchCollarLength(),0,0])
          rotate([0,-90,0])
          ChamferedCylinder(r1=(PivotWidth()/2)+clear, r2=1/16,
                   h=LatchCollarLength()-BarrelSleeveLength()+clear2,
                   $fn=60);
            
          // Square bottom/back
          translate([LatchCollarLength(), -(PivotWidth()/2)-clear, FrameBottomZ()])
          mirror([1,0,0])
          mirror([0,0,1])
          ChamferedCube([PivotX(),
                         PivotWidth()+clear2,
                         abs(PivotZ())+(PivotRadius()*0.5)+FrameBottomZ()], r=1/16);
        }
        
        // Pivot radius
        translate([PivotX(), (PivotWidth()/2)+clear, PivotZ()])
        rotate([90,0,0])
        ChamferedCylinder(r1=abs(PivotZ())+FrameBottomZ(), r2=1/16,
                           h=PivotWidth()+clear2, $fn=Resolution(20,80));
      }

    }

    // Pivot surface
    hull() for (X = [0,1])
    translate([PivotX()+X, 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=PivotRadius()+clearance-clear, h=3,
             center=true, $fn=Resolution(20,50));
    
    if (!cutter) {
      
      // Pic rail slot
      translate([0,-(UnitsImperial(0.617)/2)-clear,FrameTopZ()-0.125])
      cube([LatchCollarLength(),
            UnitsImperial(0.617)+clear2,
            FrameTopZ()+clear]);
      
      // Set screws
      *for (R = [90,-90]) rotate([R,0,0])
      translate([0.5,0,BarrelSleeveRadius()])
      mirror([1,0,0])
      NutAndBolt(bolt=GPBolt(),
                 boltLength=0.5+ManifoldGap(2),
                 head="none", nut="heatset",
                 teardrop=true,
                 clearance=0.005);

      for (X = [0,-0.5]) translate([X,0,0]) {
        Extractor(cutter=true);
        ExtractorGuideRod(cutter=true);
      }

      Barrel(cutter=true);


      Latch(cutter=true);
      *LatchSpring(cutter=true);
    }
  }

}

module BarrelLatchCollar_print() {
  rotate([0,90,0])
  translate([-LatchCollarLength(),0,0])
  BarrelLatchCollar();
}

module Foregrip(length=ForegripLength(), debug=false, alpha=1) {
  color("Tan",alpha) render() DebugHalf(enabled=debug)
  difference() {
    translate([ForegripOffsetX()+ChargerTravel(),0,0])
    rotate([0,90,0])
    PumpGrip(length=length);

    Barrel(cutter=true, clearance=PipeClearanceLoose());
  }
}

module Foregrip_print() {
  rotate([0,90,0])
  translate([-ForegripLength(),0,0])
  translate([-(ForegripOffsetX()+ChargerTravel()),0,-(LatchZ()-0.5)])
  Foregrip();
}


module BreakActionAssembly(receiverLength=12, pipeAlpha=1,
                           pivotFactor=0, extractFactor=0, chargeFactor=0, lockFactor=0,
                           stock=true, tailcap=false,
                           debug=false) {

  translate([0,0,0]) {
    *RecoilPlateFiringPinAssembly(debug=debug);
    RecoilPlate(debug=debug);
    BreakActionRecoilPlateHousing(debug=debug);
  }
  
  SupportBolt();

  // Pivoting barrel assembly
  BreakActionPivot(factor=pivotFactor) {

    translate([-(ChargerTravel()*chargeFactor),0,0])
    translate([0.5*lockFactor,0,0]) {
      
      LatchScrews();

      translate([-0.5,0,ActionRodZ()])
      ActionRod(length=ActionRodLength());
    }

    translate([0.5*lockFactor,0,0]) {
      //LatchScrews();
      Latch(debug=debug);
    }
    
    LatchSpring(compress=(0.5*lockFactor), alpha=1);

    // Pivot Pin
    *%translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=abs(PivotRadius()), h=3, center=true);

    Barrel(debug=debug);

    translate([-ExtractorTravel()*extractFactor,0,0]) {
      ExtractorAssembly(debug=debug);
    }

    BarrelLatchCollar(debug=debug, alpha=1);

    translate([(0.5*lockFactor)-(ChargerTravel()*chargeFactor),0,0])
    Foregrip();

    *translate([BarrelLength()-1,0,0])
    Bipod();
  }

  BreakActionForend(debug=debug, alpha=0.25);

  translate([-ReceiverFrontLength()+0.5,0,0])
  HammerAssembly(travelFactor=Animate(ANIMATION_STEP_FIRE)
                            - Animate(ANIMATION_STEP_CHARGE),
                 travel=-1);
}

if (_RENDER == "Assembly") {
  BreakActionAssembly(debug=_DEBUG_ASSEMBLY,
                      pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -Animate(ANIMATION_STEP_LOAD),
                      chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                 -Animate(ANIMATION_STEP_CHARGER_RESET),
                      lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                 -Animate(ANIMATION_STEP_LOCK),
                      extractFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -SubAnimate(ANIMATION_STEP_LOAD, end=0.25));


  translate([-ReceiverFrontLength(),0,0])
  Receiver(pipeAlpha=1, buttstockAlpha=1, debug=_DEBUG_ASSEMBLY,
           frameBolts=true, frameBoltLength=FrameBoltLength(),
           couplingBoltExtension=ReceiverFrontLength(),
           triggerAnimationFactor=Animate(ANIMATION_STEP_TRIGGER)
                          -Animate(ANIMATION_STEP_TRIGGER_RESET));
}

scale(25.4) {

  if (_RENDER == "BarrelLatchCollar")
  BarrelLatchCollar_print();

  if (_RENDER == "RecoilPlateHousing")
  BreakActionRecoilPlateHousing_print();

  if (_RENDER == "Forend")
  BreakActionForend_print();

  if (_RENDER == "Foregrip")
  Foregrip_print();

  if (_RENDER == "Extractor")
  Extractor_print();

  if (_RENDER == "Latch")
  Latch_print();
}
