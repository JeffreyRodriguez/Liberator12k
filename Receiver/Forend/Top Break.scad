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

/* [Print] */

// First Render the part (F6) then Export to STL (F7)
_RENDER = "Choose a part!"; // ["Choose a part!", "ReceiverFront", "ReceiverForend", "BarrelCollar", "Extractor", "Latch", "Foregrip"]

_SHOW_BARREL = true;
_SHOW_FOREND = true;
_SHOW_FRAME = true;
_SHOW_COLLAR = true;
_SHOW_EXTRACTOR = true;
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_FCG = true;
_SHOW_STOCK = true;
_SHOW_LOWER = true;
_SHOW_LOWER_MOUNT = true;
_SHOW_LATCH = true;

/* [Cutaway] */
_CUTAWAY_RECEIVER = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_COLLAR = false;
_CUTAWAY_EXTRACTOR = false;
_CUTAWAY_LATCH = false;


/* [Transparency] */
_ALPHA_FOREND = 1;  // [0:0.1:1]
_ALPHA_LATCH = 1; // [0:0.1:1]
_ALPHA_COLLAR = 1; // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1; // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_EXTRACTOR = 1; // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]

/* [Vitamins] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

BARREL_SET_SCREW = "#8-32"; // ["M4", "#8-32"]
BARREL_SET_SCREW_CLEARANCE = -0.05;

COUPLING_BOLT_Z = -1.0001; //-0.8750;
COUPLING_BOLT_Y =  1.25; //1.1250;

/* [Barrel] */
BARREL_OUTSIDE_DIAMETER = 1.0001;
BARREL_INSIDE_DIAMETER = 0.813;
BARREL_CLEARANCE = 0.005;
BARREL_LENGTH = 18;
RIM_WIDTH = 0.0301;
RIM_DIAMETER = 0.8875;

/* [Fine Tuning] */
PIVOT_X = 4.501;
PIVOT_Z = -1;
PIVOT_ANGLE = 30;
PIVOT_WIDTH = 1.75;
FRAME_BOLT_LENGTH = 10;

/* [Branding] */
BRANDING_MODEL_NAME = "Top Break 12ga";

$fs = UnitsFs()*0.5;

// Settings: Vitamins
function BarrelSetScrew() = BoltSpec(BARREL_SET_SCREW);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown BARREL_SET_SCERW?");

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function BarrelRadius(clearance=0)
    = BarrelDiameter(clearance*2)/2;

function BarrelDiameter(clearance=0)
    = BARREL_OUTSIDE_DIAMETER+clearance;
    
function BarrelWall() = (BarrelDiameter() - BARREL_INSIDE_DIAMETER)/2;
    

// Settings: Dimensions
function BarrelLength() = BARREL_LENGTH;
function BarrelSleeveLength() = 4;
function WallBarrel() = 0.125;

function WallPivot() = 0.25;
function PivotAngleBack() = -25;
function PivotAngle() = PIVOT_ANGLE;
function PivotX() = PIVOT_X;
function PivotZ() = -BarrelRadius();//PIVOT_Z;
function PivotWidth() = PIVOT_WIDTH;
function PivotRadius() = 1/2;
function PivotDiameter() = PivotRadius()*2;
function PivotClearance() = 0.01;

function ActionRodLength() = 10;
function LatchGuideWidth() = 0.125;
function LatchGuideHeight() = 0.1875;
function LatchSpringLength() = 2;
function LatchSpringDiameter() = 0.65;

function FrameBoltLength() = FRAME_BOLT_LENGTH;

function ReceiverFrontLength() = 0.5;
function FrameBackLength() = 0.75+0.5;
function ForendLength() = FrameExtension(length=FRAME_BOLT_LENGTH)
                        - 0.5
                        -ReceiverFrontLength();
                        
function LatchTravel() = 0.3125;
function ChargerTravel() = 1.75;
function LatchCollarLength() = PivotX();//+(PivotRadius()*(sqrt(2)/2));
//function LatchCollarLength() = ForendLength()+0.25;

// Calculated: Dimensions
function LatchSpringRadius() = LatchSpringDiameter()/2;
function LatchSupportWidth() = (LatchSpringRadius()+LatchWall())*2;


// Calculated: Lengths
function ForegripOffsetX() = 6+ChargerTravel();
function ForegripLength() = 4.625;

// Calculated: Positions
//function ActionRodZ() = FrameBoltZ()-WallFrameBolt()-(ActionRodWidth()/2);
function BarrelOffsetZ() = 0; // -0.11 for .22LR rimfire

function ExtractorWall() = 0.125;
function ExtractorWidth() = 0.65;
function ExtractorHeight() = 0.65;
function ExtractorTravel() = 0.3125;
function ExtractorBitWidth() = (1/4);
function ExtractorBitLength() = 1;
function ExtractorSpringLength() = 2;
function ExtractorSpringDiameter() = 0.625;
function ExtractorSpringRadius() = ExtractorSpringDiameter()/2;
function ExtractorLength() = (PivotX()-PivotRadius())
                           - ExtractorSpringLength()
                           - WallPivot();
function ExtractorBitZ() = -BarrelRadius()+BarrelWall();
function ExtractorZ() = -BarrelRadius()-ExtractorHeight()-ExtractorWall();

function ExtractorHousingWidth() = ExtractorWidth()+(ExtractorWall()*2);
function BarrelCollarBottomZ() = ExtractorZ() - ExtractorWall(); //PivotZ()-(PivotRadius()*0.5);


function LatchGuideZ() = ExtractorZ();
function LatchHeight() = 1;
function LatchWall() = 0.1875;
function LatchWidth() = ExtractorHousingWidth()+(LatchGuideWidth()*2)+(LatchWall()*2);
function LatchZ() = BarrelCollarBottomZ()-LatchWall()-0.25;
function LatchLength() = ActionRodWidth()
                       + (ActionRodWidth() + LatchWall())
                       + ChargerTravel()
                       + (ActionRodWidth() + LatchWall());
                       
function PumpLockRodX() = LatchCollarLength()+0.5;
function PumpLockRodZ() = BarrelRadius();
function PumpLockRodLength() = ForegripOffsetX()
                             - LatchCollarLength()
                             + LatchTravel();

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
    ChamferedCylinder(r1=abs(PivotZ())+BarrelRadius()+clear,//abs(PivotZ())+FrameBoltZ()+clear,
                      r2=PivotWidth()/2,
                      teardropTop=true, teardropBottom=true,
                      h=PivotWidth()+clear2, $fn=Resolution(20,80));
  
    // Square off front and bottom edges
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
module ExtractorBit(cartridgeRimThickness=RIM_WIDTH, cutter=false, clearance=0.003) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("DimGrey") RenderIf(!cutter)
  translate([cartridgeRimThickness,0,0])
  translate([ExtractorBitWidth()/8,0,ExtractorBitZ()])
  rotate([0,155,0])
  difference() {
    rotate(30)
    cylinder(r=((ExtractorBitWidth()/2)/cos(30))+clear,
             h=ExtractorBitLength(), $fn=6);

    // Cut the flattened tip
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

module ExtractorRetainer(debug=false, cutter=false, teardrop=false, clearance=0.008) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the latch block to the latch rod
  color("Silver") RenderIf(!cutter)
  translate([ExtractorWidth()+ExtractorTravel()+0.75-clear,
             0,
             ExtractorZ()])
  mirror([0,0,1])
  NutAndBolt(bolt=GPBolt(),
       boltLength=ExtractorHeight()+ManifoldGap(), clearance=clear,
       head="socket", capHeightExtra=(cutter?1:0), capOrientation=true,
       nut="heatset", teardrop=teardrop);
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
module LatchSpring(length=LatchSpringLength(), compress=0, cutter=false, clearance=0.015, alpha=1) {
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
  color("Silver") RenderIf(!cutter)
  for(Y = [-0.3125, 0.3125])
  translate([0,Y,LatchZ()+0.1875])
  rotate([0,-90,0])
  Bolt(bolt=GPBolt(),
       length=LatchLength()+ManifoldGap(), clearance=clear,
       head="socket", capHeightExtra=(cutter?1:0), capOrientation=true);

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

module Barrel(od=BARREL_OUTSIDE_DIAMETER, id=BARREL_INSIDE_DIAMETER, length=BarrelLength(), clearance=BARREL_CLEARANCE, cartridgeRimThickness=RIM_WIDTH, cutter=false, alpha=1, debug=false) {

  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([(cutter?0:cartridgeRimThickness),0,BarrelOffsetZ()])
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

// Shapes
module LatchGuides(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  translate([0,
             -(ExtractorHousingWidth()/2)-LatchGuideWidth()-clear,
             LatchGuideZ()-clear])
  ChamferedCube([LatchCollarLength(),
                 ExtractorHousingWidth()+(LatchGuideWidth()*2)+clear2,
                 LatchGuideHeight()+clear2],
                r=1/16);
}

// Printed Parts
module ReceiverFront(debug=false, alpha=1) {
  color("Tan", alpha) render() DebugHalf(enabled=debug)
  difference() {
    
    translate([-ReceiverFrontLength(),0,0])
    union() {
      hull() {
        ReceiverTopSegment(length=ManifoldGap());
        
        FrameSupport(length=ReceiverFrontLength());
      }
      
      *CouplingSupport(yz=[COUPLING_BOLT_Y, COUPLING_BOLT_Z],
                      length=ReceiverFrontLength());

      // Recoil plate backing
      translate([0,-(RecoilPlateWidth()/2)-0.25,RecoilPlateTopZ()])
      mirror([0,0,1])
      ChamferedCube([ReceiverFrontLength(),
                     RecoilPlateWidth()+0.5,
                     RecoilPlateHeight()+0.25],
                    r=1/16);
    }

    translate([-ReceiverFrontLength(),0,0])
    *CouplingBolts(yz=[COUPLING_BOLT_Y, COUPLING_BOLT_Z],
                  extension=ReceiverFrontLength(),
                  boltHead="none", cutter=true);
    
    FrameBolts(cutter=true);

    translate([-ReceiverFrontLength(),0,0]) {
      RecoilPlate(cutter=true);
      
      RecoilPlateBolts(cutter=true);
      
      FiringPin(cutter=true);
      FiringPinSpring(cutter=true);
      
      *ActionRod(cutter=true);
    }
  }
}

module ReceiverFront_print() {
  rotate([0,-90,0]) translate([--ReceiverFrontLength(),0,0])
  ReceiverFront();
}

module ReceiverForend(clearance=0.005, debug=false, alpha=1) {  
  // Branding text
  color("DimGrey", alpha) 
  render() DebugHalf(enabled=debug) {
    
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
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
        FrameSupport(length=ForendLength());
        *CouplingSupport(yz=[COUPLING_BOLT_Y, COUPLING_BOLT_Z],
                        length=ForendLength());
      
      
      hull() {
        translate([PivotX(), 0, PivotZ()])
        rotate([90,0,0])
        ChamferedCylinder(r1=PivotRadius(), r2=1/4, h=3,
                          teardropTop=false, teardropBottom=false, center=true);
        
        // Front face
        translate([ForendLength(), 0,0])
        mirror([1,0,0])
        FrameSupport(length=ManifoldGap(),
                     extraBottom=FrameBottomZ()+abs(PivotZ()));
        
        translate([ForendLength(), 0,0])
        mirror([1,0,0])
        FrameSupport(length=PivotRadius()+(ForendLength()-PivotX())+abs(PivotZ())+FrameTopZ());
      }
    }
    
    // Scallop the sides
    *for (M = [0,1]) mirror([0,M,0])
    translate([0,1.75,0])
    hull() {
      translate([0.5,0,0])
      scale([1.25,1,1.25])
      sphere(r=0.5);
      
      translate([PivotX()-0.25,0,0])
      scale([1.25,1,1.25])
      sphere(r=0.5);
    }
    
    // Allow the barrel to be installed
    translate([PivotX(), 0, PivotZ()])
    rotate([0,180+PivotAngleBack(),0]) rotate([90,0,0])
    linear_extrude(BarrelDiameter()+(WallBarrel()*2)+(clearance*2), center=true) {
      rotate(-PivotAngle()+PivotAngleBack())
      translate([abs(PivotZ()),PivotZ()])
      square([PivotX()*3/2, abs(PivotZ())]);
      
      semidonut(major=PivotX()*3, minor=abs(PivotZ())*2, angle=PivotAngle()-PivotAngleBack());
    }
    
    // Clearance for the barrel collar
    difference() {
      hull()
      for (A = [PivotAngleBack(), 0, PivotAngle()])
      Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
      translate([-1,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelRadius()+WallBarrel()+clearance,
                        h=PivotX()+1,
                        r2=1/16, $fn=100);
      PivotInnerBearing(cutter=true);
    }
    
    // Cut a path through the full range of motion
    hull() for (A = [0, PivotAngle()])
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
    translate([PivotX(),0,0])
    Barrel(length=ForendLength()-PivotX(), cutter=true);
    
    // Cut a path through the full range of motion
    for (A = [0, PivotAngle()])
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1) {
      Barrel(length=ForendLength(), cutter=true);
      BarrelCollar(rearExtension=2, cutter=true);
    }

    FrameBolts(cutter=true);
    
    *CouplingBolts(yz=[COUPLING_BOLT_Y, COUPLING_BOLT_Z],
                  extension=ForendLength(),
                  boltHead="none", cutter=true);
     
    Extractor(cutter=true);

    *translate([-ReceiverFrontLength(),0,0])
    ActionRod(length=ActionRodLength(), cutter=true);
  }
}
module ReceiverForend_print() {
  rotate([0,90,0])
  translate([-ForendLength(),0,0])
  ReceiverForend();
}


module BarrelCollar(rearExtension=0, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;
                           
  color("Chocolate", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    intersection() {
      union() {
        PivotOuterBearing(cutter=cutter);
        
        // Latch guiderails
        LatchGuides(cutter=cutter);
        
        PivotClearanceCut(cut=!cutter)
        union() {
          
          // Around the barrel
          translate([RIM_WIDTH,0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelRadius()+WallBarrel()+clear,
                            h=LatchCollarLength()-RIM_WIDTH+clear,
                            r2=1/16, $fn=100);
          
          // Extractor and latch support
          translate([RIM_WIDTH-rearExtension-clear,-(ExtractorHousingWidth()/2)-clear,BarrelCollarBottomZ()-clear])
          ChamferedCube([LatchCollarLength()-RIM_WIDTH+rearExtension+clear2,
                         ExtractorHousingWidth()+clear2,
                         abs(BarrelCollarBottomZ())+clear],
                         r=1/16, teardropFlip=[false,true,true]);
        }
      }
    }
    
    PivotInnerBearing(cutter=true);
    
    if (!cutter) {
    
      // Angled cut for supportless printability
      translate([0,-(PivotWidth()/2),PivotZ()])
      rotate([0,90+45,0])
      cube([3, PivotWidth(), 3]);
      
      // Angled cut to remove the front-bottom tip of the pivot bearing interface
      translate([PivotX(),-(PivotWidth()/2)-clear, 0])
      translate([0,0,PivotZ()])
      rotate([0,PivotAngle(),0])
      translate([0,0,BarrelCollarBottomZ()])
      cube([PivotX(),
            PivotWidth()+clear2,
            abs(BarrelCollarBottomZ())+PivotRadius()]);
      
      // Pic rail slot
      *translate([0,-(UnitsImperial(0.617)/2)-clear,FrameTopZ()-0.125])
      cube([LatchCollarLength(),
            UnitsImperial(0.617)+clear2,
            FrameTopZ()+clear]);

      for (X = [0,-ExtractorTravel()])
      translate([X,0,0])
      Extractor(cutter=true);
      
      hull()
      for (X = [0,-ExtractorTravel()])
      translate([X,0,0])
      ExtractorRetainer(cutter=true, teardrop=true);

      Barrel(cutter=true);
    }
  }

}

module BarrelCollar_print() {
  rotate([0,-90,0])
  BarrelCollar();
}

module Extractor(cutter=false, clearance=0.015, chamferRadius=1/16, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    PivotClearanceCut(cut=!cutter)
    union() {

      // Long lower section
      translate([clear,
                 -(ExtractorWidth()/2)-clear,
                 ExtractorZ()-clear])
      ChamferedCube([ExtractorLength()+(cutter?ExtractorSpringLength()+clear:0),
                     ExtractorWidth()+clear2,
                     ExtractorHeight()+clear2], r=chamferRadius);

      // Tall portion to hold the retainer
      hull() {
        
        // Wide section
        translate([clear,
                   -(ExtractorWidth()/2)-clear,
                   ExtractorZ()])
        ChamferedCube([ExtractorBitWidth()+clear,
                       ExtractorWidth()+clear2,
                       abs(ExtractorZ())],
                      r=chamferRadius);
        
        // Narrow section
        translate([clear,
                   -(ExtractorBitWidth()/2)-clear,
                   ExtractorZ()])
        ChamferedCube([0.75+clear,
                       ExtractorBitWidth()+clear2,
                       abs(ExtractorZ())],
                      r=chamferRadius*2);
      }
    }

    if (!cutter) {
      
      // Cartridge rim
      rotate([0,90,0])
      cylinder(r=RIM_DIAMETER/2, h=RIM_WIDTH+clearance, $fn=80);
      
      Barrel(cutter=true);

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

module Latch(debug=false, cutter=false, clearance=0.01, alpha=1) { 
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Latch block
  color("Tan", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([clear,
               -(LatchWidth()/2)-clear,
               LatchZ()-clear])
    ChamferedCube([LatchLength()+(cutter?LatchSpringLength()+clear:0),
                   LatchWidth()+clear2,
                   LatchHeight()+clear2], r=1/16, teardropFlip=[false,true,true]);

    if (!cutter) {
      // Latch lip
      translate([-0.5,-2,RecoilPlateTopZ()-RecoilPlateHeight()])
      cube([0.5,3,1]);
      
      
      translate([-0.5,0,0])
      BarrelCollar(cutter=true);
      
      LatchScrews(cutter=true);
      
      hull()
      for (X = [0,-LatchTravel()])
      translate([X,0,0])
      ExtractorRetainer(cutter=true, teardrop=true);
      LatchRetainer(cutter=true);
      
      ActionRod(cutter=true);
    }
  }
}
module Latch_print() {
  rotate([0,90,0])
  translate([-LatchLength(),0,-LatchZ()])
  Latch();
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
module ExtractorAssembly(debug=false, alpha=1, cutter=false) {
  ExtractorBit(cutter=cutter);
  ExtractorRetainer(cutter=cutter);
  Extractor(debug=debug, alpha=alpha, cutter=cutter);
}

module BreakActionAssembly(receiverLength=12, pipeAlpha=1, receiverFrontAlpha=1, pivotFactor=0, extractFactor=0, chargeFactor=0, lockFactor=0, stock=true, tailcap=false, debug=false) {


  if (_SHOW_FCG)
  translate([-ReceiverFrontLength(),0,0]) {
    SimpleFireControlAssembly(actionRod=false);
  }
  
  // Pivoting barrel assembly
  BreakActionPivot(factor=pivotFactor) {

    if (_SHOW_BARREL)
    Barrel();

    // Extractor Spring
    %translate([PivotX()-PivotRadius()-WallPivot(),0,ExtractorZ()+ExtractorSpringRadius()])
    rotate([0,-90,0])
    cylinder(r=ExtractorSpringRadius(),
              h=ExtractorSpringLength()+(ExtractorTravel()*extractFactor));
    
    translate([-ExtractorTravel()*extractFactor,0,0]) {
      ExtractorAssembly(debug=_CUTAWAY_EXTRACTOR, alpha=_ALPHA_EXTRACTOR);
    }

    if (_SHOW_COLLAR)
    BarrelCollar(debug=_CUTAWAY_COLLAR, alpha=_ALPHA_COLLAR);

    *translate([(0.5*lockFactor)-(ChargerTravel()*chargeFactor),0,0])
    Foregrip();
    
    *LatchSpring(compress=(0.5*lockFactor), alpha=0.25);

    if (_SHOW_LATCH)
    translate([0.5*lockFactor,0,0]) {
      Latch(debug=_CUTAWAY_LATCH, alpha=_ALPHA_LATCH);
      LatchScrews();
      
      *LatchRetainer();
    }

  }
  
  if (_SHOW_RECEIVER_FRONT)
  ReceiverFront(debug=debug, alpha=_ALPHA_RECOIL_PLATE_HOUSING);

  if (_SHOW_FOREND)
  ReceiverForend(debug=_CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
}

if ($preview) {
  
  translate([-ReceiverFrontLength(),0,0]) {
    
    if (_SHOW_LOWER_MOUNT)
    LowerMount();

    if (_SHOW_LOWER)
    translate([-LowerMaxX(),0,LowerOffsetZ()])
    Lower(showTrigger=true,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true);
    
    if (_SHOW_RECEIVER) {
      TensionBolts();
      
      Receiver_LargeFrameAssembly(
        couplingBolts=false,
        couplingBoltYZ=[COUPLING_BOLT_Y, COUPLING_BOLT_Z],
        couplingBoltLength=ForendLength(),
        length=FRAME_BOLT_LENGTH,
        debug=_CUTAWAY_RECEIVER);
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
} else scale(25.4) {

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
