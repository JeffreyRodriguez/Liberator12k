include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/MLOK.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Shapes/Components/Pivot.scad>;
use <../../Shapes/Components/Pump Grip.scad>;
use <../../Shapes/Components/MlokCluster.scad>;
use <../../Shapes/Components/MlokForegrip.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Pipe.scad>;

use <../Components/Sightpost.scad>;

use <../FCG.scad>;
use <../Frame.scad>;
use <../Lower.scad>;
use <../Receiver.scad>;
use <../Stock.scad>;

/* [Export] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "TopBreak_ReceiverFront", "TopBreak_Forend", "TopBreak_BarrelCollar", "TopBreak_Extractor", "TopBreak_Latch", "TopBreak_Foregrip", "TopBreak_BarrelSleeveFixture"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_BARREL = true;
_SHOW_FOREND = true;
_SHOW_FOREGRIP = true;
_SHOW_FRAME = true;
_SHOW_COLLAR = true;
_SHOW_TOPBREAK_EXTRACTOR = true;
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_FCG = true;
_SHOW_STOCK = true;
_SHOW_LOWER = true;
_SHOW_TOPBREAK_LATCH = true;

/* [Transparency] */
_ALPHA_FOREND = 1;  // [0:0.1:1]
_ALPHA_TopBreak_Latch = 1; // [0:0.1:1]
_ALPHA_COLLAR = 1; // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1; // [0:0.1:1]
_ALPHA_TOPBREAK_EXTRACTOR = 1; // [0:0.1:1]
_ALPHA_RECEIVER_FRONT=1; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_RECEIVER = false;
_CUTAWAY_LOWER = false;
_CUTAWAY_BARREL = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_COLLAR = false;
_CUTAWAY_TOPBREAK_EXTRACTOR = false;
_CUTAWAY_TOPBREAK_LATCH = false;

/* [Vitamins] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

BARREL_SET_SCREW = "#8-32"; // ["M4", "#8-32"]
BARREL_SET_SCREW_CLEARANCE = -0.05;

BARREL_SLEEVE_DIAMETER = 1.2501;
BARREL_OUTSIDE_DIAMETER = 1.0001;
BARREL_INSIDE_DIAMETER = 0.813;
BARREL_CLEARANCE = 0.008;
BARREL_LENGTH = 18;
BARREL_Z = 0.0001;
RIM_WIDTH = 0.0301;
RIM_DIAMETER = 0.8875;

RECOIL_PLATE_LENGTH = 0.25;

/* [Fine Tuning] */
PIVOT_X = 4.501;
PIVOT_RADIUS = 0.501;
PIVOT_ANGLE = 30;
PIVOT_WIDTH = 2;
FRAME_BOLT_LENGTH = 10;
WALL_BARREL = 0.1875;

/* [Branding] */
BRANDING_MODEL_NAME = "CAFE12";

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=0.5);


// Settings: Vitamins
function BarrelSetScrew() = BoltSpec(BARREL_SET_SCREW);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown BARREL_SET_SCERW?");

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function BarrelSleeveRadius(clearance=0)
    = BarrelSleeveDiameter(clearance*2)/2;

function BarrelSleeveDiameter(clearance=0)
    = BARREL_SLEEVE_DIAMETER+clearance;

function BarrelInsideRadius(clearance=0)
    = BarrelInsideDiameter(clearance*2)/2;

function BarrelInsideDiameter(clearance=0)
    = BARREL_INSIDE_DIAMETER+clearance;

function BarrelRadius(clearance=0)
    = BarrelDiameter(clearance*2)/2;

function BarrelDiameter(clearance=0)
    = BARREL_OUTSIDE_DIAMETER+clearance;
    
function BarrelWall() = (BarrelDiameter() - BARREL_INSIDE_DIAMETER)/2;
function BarrelSleeveWall() = (BarrelSleeveDiameter() - BarrelDiameter())/2;


// Calculated: Positions
//function ActionRodZ() = FrameBoltZ()-WallFrameBolt()-(ActionRodWidth()/2);
function BarrelZ() = BARREL_Z; // -0.11 for .22LR rimfire

// Settings: Dimensions
function BarrelLength() = BARREL_LENGTH;
function BarrelSleeveLength() = 8;
function WallBarrel() = WALL_BARREL;

function WallPivot() = 0.25;
function PivotAngleBack() = -25;
function PivotAngle() = PIVOT_ANGLE;
function PivotX() = PIVOT_X;
function PivotZ() = BarrelZ()-max(1.325/2, BarrelSleeveRadius()); // Use 1" sch40 as the floor and everything smaller can use the same forend. Anything bigger will need a custom forend.
function PivotWidth() = PIVOT_WIDTH;
function PivotRadius() = PIVOT_RADIUS;
function PivotDiameter() = PivotRadius()*2;
function PivotClearance() = 0.01;
function PivotOuterRadius() = abs(PivotZ())+FrameBoltZ();

function ActionRodLength() = 10;
function FrameBoltLength() = FRAME_BOLT_LENGTH;

function TopBreak_ReceiverFrontLength() = 0.5;
function FrameBackLength() = 0.75+0.5;
function ForendLength() = FrameExtension(length=FRAME_BOLT_LENGTH)
                        - 0.5
                        -TopBreak_ReceiverFrontLength();

function ChargerTravel() = 1.75;

// Calculated: Lengths
function TopBreak_ForegripOffsetX() = 6+ChargerTravel();
function TopBreak_ForegripLength() = 4.625;

// Calculated: Positions
//function ActionRodZ() = FrameBoltZ()-WallFrameBolt()-(ActionRodWidth()/2);
function BarrelOffsetZ() = 0; // -0.11 for .22LR rimfire

function TopBreak_ExtractorWall() = 0.125;
function TopBreak_ExtractorWallBottom() = 0.1875;
function TopBreak_ExtractorWidth() = 0.65;
function TopBreak_ExtractorHeight() = 0.65;
function TopBreak_ExtractorTravel() = 0.3125;
function TopBreak_ExtractorBitWidth() = (1/4);
function TopBreak_ExtractorBitLength() = 1;
function TopBreak_ExtractorSpringLength() = 1.75;
function TopBreak_ExtractorSpringDiameter() = 0.625;
function TopBreak_ExtractorSpringRadius() = TopBreak_ExtractorSpringDiameter()/2;
function TopBreak_ExtractorLength() = (PivotX()-PivotRadius())
                           - TopBreak_ExtractorSpringLength()
                           - WallPivot();

function TopBreak_ExtractorBitZ() = BarrelZ()
                                  - BarrelInsideRadius()
                                  + 0.03;

function TopBreak_ExtractorZ() = BarrelZ()
                               - BarrelSleeveRadius()
                               - TopBreak_ExtractorHeight()
                               - max(TopBreak_ExtractorWall(),0.1875);

function TopBreak_ExtractorHousingWidth() = TopBreak_ExtractorWidth()
                                          + (TopBreak_ExtractorWall()*2);
function TopBreak_BarrelCollarBottomZ() = TopBreak_ExtractorZ()
                                        - TopBreak_ExtractorWallBottom();

// Pivot modules
module PivotClearanceCut(cut=true, width=PivotWidth(), depth=2,
                         clearance=0.005) {
  difference() {
    children();
  
    // Trim off anything that won't clear the pivot
    if (cut)
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    linear_extrude(height=width, center=true)
    rotate(180) mirror([0,1])
    semidonut(minor=(PivotX()-clearance)*2, major=PivotX()*3,
              angle=90);
    
  }
}

module PivotOuterBearing(intersect=true, cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  intersection() {
    
    // Pivot radius
    translate([PivotX(), (PivotWidth()/2)+clear, PivotZ()])
    rotate([90,0,0])
    ChamferedCylinder(r1=PivotOuterRadius()+clear,
                      r2=PivotWidth()/2,
                      teardropTop=true, teardropBottom=true,
                      h=PivotWidth()+clear2);
  
    // Square off front and bottom edges
    if (intersect)
    translate([0, -(PivotWidth()/2)-clear, PivotZ()-(sqrt(2)/2*PivotRadius())])
    ChamferedCube([PivotX(),
                   PivotWidth()+clear2,
                   PivotOuterRadius()+(sqrt(2)/2*PivotRadius())+clear],
                   r=1/16);
  }
}
module PivotInnerBearing(cutter=false, clearance=0.008, widthClearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Inner pivot surface
  translate([PivotX(),-(PivotWidth()/2)-widthClearance, PivotZ()])
  rotate([-90,0,0])
  ChamferedCircularHole(r1=PivotRadius()+clear,
                        r2=1/8,
                        h=PivotWidth()+(widthClearance*2),
                        teardropTop=false, teardropBottom=false);
}

module BreakActionPivot(factor=0) {
  Pivot2(xyz=[PivotX(),0,PivotZ()],
         angle=[0,PivotAngle(),0],
         factor=factor)
  children();
}

// Vitamins
module TopBreak_ExtractorBit(cartridgeRimThickness=RIM_WIDTH, cutter=false, clearance=0.003) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("DimGrey") RenderIf(!cutter)
  translate([cartridgeRimThickness,0,0])
  translate([TopBreak_ExtractorBitWidth()/8,0,TopBreak_ExtractorBitZ()])
  rotate([0,155,0])
  difference() {
    rotate(30)
    cylinder(r=((TopBreak_ExtractorBitWidth()/2)/cos(30))+clear,
             h=TopBreak_ExtractorBitLength(), $fn=6);

    // Cut the flattened tip
    if (!cutter)
    for (M = [0,1]) mirror([M,0,0])
    hull() for (Z = [0,TopBreak_ExtractorBitWidth()/2])
    translate([TopBreak_ExtractorBitWidth()*0.7,0,Z])
    scale([1,1,1.75])
    rotate([90,0,0])
    cylinder(r=TopBreak_ExtractorBitWidth()/2,
             h=TopBreak_ExtractorBitWidth()*(1+cos(30)),
             center=true);
  }
}

module TopBreak_ExtractorRetainer(debug=false, cutter=false, teardrop=false, clearance=0.008) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the TopBreak_Latch block to the TopBreak_Latch rod
  color("Silver") RenderIf(!cutter)
  translate([TopBreak_ExtractorWidth()+TopBreak_ExtractorTravel()+0.5-clear,
             0,
             TopBreak_ExtractorZ()+TopBreak_ExtractorHeight()])
  NutAndBolt(bolt=GPBolt(),
       boltLength=TopBreak_ExtractorHeight()+ManifoldGap(), clearance=clear,
       head="socket", capHeightExtra=(cutter?abs(TopBreak_ExtractorZ())+FrameBoltZ():0), capOrientation=true,
       nut="heatset-long", teardrop=teardrop);
}

module TopBreak_LatchRetainer(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  translate([ChargerTravel()+0.375+(ActionRodWidth()/2),
             -(TopBreak_LatchWidth()/2)-TopBreak_LatchWall()-clear,
             -(ActionRodWidth()*1.5)-clear])
  cube([ActionRodWidth()+clear,
        TopBreak_LatchWidth()+(TopBreak_LatchWall()*2)+clear2,
        ActionRodWidth()+clear2]);
}
module TopBreak_LatchSpring(length=TopBreak_LatchSpringLength(), compress=0, cutter=false, clearance=0.015, alpha=1) {
  clear = cutter?clearance:0;

  color("Silver", alpha) RenderIf(!cutter)
  translate([TopBreak_LatchLength()+TopBreak_LatchSpringLength(), 0, 0])
  rotate([0,-90,0])
  cylinder(r=TopBreak_LatchSpringRadius()+clear,
           h=length-compress);
}

module TopBreak_LatchScrews(debug=false, cutter=false, clearance=0.008) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the TopBreak_Latch block to the TopBreak_Latch rod
  color("Silver") RenderIf(!cutter)
  for(Y = [-0.3125, 0.3125])
  translate([0,Y,TopBreak_LatchZ()+0.1875])
  rotate([0,-90,0])
  Bolt(bolt=GPBolt(),
       length=TopBreak_LatchLength()+ManifoldGap(), clearance=clear,
       head="socket", capHeightExtra=(cutter?1:0), capOrientation=true);

}

module TopBreak_Barrel(od=BARREL_OUTSIDE_DIAMETER, id=BARREL_INSIDE_DIAMETER, length=BarrelLength(), clearance=BARREL_CLEARANCE, cartridgeRimThickness=RIM_WIDTH, sleeve=true, cutter=false, alpha=1, debug=false) {

  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([0,0,BarrelZ()])
  difference() {
    union() {
    
      // Barrel
      rotate([0,90,0])
      cylinder(r=(od/2)+clear, h=BarrelLength());
      
      // Barrel Sleeve
      rotate([0,90,0])
      cylinder(r=BarrelSleeveRadius()+clear, h=BarrelSleeveLength());
    }
    
    if (!cutter) {
      
      // Hollow inside
      rotate([0,90,0])
      cylinder(r=(id/2)+clear, h=length);
      
      // Extractor notch
      *#rotate([90,0,0])
      translate([0,-0.813*0.5,0])
      rotate(40)
      translate([TopBreak_ExtractorBitWidth()/4,0.813*0.5*0.1,-TopBreak_ExtractorBitWidth()/2])
      mirror([1,1,0])
      cube([BarrelSleeveDiameter(), BarrelSleeveRadius(), TopBreak_ExtractorBitWidth()]);
    }
  }
}

module TopBreak_MlokBolts(headType="flat", nutType="heatset", length=0.5, cutter=false, clearance=0.005, teardrop=false) {
  
  // Top Bolts
  color("Silver") RenderIf(!cutter)
  for (X = [0,2])
  translate([0.5+X,0,BarrelRadius()])
  NutAndBolt(bolt=MlokBolt(),
             boltLength=length+ManifoldGap(2),
             head="socket", capHeightExtra=(cutter?1:0),
             nut="none",
             teardrop=cutter,
             clearance=cutter?clearance:0);
}


// Shapes
module TopBreak_LatchGuides(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  translate([0,
             -(TopBreak_ExtractorHousingWidth()/2)-TopBreak_LatchGuideWidth()-clear,
             TopBreak_LatchGuideZ()-clear])
  ChamferedCube([PivotX(),
                 TopBreak_ExtractorHousingWidth()+(TopBreak_LatchGuideWidth()*2)+clear2,
                 TopBreak_LatchGuideHeight()+clear2],
                r=1/16);
}

// Printed Parts
module TopBreak_ReceiverFront(debug=false, alpha=1) {
  color("Tan", alpha) render() DebugHalf(enabled=debug)
  difference() {
    
    translate([-TopBreak_ReceiverFrontLength(),0,0])
    union() {
      hull() {
        mirror([1,0,0])
        ReceiverTopSegment(length=1/8);
        
        Frame_Support(length=TopBreak_ReceiverFrontLength(),
                     chamferFront=true, teardropFront=true);
      }

      hull() {
        
        // Recoil plate backing
        translate([0,-(RecoilPlateWidth()/2)-0.25,RecoilPlateTopZ()])
        mirror([0,0,1])
        ChamferedCube([TopBreak_ReceiverFrontLength(),
                       RecoilPlateWidth()+0.5,
                       RecoilPlateHeight()-0.5],
                      r=1/8, teardropFlip=[true,true,true]);
        
        // Round off the bottom
        translate([0,0,-1])
        rotate([0,90,0])
        ChamferedCylinder(r1=0.625, r2=1/8, h=0.5);
        
      }
    }
    
    Frame_Bolts(cutter=true);
    
    translate([-TopBreak_ReceiverFrontLength(),0,0]) {
      RecoilPlate(length=RECOIL_PLATE_LENGTH, cutter=true);
      RecoilPlateBolts(cutter=true);
      FiringPin(cutter=true);
      FiringPinSpring(cutter=true);
    }
  }
}

module TopBreak_Forend(clearance=0.005, doRender=true, debug=false, alpha=1) {  
  union() {
    
    // Branding text
    color("DimGrey", alpha) 
    RenderIf(doRender) DebugHalf(enabled=debug) {
      
      fontSize = 0.375;
      
      // Right-side text
      translate([ForendLength()-0.375,-FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
      rotate([90,0,0])
      linear_extrude(height=LogoTextDepth(), center=true)
      text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="right");

      // Left-side text
      translate([ForendLength()-0.375,FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
      rotate([90,0,0])
      linear_extrude(height=LogoTextDepth(), center=true)
      mirror([1,0])
      text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="left");
    }
    
    color("Tan", alpha)
    RenderIf(doRender) DebugHalf(enabled=debug)
    difference() {
      union() {
        Frame_Support(length=ForendLength(),
                     chamferBack=true, teardropBack=true);
        
        hull() {
          translate([PivotX(), 0, PivotZ()])
          rotate([90,0,0])
          ChamferedCylinder(r1=PivotRadius()-0.01, r2=1/4, h=3,
                            teardropTop=false, teardropBottom=false, center=true);
          
          // Front face
          translate([ForendLength(), 0,0])
          mirror([1,0,0])
          Frame_Support(length=1/8,
                       extraBottom=FrameBottomZ()+abs(PivotZ()),
                       chamferFront=true, teardropFront=true);
          
          translate([ForendLength(), 0,0])
          mirror([1,0,0])
          Frame_Support(length=PivotRadius()+(ForendLength()-PivotX())+abs(PivotZ())+FrameTopZ(),
                       chamferFront=true, teardropFront=true);
        }
      }
      
      // Cutout the pivot track for the barrel collar to pass
      translate([PivotX(), 0, PivotZ()])
      rotate([0,180,0]) rotate([90,0,0])
      linear_extrude(BarrelSleeveDiameter()+(WallBarrel()*2)+(clearance*2), center=true) {
        rotate(-PivotAngle())
        translate([abs(PivotZ()),PivotZ()])
        square([PivotX()*3/2, abs(PivotZ())+ManifoldGap()]);
        
        semidonut(major=PivotX()*3, minor=abs(PivotZ())*2, angle=PivotAngle());
      }
      
      
      // Ensure the barrel and sleeve can pivot
      for (A = [0, PivotAngle()])
      Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
      TopBreak_Barrel(length=ForendLength()-PivotX(), cutter=true);
      
      // Clearance for the barrel collar
      difference() {
        hull()
        for (A = [0, PivotAngle()])
        Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
        translate([-1,0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+clearance,
                          h=PivotX()+1,
                          r2=1/16);
        
        PivotInnerBearing(cutter=true);
      }
      
      // Cut a path through the full range of motion (Barrel)
      hull() for (A = [0, PivotAngle()])
      Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
      translate([PivotX(),0,0])
      rotate([0,90,0])
      cylinder(r=BarrelSleeveRadius()+BARREL_CLEARANCE,
               h=ForendLength()-PivotX());
      
      // Cut a path through the full range of motion (Collar)
      for (A = [0, PivotAngle()])
      Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
      TopBreak_BarrelCollar(rearExtension=2, cutter=true);
      
      // Printability allowance
      translate([ForendLength(),0,BarrelZ()])
      rotate([0,-90,0])
      HoleChamfer(r1=BarrelSleeveRadius(BARREL_CLEARANCE), r2=1/16,
                  teardrop=true);

      Frame_Bolts(cutter=true);
       
      TopBreak_Extractor(cutter=true);

      *translate([-TopBreak_ReceiverFrontLength(),0,0])
      ActionRod(length=ActionRodLength(), cutter=true);
    }
  }
}
module TopBreak_BarrelCollar(rearExtension=0, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("Chocolate", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      PivotOuterBearing(cutter=cutter);
      
      PivotClearanceCut(cut=!cutter)
      union() {
        
        // Around the barrel
        translate([RIM_WIDTH,0,BarrelZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel()+clear,
                          h=PivotX()-RIM_WIDTH+clear,
                          r2=1/16);
        
        // Extractor support
        translate([RIM_WIDTH-rearExtension-clear,-(TopBreak_ExtractorHousingWidth()/2)-clear,TopBreak_BarrelCollarBottomZ()-clear])
        ChamferedCube([PivotX()-(sqrt(2)/2*PivotRadius())-RIM_WIDTH+rearExtension+clear2,
                       TopBreak_ExtractorHousingWidth()+clear2,
                       abs(TopBreak_BarrelCollarBottomZ())+clear],
                       r=1/16, teardropFlip=[false,true,true]);
      }
      
      
      // Optics Rail Support
      hull() {
        translate([RIM_WIDTH,-0.375,0])
        ChamferedCube([3,0.75, ReceiverTopZ()],
                       r=1/16,teardropFlip=[true,true,true]);
        
        translate([RIM_WIDTH,-BarrelSleeveRadius(),0])
        ChamferedCube([1,BarrelSleeveDiameter(), BarrelSleeveRadius()],
                       r=1/16,teardropFlip=[true,true,true]);
      }
    }
    
    PivotInnerBearing(cutter=true, clearance=(cutter?0:0.01));
    
    if (!cutter) {
      
      TopBreak_MlokBolts(cutter=true);
      
      translate([0.25,0,ReceiverTopZ()]) {
        MlokSlot(length=2.5);
        MlokSlotBack(length=2.5);
      }
    
      // Angled cut for supportless printability
      translate([0,-(PivotWidth()/2),PivotZ()])
      rotate([0,90+45,0])
      cube([3, PivotWidth(), 3]);

      for (X = [0,-TopBreak_ExtractorTravel()])
      translate([X,0,0])
      TopBreak_Extractor(cutter=true);
      
      hull()
      for (X = [0,-TopBreak_ExtractorTravel()])
      translate([X,0,0])
      TopBreak_ExtractorRetainer(cutter=true, teardrop=true);

      TopBreak_Barrel(cutter=true);
    }
  }

}

module TopBreak_Extractor(cutter=false, clearance=0.015, chamferRadius=1/16, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    PivotClearanceCut(cut=!cutter, clearance=0)
    union() {

      // Long lower section
      translate([clear,
                 -(TopBreak_ExtractorWidth()/2)-clear,
                 TopBreak_ExtractorZ()-clear])
      ChamferedCube([TopBreak_ExtractorLength()+(cutter?TopBreak_ExtractorSpringLength()+clear:0),
                     TopBreak_ExtractorWidth()+clear2,
                     TopBreak_ExtractorHeight()+clear2], r=chamferRadius);

      // Tall portion to hold the retainer
      hull() {
        
        // Wide section
        translate([clear,
                   -(TopBreak_ExtractorWidth()/2)-clear,
                   TopBreak_ExtractorZ()])
        ChamferedCube([TopBreak_ExtractorBitWidth()+clear,
                       TopBreak_ExtractorWidth()+clear2,
                       abs(TopBreak_ExtractorZ())],
                      r=chamferRadius);
        
        // Narrow section
        translate([clear,
                   -(TopBreak_ExtractorBitWidth()/2)-clear,
                   TopBreak_ExtractorZ()])
        ChamferedCube([0.75+clear,
                       TopBreak_ExtractorBitWidth()+clear2,
                       abs(TopBreak_ExtractorZ())],
                      r=chamferRadius*2);
      }
    }

    if (!cutter) {
      
      // Cartridge rim
      rotate([0,90,0])
      cylinder(r=RIM_DIAMETER/2, h=RIM_WIDTH+clearance);
      
      TopBreak_Barrel(cutter=true);

      TopBreak_ExtractorBit(cutter=true);
      TopBreak_ExtractorRetainer(cutter=true);
      
      // Chamfer the back edge for smooth operation
      translate([0, 0, TopBreak_ExtractorZ()])
      rotate([90,0,0])
      linear_extrude(height=TopBreak_ExtractorWidth()+ManifoldGap(2), center=true)
      mirror([1,0])
      RoundedBoolean(edgeOffset=0, r=0.5, teardrop=true);
    }
  }
}

module TopBreak_Latch(debug=false, cutter=false, clearance=0.01, alpha=1) { 
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // TopBreak_Latch block
  color("Tan", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([clear,
               -(TopBreak_LatchWidth()/2)-clear,
               TopBreak_LatchZ()-clear])
    ChamferedCube([TopBreak_LatchLength()+(cutter?TopBreak_LatchSpringLength()+clear:0),
                   TopBreak_LatchWidth()+clear2,
                   TopBreak_LatchHeight()+clear2], r=1/16, teardropFlip=[false,true,true]);

    if (!cutter) {
      // TopBreak_Latch lip
      translate([-0.5,-2,RecoilPlateTopZ()-RecoilPlateHeight()])
      cube([0.5,3,1]);
      
      
      translate([-0.5,0,0])
      TopBreak_BarrelCollar(cutter=true);
      
      TopBreak_LatchScrews(cutter=true);
      
      hull()
      for (X = [0,-TopBreak_LatchTravel()])
      translate([X,0,0])
      TopBreak_ExtractorRetainer(cutter=true, teardrop=true);
      TopBreak_LatchRetainer(cutter=true);
      
      ActionRod(cutter=true);
    }
  }
}
module TopBreak_Foregrip(length=TopBreak_ForegripLength(), debug=false, alpha=1) {
  color("Tan",alpha) render() DebugHalf(enabled=debug)
  difference() {
    translate([TopBreak_ForegripOffsetX()+ChargerTravel(),0,0])
    rotate([0,90,0])
    PumpGrip(length=length);

    TopBreak_Barrel(cutter=true);
  }
}


// Fixtures
module TopBreak_BarrelSleeveFixture() {
  wall = 0.1875;
  guideExtra= 1-wall;
  guideWidth = 0.5;
  width = BarrelSleeveDiameter()+(wall*2);
  holeDepth = (width/2)+guideExtra;
  
  
  difference() {
    
    union() {
      
      // Tube body
      translate([-(width/2), -(width/2),0])
      ChamferedCube([width, width, BarrelSleeveLength()], r=1/16);
      
      // Drill/Tap guide
      translate([0, -(guideWidth/2),0])
      ChamferedCube([(width/2)+guideExtra, guideWidth, BarrelSleeveLength()], r=1/16);
      
      // Fillets
      for (M = [0,1]) mirror([0,M,0])
      translate([(width/2)-ManifoldGap(), (guideWidth/2)-ManifoldGap(), 0.25])
      rotate(-90)
      Fillet(r=1/8, h=BarrelSleeveLength()-0.5);
    }
    
    ChamferedCircularHole(r1=BarrelSleeveRadius(BARREL_CLEARANCE),
                          r2=1/16,
                          h=BarrelSleeveLength());
    
    // Stand the barrel up
    rotate([0,-90,0])
    TopBreak_Barrel(cutter=true);
    
    // Holes
    for (Z = [0.5:0.5:BarrelSleeveLength()-0.5])
    translate([0,0,Z])
    rotate([0,90,0])
    cylinder(r=1/8/2, h=holeDepth);
    
  }
}

// Assembly
module TopBreak_Assembly(receiverLength=12, pipeAlpha=1, TopBreak_ReceiverFrontAlpha=1, pivotFactor=0, extractFactor=0, chargeFactor=0, lockFactor=0, stock=true, tailcap=false, debug=undef) {

  if (_SHOW_FCG)
  translate([-TopBreak_ReceiverFrontLength(),0,0]) {
    SimpleFireControlAssembly(actionRod=false);
  }
  
  // Pivoting barrel assembly
  BreakActionPivot(factor=pivotFactor) {

    if (_SHOW_BARREL)
    TopBreak_Barrel(debug=debug == true || _CUTAWAY_BARREL);
    
    translate([BarrelLength()-1,0,0])
    rotate([0,-90,0]) {
      Sightpost(radius=1.06/2);
      SightpostBolts(radius=1.06/2);
    }

    // TopBreak_Extractor Spring
    if (_SHOW_TOPBREAK_EXTRACTOR)
    %translate([PivotX()-PivotRadius()-WallPivot(),0,TopBreak_ExtractorZ()+TopBreak_ExtractorSpringRadius()])
    rotate([0,-90,0])
    cylinder(r=TopBreak_ExtractorSpringRadius(),
              h=TopBreak_ExtractorSpringLength()+(TopBreak_ExtractorTravel()*extractFactor));
    
    if (_SHOW_TOPBREAK_EXTRACTOR)
    translate([-TopBreak_ExtractorTravel()*extractFactor,0,0]) {
      TopBreak_ExtractorBit();
      TopBreak_ExtractorRetainer();
      TopBreak_Extractor(debug=debug == true || _CUTAWAY_TOPBREAK_EXTRACTOR,
                         alpha=_ALPHA_TOPBREAK_EXTRACTOR);
    }
    
    TopBreak_MlokBolts();

    if (_SHOW_COLLAR)
    TopBreak_BarrelCollar(debug=debug == true || _CUTAWAY_COLLAR, alpha=_ALPHA_COLLAR);
    
    children();
  }
  
  if (_SHOW_RECEIVER_FRONT)
  TopBreak_ReceiverFront(debug=debug==true, alpha=_ALPHA_RECEIVER_FRONT);

  if (_SHOW_FOREND)
  TopBreak_Forend(debug=debug == true || _CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
}


scale(25.4)
if ($preview) {
  
  translate([-TopBreak_ReceiverFrontLength(),0,0]) {
    

    if (_SHOW_LOWER) {
      Lower(showLeft=!_CUTAWAY_LOWER);
      LowerMount(debug=_CUTAWAY_LOWER);
    }
    
    if (_SHOW_RECEIVER) {
      if (_SHOW_FRAME)
      Receiver_TensionBolts();
      
      Frame_ReceiverAssembly(
        frameBolts=_SHOW_FRAME,
        length=FRAME_BOLT_LENGTH,
        debug=_CUTAWAY_RECEIVER);
    }

    if (_SHOW_STOCK) {
      StockAssembly();
    }
  }
  
  TopBreak_Assembly(pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -Animate(ANIMATION_STEP_LOAD),
                      chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                 -Animate(ANIMATION_STEP_CHARGER_RESET),
                      lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                 -Animate(ANIMATION_STEP_LOCK),
                      extractFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -SubAnimate(ANIMATION_STEP_LOAD, end=0.25)) {
  
    if (_SHOW_FOREGRIP)
    translate([ForendLength()+1,0,0]){
      
      translate([UnitsMetric(10)+0.25,0,-MlokForegripLength()-BarrelRadius()-0.5])
      rotate(90) {
        MlokForegripBolts();
        MlokForegrip(alpha=0.5);
      }
      
      rotate([0,90,0])
      MlokCluster(radius=BarrelRadius(), alpha=0.5);
    }
    
    *if (_SHOW_FOREGRIP)
    TopBreak_Foregrip();
  };
} else {
  
  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "TopBreak_BarrelCollar")
    if (!_RENDER_PRINT)
      TopBreak_BarrelCollar();
    else
      rotate([0,-90,0])
      TopBreak_BarrelCollar();

  if (_RENDER == "TopBreak_ReceiverFront")
    if (!_RENDER_PRINT)
      TopBreak_ReceiverFront();
    else
      rotate([0,-90,0])
      translate([--TopBreak_ReceiverFrontLength(),0,0])
      TopBreak_ReceiverFront();

  if (_RENDER == "TopBreak_Forend")
    if (!_RENDER_PRINT)
      TopBreak_Forend();
    else
      rotate([0,90,0])
      translate([-ForendLength(),0,0])
      TopBreak_Forend();

  if (_RENDER == "TopBreak_Foregrip")
    if (!_RENDER_PRINT)
      TopBreak_Foregrip();
    else
      rotate([0,90,0])
      translate([-TopBreak_ForegripLength(),0,0])
      translate([-(TopBreak_ForegripOffsetX()+ChargerTravel()),0,0])
      TopBreak_Foregrip();

  if (_RENDER == "TopBreak_Extractor")
    if (!_RENDER_PRINT)
      TopBreak_Extractor();
    else
      translate([0,0,-TopBreak_ExtractorZ()])
      TopBreak_Extractor();
  
  // ********************
  // * Fixures and Jigs *
  // ********************
  if (_RENDER == "TopBreak_BarrelSleeveFixture")
    if (!_RENDER_PRINT)
      TopBreak_BarrelSleeveFixture();
    else
      TopBreak_BarrelSleeveFixture();
  
  // ************
  // * Hardware *
  // ************
  if (_RENDER == "TopBreak_Barrel")
  TopBreak_Barrel();
  
  if (_RENDER == "TopBreak_ExtractorBit")
  TopBreak_ExtractorBit();
  
  if (_RENDER == "TopBreak_ExtractorRetainer")
  TopBreak_ExtractorRetainer();
  
  if (_RENDER == "TopBreak_MlokBolts")
  TopBreak_MlokBolts();
}
