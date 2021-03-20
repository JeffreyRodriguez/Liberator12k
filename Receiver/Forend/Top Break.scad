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
use <../../Ammo/Cartridges/Cartridge.scad>;
use <../../Ammo/Cartridges/Cartridge_12GA.scad>;

use <../Lower/Lower.scad>;

use <../Buttstock.scad>;
use <../Lower/Mount.scad>;
use <../Frame.scad>;
use <../Receiver.scad>;
use <../Fire Control Group.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "ReceiverFront", "ReceiverForend", "BarrelCollar", "Extractor", "Latch", "Foregrip"]


_SHOW_RECEIVER = true;
_SHOW_STOCK = true;
_SHOW_LOWER = true;
_SHOW_LOWER_LUGS = true;
_CUTAWAY_RECEIVER = false;
_ALPHA_RECEIVER_TUBE = 1; // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]

_SHOW_FOREND = true;
_CUTAWAY_FOREND = false;
_ALPHA_FOREND = 1;  // [0:0.1:1]

_SHOW_COLLAR = true;
_CUTAWAY_COLLAR = false;
_ALPHA_COLLAR = 1; // [0:0.1:1]


_SHOW_EXTRACTOR = true;
_ALPHA_EXTRACTOR = 1; // [0:0.1:1]
_CUTAWAY_EXTRACTOR = false;

_SHOW_LATCH = true;
_ALPHA_LATCH = 1; // [0:0.1:1]
_CUTAWAY_LATCH = false;

_SHOW_BARREL = true;
_SHOW_FRAME = true;
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]

/* [Screws] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

BARREL_SET_SCREW = "#8-32"; // ["M4", "#8-32"]
BARREL_SET_SCREW_CLEARANCE = -0.05;

/* [Barrel] */
BARREL_OUTSIDE_DIAMETER = 1.0001;
BARREL_INSIDE_DIAMETER = 0.813;
BARREL_CLEARANCE = 0.005;

$fs = UnitsFs()*0.5;

// Settings: Vitamins
function BarrelPipe() = Spec_PipeThreeQuarterInch();
function BarrelSleevePipe() = Spec_PipeOneInch();
function ChamberBolt() = Spec_BoltM3();

function BarrelSetScrew() = BoltSpec(BARREL_SET_SCREW);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown BARREL_SET_SCERW?");

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

// Settings: Dimensions
function BarrelLength() = 18;
function BarrelSleeveLength() = 4;
function WallBarrel() = 0.1875;

function WallPivot() = 0.25;
function PivotAngleBack() = -15;
function PivotAngle() = 35;
function PivotX() = 4.75;
function PivotZ() = -1.125;// (FrameBoltZ() + (FrameBoltRadius()+PivotRadius()));
function PivotWidth() = 1.75;
function PivotRadius() = 1/2;
function PivotDiameter() = PivotRadius()*2;
function PivotClearance() = 0.01;

function ActionRodLength() = 10;
function LatchSpringLength() = 2;
function LatchSpringDiameter() = 0.65;

function FrameBoltLength() = 10;

function ReceiverFrontLength() = 0.5;
function FrameBackLength() = 0.75+0.5;
function ForendLength() = FrameExtension(length=FrameBoltLength())
                        -ReceiverFrontLength()
                        -FrameBackLength();
                        
function LatchTravel() = 0.5;
function ChargerTravel() = 1.75;
function LatchCollarLength() = PivotX()+(PivotRadius()*(sqrt(2)/2));
function LatchCollarLength() = ForendLength()+0.25;

// Calculated: Dimensions
function BarrelRadius(clearance=0)
    = BarrelDiameter(clearance*2);

function BarrelDiameter(clearance=0)
    = BARREL_OUTSIDE_DIAMETER+clearance;

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
//function ActionRodZ() = FrameBoltZ()-WallFrameBolt()-(ActionRodWidth()/2);
function BarrelOffsetZ() = 0; // -0.11 for .22LR rimfire

function ExtractorWall() = 0.1875;
function ExtractorWidth() = 0.65;
function ExtractorHeight() = 0.65;
function ExtractorTravel() = 0.375;
function ExtractorBitWidth() = (1/4);
function ExtractorBitLength() = 1;
function ExtractorSpringLength() = 2;
function ExtractorSpringDiameter() = 0.625;
function ExtractorSpringRadius() = ExtractorSpringDiameter()/2;
function ExtractorLength() = (PivotX()-PivotRadius())
                           - ExtractorSpringLength()
                           - WallPivot();
function ExtractorZ() = -1.5;

function LatchWidth() = 0.65;
function LatchHeight() = 0.75;
function LatchWall() = 0.1875;
function LatchZ() = 1.5; //ActionRodZ()+(ActionRodWidth()/2)+LatchWall();
function LatchLength() = ActionRodWidth()
                       + (ActionRodWidth() + LatchWall())
                       + ChargerTravel()
                       + (ActionRodWidth() + LatchWall());
                       
function BarrelCollarBottomZ() = ExtractorZ() - 0.1875; //PivotZ()-(PivotRadius()*0.5);

function PumpLockRodX() = LatchCollarLength()+0.5;
function PumpLockRodZ() = BarrelRadius();
function PumpLockRodLength() = ForegripOffsetX()
                             - LatchCollarLength()
                             + LatchTravel();

// Pivot modules
module PivotClearanceCut(width=ExtractorWidth()*2, depth=2,
                         clearance=0.02) {
  difference() {
    children();
  
    // Trim off anything that won't clear the pivot
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    linear_extrude(height=width, center=true)
    rotate(180) mirror([0,1])
    semidonut(minor=(PivotX()-clearance)*2, major=PivotX()*3,
              angle=90,
              $fn=Resolution(100,200));
    
  }
}

module PivotOuterBearing(intersect=true, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  intersection() {
    
    // Pivot radius
    translate([PivotX(), (PivotWidth()/2)+clear, PivotZ()])
    rotate([90,0,0])
    ChamferedCylinder(r1=abs(PivotZ())+FrameBoltZ()+clear,
                      r2=PivotWidth()/2,
                      teardropTop=true, teardropBottom=true,
                      h=PivotWidth()+clear2, $fn=Resolution(20,80));
  
    // Square bottom/back
    if (intersect)
    translate([0, -(PivotWidth()/2)-clear, BarrelCollarBottomZ()])
    ChamferedCube([LatchCollarLength(),
                   PivotWidth()+clear2,
                   abs(BarrelCollarBottomZ())+FrameTopZ()+clear],
                   r=1/16);
  }
}
module PivotInnerBearing(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Inner pivot surface
  translate([PivotX(), -(PivotWidth()/2)-clear, PivotZ()])
  rotate([-90,0,0])
  ChamferedCircularHole(r1=PivotRadius()+clearance-clear,
                        r2=PivotRadius(),
                        h=PivotWidth()+clear2,
                        teardropTop=true, teardropBottom=true,
                        $fn=Resolution(20,50));
}

module BreakActionPivot(factor=0) {
  Pivot2(xyz=[PivotX(),0,PivotZ()],
         angle=[0,PivotAngle(),0],
         factor=factor)
  children();
}

// Vitamins
module ExtractorBit(cutter=false, clearance=0.003) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("DimGrey") RenderIf(!cutter)
  translate([CartridgeRimThickness(Spec_Cartridge_12GA()),0,0])
  translate([ExtractorBitWidth()/8,0,-(11/32)])
  rotate([0,155,0])
  difference() {
    rotate(30)
    cylinder(r=((ExtractorBitWidth()/2)/cos(30))+clear,
             h=ExtractorBitLength(), $fn=6);

    if (!cutter)
    for (M = [0,1]) mirror([M,0,0])
    hull() for (Z = [0,ExtractorBitWidth()/2])
    translate([ExtractorBitWidth()*0.7,0,Z])
    scale([1,1,1.75])
    rotate([90,0,0])
    cylinder(r=ExtractorBitWidth()/2,
             h=ExtractorBitWidth()*(1+cos(30)),
             center=true);
  }
}

module ExtractorRetainer(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  translate([ExtractorWidth()+ExtractorTravel()-clear,
             -(ExtractorWidth()/2)-ExtractorWall()-clear,
             ExtractorZ()+ExtractorWall()-clear])
  cube([ActionRodWidth()+clear2,
        ExtractorWidth()+(ExtractorWall()*2)+clear2,
        ActionRodWidth()+clear2]);
}
module LatchRetainer(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  translate([ChargerTravel()+0.375+(ActionRodWidth()/2),
             -(LatchWidth()/2)-LatchWall()-clear,
             -(ActionRodWidth()*1.5)-clear])
  cube([ActionRodWidth()+clear,
        LatchWidth()+(LatchWall()*2)+clear2,
        ActionRodWidth()+clear2]);
}
module LatchSpring(length=LatchSpringLength(), compress=0,
                   cutter=false, clearance=0.015,
                   alpha=1) {
  clear = cutter?clearance:0;

  color("Silver", alpha) RenderIf(!cutter)
  translate([LatchLength()+LatchSpringLength(), 0, 0])
  rotate([0,-90,0])
  cylinder(r=LatchSpringRadius()+clear,
           h=length-compress);
}

module LatchScrews(debug=false, cutter=false, clearance=0.008) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the latch block to the latch rod
  color("Gold") RenderIf(!cutter)
  translate([ChargerTravel()+0.375,0,(ActionRodWidth()/2)])
  mirror([0,0,1])
  Bolt(bolt=GPBolt(),
       length=ActionRodWidth()+ManifoldGap(), clearance=clear,
       head="socket", capHeightExtra=(cutter?1:0));

}

module PumpLockRod(cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  for (R = [180]) rotate([R,0,0]) {
    color("Silver")
    translate([PumpLockRodX()-clear,
               -(ActionRodWidth()/2)-clear,
               PumpLockRodZ()-clear])
    cube([PumpLockRodLength()+clear,
          ActionRodWidth()+clear2,
          ActionRodWidth()+clear2]);

    // Secure the latch block to the latch rod
    color("Gold") RenderIf(!cutter)
    translate([PumpLockRodX()+0.375,0,PumpLockRodZ()-0.01])
    Bolt(bolt=BarrelSetScrew(), head="none",
         length=(cutter?FrameTopZ():0.5),
         clearance=clear, teardrop=cutter, teardropAngle=180);
    
    // Secure the latch block to the latch rod
    color("Silver") RenderIf(!cutter)
    translate([PumpLockRodX()+PumpLockRodLength()-0.375,0,PumpLockRodZ()-0.01])
    Bolt(bolt=BarrelSetScrew(), head="socket",
         length=(cutter?FrameTopZ():0.25),
         clearance=clear, teardrop=cutter, teardropAngle=180);
  }
}

module Barrel(od=BARREL_OUTSIDE_DIAMETER, id=BARREL_INSIDE_DIAMETER,
              length=BarrelLength(),
              clearance=BARREL_CLEARANCE,
              cartridgeRimThickness=0.03,
              cutter=false, alpha=1, debug=false) {
                
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([0,0,BarrelOffsetZ()])
  difference() {
    rotate([0,90,0])
    union() {
      *Pipe(pipe=BarrelSleevePipe(),
           length=BarrelSleeveLength(),
           hollow=!cutter, clearance=(cutter?clearance:undef));

      translate([0,0,cartridgeRimThickness])
      cylinder(r=(od/2)+clear, h=length);
    }

    if (!cutter) {
      
      // Hollow inside
      translate([0,0,cartridgeRimThickness])
      cylinder(r=(id/2)+clear, h=length);
      
      
      // Extractor notch
      rotate([90,0,0])
      translate([0,-0.813*0.5,0])
      rotate(40)
      translate([ExtractorBitWidth()/4,0.813*0.5*0.1,-ExtractorBitWidth()/2])
      mirror([1,1,0])
      cube([BarrelDiameter(), BarrelRadius(), ExtractorBitWidth()]);
    }
  }
}

// Printed Parts
module ReceiverFront(debug=false, alpha=1) {
  color("MediumSlateBlue", alpha) render() DebugHalf(enabled=debug)
  difference() {
    mirror([1,0,0]) {
      hull() {
        translate([ReceiverFrontLength(),0,0])
        ReceiverSegment(length=ManifoldGap());
        
        FrameSupport(length=ReceiverFrontLength());
        CouplingSupport(length=ReceiverFrontLength());

        // Match the recoil plate
        translate([0,-2.25/2,LowerOffsetZ()])
        cube([ReceiverFrontLength(),
                       2.25,
                       abs(LatchZ())+FrameBoltZ()]);
      }
    }

    // Bolt Slot
    hull() for (Y = [-1,1])
    translate([0, 1.25/2*Y, 0])
    rotate([0,-90,0])
    cylinder(r=0.125, h=ReceiverFrontLength(), $fn=20);
    
    translate([-ReceiverFrontLength(),0,0])
    CouplingBolts(extension=ReceiverFrontLength(), boltHead="none", cutter=true);
    
    FrameBolts(cutter=true);

    translate([-ReceiverFrontLength(),0,0]) {
      RecoilPlate(cutter=true);
      
      RecoilPlateBolts(cutter=true);
      
      FiringPin(cutter=true);
      
      ActionRod(cutter=true);
    }
  }
}

module ReceiverFront_print() {
  rotate([0,-90,0]) translate([--ReceiverFrontLength(),0,0])
  ReceiverFront();
}

module Extractor(cutter=false, clearance=0.015,
                 chamferRadius=1/16,
                 debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("DeepSkyBlue", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  PivotClearanceCut()
  difference() {
    union() {

      // Long lower section
      translate([clear,
                 -(ExtractorWidth()/2)-clear,
                 ExtractorZ()-clear])
      ChamferedCube([ExtractorLength()+(cutter?ExtractorSpringLength()+clear:0),
                     ExtractorWidth()+clear2,
                     ExtractorHeight()+clear2], r=chamferRadius);

      // Tall portion to hold the retainer
      translate([clear,
                 -(ExtractorWidth()/2)-clear,
                 ExtractorZ()])
      ChamferedCube([0.75+clear,
                     ExtractorWidth()+clear2,
                     abs(ExtractorZ())],
                    r=chamferRadius);
      
    }

    if (!cutter) {
      Barrel(cutter=true, clearance=PipeClearanceLoose());

      ExtractorBit(cutter=true);
      ExtractorRetainer(cutter=true);
      
      // Chamfer the back edge for smooth operation
      translate([0, 0, ExtractorZ()])
      rotate([90,0,0])
      linear_extrude(height=ExtractorWidth()+ManifoldGap(2), center=true)
      mirror([1,0])
      RoundedBoolean(edgeOffset=0, r=1/2, teardrop=true, $fn=50);
    }
  }
}

module Extractor_print() {
  translate([0,0,-ExtractorZ()])
  Extractor();
}

module Latch(debug=false, cutter=false, clearance=0.02, alpha=1) { 
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Latch block
  color("Tomato", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([clear,
               -(LatchWidth()/2)-clear,
               LatchZ()-LatchHeight()-clear])
    ChamferedCube([LatchLength()+(cutter?LatchSpringLength()+clear:0),
                   LatchWidth()+clear2,
                   LatchHeight()+clear2], r=1/16);

    if (!cutter) {
      hull() for (X = [(ActionRodWidth()/2),-ChargerTravel()]) translate([X,0,0])
      LatchScrews(cutter=true);
      LatchRetainer(cutter=true);
      
      ActionRod(cutter=true);
    }
  }
}
module Latch_print() {
  rotate([0,-90,0])
  translate([0,0,-LatchZ()])
  Latch();
}

module ReceiverForend(clearance=0.01, debug=false, alpha=1) {
  color("MediumSlateBlue", alpha) render() DebugHalf(enabled=debug)
  difference() {
    hull() {
      FrameSupport(length=ForendLength());
      CouplingSupport(length=ForendLength());

      // Match the recoil plate
      translate([0,-2.25/2,LowerOffsetZ()])
      ChamferedCube([ForendLength(),
                     2.25,
                     abs(LatchZ())+FrameBoltZ()], r=1/16);
    }
    
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=PivotAngle(), factor=1)
    Barrel(cutter=true);
    
    for (A = [0, PivotAngle(), PivotAngleBack()])
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
    BarrelCollar(cutter=true);
     
    // Square bottom/back
    difference() {
      hull() {
        translate([0, -BarrelSleeveRadius()-clearance, BarrelCollarBottomZ()])
        ChamferedCube([PivotX()-PivotRadius(),
                       BarrelSleeveDiameter()+(clearance*2),
                       abs(BarrelCollarBottomZ())], r=1/16);
          
        // Pivoted position - the bottom half of the barrel
        Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=PivotAngle(), factor=1)
        translate([PivotX(), -BarrelSleeveRadius()-clearance, PivotZ()])
        mirror([1,0,0])
        ChamferedCube([PivotX()+2,
                       BarrelSleeveDiameter()+(clearance*2),
                       abs(PivotZ())], r=1/16);
      }
      
      PivotInnerBearing(cutter=true);
    }

    FrameBolts(cutter=true);
    CouplingBolts(boltHead="none", extension=ForendLength(), cutter=true);
     
    Extractor(cutter=true);

    translate([-ReceiverFrontLength(),0,0])
    ActionRod(length=ActionRodLength(), cutter=true);
  }
}
module ReceiverForend_print() {
  rotate([0,90,0])
  translate([-ForendLength(),0,0])
  ReceiverForend();
}


module BarrelCollar(cutter=false, clearance=0.01,
                         debug=false, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;
                           
  supportWidth = 1.5;

  color("Tan", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  PivotClearanceCut()
  difference() {
    union() {
      
      // Extractor and latch support
      translate([clear,-(supportWidth/2)-clear,BarrelCollarBottomZ()])
      ChamferedCube([LatchCollarLength()-clear,
                     supportWidth+clear2,
                     abs(BarrelCollarBottomZ())+FrameTopZ()+clear],
                     r=1/16);
      
      PivotOuterBearing(cutter=cutter);

    }
    
    PivotInnerBearing(cutter=true);
          
    // Chop the front-top of the pivot bearing interface
    translate([PivotX(), 0, PivotZ()])
    rotate([0,90,0])
    linear_extrude(height=LatchCollarLength()-PivotX())
    projection(cut=true)
    translate([-PivotX(),0,-PivotZ()])
    PivotInnerBearing(cutter=true);
    
    // Angled cut to remove the front-bottom tip of the pivot bearing interface
    translate([PivotX(),-(PivotWidth()/2)-clear, 0])
    translate([0,0,PivotZ()])
    rotate([0,45,0])
    translate([0,0,BarrelCollarBottomZ()])
    cube([PivotX(),
          PivotWidth()+clear2,
          abs(BarrelCollarBottomZ())+PivotRadius()]);
    
  
    if (!cutter) {
      
      // Chamfer the back bottom-edge for improved clearance
      translate([clearance, 0, BarrelCollarBottomZ()])
      rotate([90,0,0])
      linear_extrude(height=supportWidth+ManifoldGap(2), center=true)
      mirror([1,0])
      RoundedBoolean(edgeOffset=0, r=1/4, teardrop=false, $fn=50);
      
      // Pic rail slot
      translate([0,-(UnitsImperial(0.617)/2)-clear,FrameTopZ()-0.125])
      cube([LatchCollarLength(),
            UnitsImperial(0.617)+clear2,
            FrameTopZ()+clear]);

      for (X = [0,-ExtractorTravel()])
      translate([X,0,0])
      Extractor(cutter=true);
      
      hull()
      for (X = [0,-ExtractorTravel()])
      translate([X,0,0])
      ExtractorRetainer(cutter=true);

      Barrel(cutter=true);
      
      for (X = [0,-LatchTravel()])
      translate([X,0,0])
      Latch(cutter=true);
      
      hull()
      for (X = [0,LatchTravel()])
      translate([X,0,0])
      LatchRetainer(cutter=true);
      
      ActionRod(cutter=true, length=ActionRodLength());
      
      PumpLockRod(cutter=true);
    }
  }

}

module BarrelCollar_print() {
  rotate([0,90,0])
  translate([-LatchCollarLength(),0,0])
  BarrelCollar();
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
  translate([-(ForegripOffsetX()+ChargerTravel()),0,0])
  Foregrip();
}


// Assemblies
module ExtractorAssembly(debug=false, cutter=false) {
  ExtractorBit(cutter=cutter);
  ExtractorRetainer(cutter=cutter);
  Extractor(debug=debug, cutter=cutter);
}

module BreakActionAssembly(receiverLength=12, pipeAlpha=1, receiverFrontAlpha=1,
                           pivotFactor=0, extractFactor=0, chargeFactor=0, lockFactor=0,
                           stock=true, tailcap=false,
                           debug=false) {


  translate([-ReceiverFrontLength(),0,0]) {
    SimpleFireControlAssembly();
  }
  
  // Pivoting barrel assembly
  BreakActionPivot(factor=pivotFactor) {
      
    *PumpLockRod();

    translate([-(ChargerTravel()*chargeFactor),0,0])
    translate([0.5*lockFactor,0,0]) {
      
      LatchScrews();

      translate([-0.5,0,0])
      ActionRod(length=ActionRodLength());
    }

    translate([0.5*lockFactor,0,0]) {
      if (_SHOW_LATCH)
      Latch(debug=_CUTAWAY_LATCH, alpha=_ALPHA_LATCH);
      
      LatchRetainer();
    }

    if (_SHOW_BARREL)
    Barrel();

    // Extractor Spring
    %translate([PivotX()-PivotRadius()-WallPivot(),0,ExtractorZ()+ExtractorSpringRadius()])
    rotate([0,-90,0])
    cylinder(r=ExtractorSpringRadius(),
              h=ExtractorSpringLength()+(ExtractorTravel()*extractFactor));
    
    translate([-ExtractorTravel()*extractFactor,0,0]) {
      ExtractorBit();
      ExtractorRetainer();
      Extractor(debug=_CUTAWAY_EXTRACTOR, alpha=_ALPHA_EXTRACTOR);
    }

    if (_SHOW_COLLAR)
    BarrelCollar(debug=_CUTAWAY_COLLAR, alpha=_ALPHA_COLLAR);

    translate([(0.5*lockFactor)-(ChargerTravel()*chargeFactor),0,0])
    Foregrip();

    *translate([BarrelLength()-1,0,0])
    Bipod();
    
    LatchSpring(compress=(0.5*lockFactor), alpha=0.25);

  }
  
  ReceiverFront(debug=debug, alpha=_ALPHA_RECOIL_PLATE_HOUSING);

  if (_SHOW_FOREND)
  ReceiverForend(debug=_CUTAWAY_FOREND, alpha=_ALPHA_FOREND);

  *translate([-ReceiverFrontLength()-1-1,0,0])
  HammerAssembly(travelFactor=Animate(ANIMATION_STEP_FIRE)
                            - Animate(ANIMATION_STEP_CHARGE),
                 travel=ChargerTravel());
}

if (_RENDER == "Assembly") {
  
  translate([-ReceiverFrontLength(),0,0]) {
    
    if (_SHOW_LOWER_LUGS)
    LowerMount();

    if (_SHOW_LOWER)
    translate([-LowerMaxX(),0,LowerOffsetZ()])
    Lower(showTrigger=true,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true);
    
    if (_SHOW_RECEIVER) {
      TensionBolts();
      
      Receiver_LargeFrameAssembly(debug=_CUTAWAY_RECEIVER);
    }

    if (_SHOW_STOCK) {
      StockAssembly();
    }
  }
  
  BreakActionAssembly(pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -Animate(ANIMATION_STEP_LOAD),
                      chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                 -Animate(ANIMATION_STEP_CHARGER_RESET),
                      lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                 -Animate(ANIMATION_STEP_LOCK),
                      extractFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -SubAnimate(ANIMATION_STEP_LOAD, end=0.25));
}

scale(25.4) {

  if (_RENDER == "BarrelCollar")
  BarrelCollar_print();

  if (_RENDER == "ReceiverFront")
  ReceiverFront_print();

  if (_RENDER == "ReceiverForend")
  ReceiverForend_print();

  if (_RENDER == "Foregrip")
  Foregrip_print();

  if (_RENDER == "Extractor")
  Extractor_print();

  if (_RENDER == "Latch")
  Latch_print();
}
