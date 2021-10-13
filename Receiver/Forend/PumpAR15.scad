include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Math/Circles.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Helix.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/AR15/Barrel.scad>;
use <../../Vitamins/AR15/Bolt.scad>;

use <../Components/AR15 Trunnion.scad>;
use <../Magwells/AR15 Magwell.scad>;

use <../FCG.scad>;
use <../Frame.scad>;
use <../Lower.scad>;
use <../Receiver.scad>;
use <../Stock.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Bolt Carrier", "Forend", "CamGuide", "Handguard"]

/* [Assembly] */
_SHOW_ACTION_ROD = true;
_SHOW_RECEIVER = true;
_SHOW_BARREL = true;
_SHOW_BOLT = true;
_SHOW_BOLT_CARRIER = true;
_SHOW_FCG = true;
_SHOW_FOREND = true;
_SHOW_CAM_GUIDE = true;
_SHOW_HANDGUARD = true;
_SHOW_STOCK = true;
_SHOW_LOWER = true;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_BOLT_CARRIER = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_CAM_GUIDE = false;
_CUTAWAY_HANDGUARD = false;
_CUTAWAY_STOCK = false;
_ALPHA_RECIEVER = 1; // [0:0.1:1]
_ALPHA_BOLT_CARRIER = 1; // [0:0.1:1]
_ALPHA_FOREND = 1; // [0:0.1:1]
_ALPHA_CAM_GUIDE = 1; // [0:0.1:1]
_ALPHA_HANDGUARD = 1; // [0:0.1:1]

// Cut assembly view in half
_DEBUG_ASSEMBLY = false;

/* [Vitamins] */

/* [Fine Tuning] */

/* [Branding] */


function ReceiverFrontLength() = 0.5;

// Measured: Vitamins
function BarrelCollarDiameter() = 1.75;
function BarrelCollarDiameter() = 1.25;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = 5/8;

// Settings: Vitamins
function BarrelExtraOffset() = AR15_MagazineRearTabLength()+0.125+0.125;
function BarrelLength() = 16;
function BarrelMinX() = AR15_BoltLockedLength()+BarrelExtraOffset();
function WallBarrel() = 0.25;
function MagazineMinX() = BarrelMinX()-0.125
                        - AR15_MagazineBaseLength()
                        - AR15_MagazineRearTabLength();

// Calculated: Positions
function ActionRodZ() = 0.75+(1/32);
function FrameFrontMinX() = BreechFrontX()+3;

function ForendMinX() = 0;
function ForendLength() = BarrelMinX()
             + AR15BarrelExtensionLength()
             - ForendMinX();
             
function CamPinX() = BarrelMinX()
                   + AR15_BoltLockLengthDiff()
                   - AR15_CamPinOffset()
                   - AR15_CamPinRadius();

chamferClearance = 0.01;
boltCarrierClearance = 0.01;
boltCarrierRadius = AR15_CamPinSquareOffset();
boltCarrierChamferRadius = boltCarrierRadius-0.125;
boltCarrierRearWall=0.1875;
boltCarrierTrackRadius = boltCarrierRadius+AR15_CamPinSquareHeight()+0.05;

boltCarrierLength = AR15_BoltLockedLength()
                  + AR15_FiringPin_Extension()
                  - AR15_FiringPin_HeadLength();

boltCarrierMinX = BarrelMinX()
                - boltCarrierLength;

helixBottom = 0.1875;

// Locating modules
module BoltPosition() {
  translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
  rotate([0,-90,0])
  children();
}

// ************
// * Vitamins *
// ************
module ActionRod(width=0.25, length=12, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([0,-(width/2)-clear, -(width/2)-clear])
  cube([length, width+clear2, width+clear2]);
}

module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
    
  // Gas block shaft collar
  color("Silver") DebugHalf(debug)
  translate([BarrelMinX()+AR15BarrelGasLength(),0,0])
  rotate([0,90,0])
  cylinder(r=BarrelCollarRadius()+clear, h=BarrelCollarWidth(), $fn=40);
}

module Barrel(barrelLength=BarrelLength(), cutter=false, clearance=0.005, alpha=1, debug=false) {
  
  color("DimGrey") RenderIf(!cutter)
  translate([BarrelMinX(),0,0])
  rotate([0,90,0])
  rotate(180)
  AR15_Barrel(cutter=cutter, clearance=clearance);
}
module Bolt(cutter=false, clearance=0.005) {
  BoltPosition() {
    AR15_Bolt(cutter=cutter);
    AR15_CamPin(cutter=cutter);
    AR15_FiringPin(cutter=cutter, extraShoulder=(cutter?1:0));
  }
}

// **********
// * Shapes *
// **********
module MagazineFeedLips(length=boltCarrierLength, clearance=0, clearanceAngle=0) {
    translate([boltCarrierMinX,0,0])
    rotate([0,90,0])
    linear_extrude(height=length+ManifoldGap(2))
    rotate(45+(clearanceAngle/2))
    semidonut(major=ReceiverID()*2,
              minor=(AR15_BoltFrontRadius()+(1/16)+clearance)*2,
              angle=90+clearanceAngle, $fn=50);
}


// *****************
// * Printed Parts *
// *****************
module BoltCarrier(cutter=false, clearance=0.01, chamferRadius=1/16, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Olive", alpha) RenderIf(!cutter)
  DebugHalf(debug)
  difference() {
    union() {
      translate([boltCarrierMinX,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=boltCarrierRadius+clear,
                        r2=boltCarrierChamferRadius,
                        h=boltCarrierLength,
                        teardropTop=true, chamferBottom=true,
                        $fn=70);
      
      // Wings
      intersection() {
        translate([boltCarrierMinX,0,0])
        mirror([1,0,0])
        Receiver_SideSlot(length=boltCarrierLength,
                         clearance=(cutter?clear:-clearance));
        
        hull() for (X = [0, boltCarrierLength-ReceiverID()-0.0625])
        translate([boltCarrierMinX+X, 0, 0])
        linear_extrude(ReceiverIR(), center=true)
        Teardrop(r=ReceiverIR()+Receiver_SideSlotDepth()+clear,
                 truncated=true,
                 $fn=40);
      }
      
      // Extension
      translate([boltCarrierMinX,-(AR15_CamPinSquareWidth()/2)-clear,0])
      ChamferedCube([CamPinX()-AR15_CamPinDiameter()+(cutter?AR15_CamPinDiameter()*1.5:0),
                     AR15_CamPinSquareWidth()+clear2,
                     0.75], r=1/16,
                    teardropFlip=[false,true,true]);
    }
    
    if (!cutter) {
      slotExtension = 0.125;
      
      rotate([-AR15_CamPinAngle(),0,0])
      Bolt(cutter=true);
    
      translate([-ManifoldGap(),0,0])
      MagazineFeedLips(clearance=clear, clearanceAngle=(cutter?0:2));
      
      // Helical section. Ugly, but it'll do... slowly.
      slices = 10;
      helixLength = 0.25;
      translate([AR15_BoltLockLengthDiff()-AR15_CamPinRadius()+slotExtension,0,0])
      rotate([180-AR15_CamPinAngle(),0,0])
      union()
      for (slice = [1:1:slices])
      hull() {
        
        translate([helixLength/slices*slice,0,0])
        rotate([0,90,0])
        rotate(AR15_CamPinAngle()/slices*slice)
        AR15_CamPin(rectangleTop=false, cutter=true, clearance=0.005,
                    teardropAngle=180, teardropTruncate=true);
        
        translate([helixLength/slices*(slice-1),0,0])
        rotate([0,90,0])
        rotate(AR15_CamPinAngle()/slices*(slice-1))
        AR15_CamPin(rectangleTop=false, teardropAngle=180, teardropTruncate=true, clearance=0.005);
      }
      
      // Straight section
      translate([AR15_BoltLockLengthDiff()-AR15_CamPinRadius(),0,0])
      rotate([180-AR15_CamPinAngle(),0,0])
      rotate([0,90,0])
      hull() {
        AR15_CamPin(rectangleTop=false, clearance=0.005);
        
        translate([0,0,slotExtension])
        AR15_CamPin(rectangleTop=false, clearance=0.005);
      }
    }
  }
}

module BoltCarrier_print() {
  rotate([0,-90,0])
  BoltCarrier();
}


module AR15Forend(debug=false, alpha=1) {
  length = ForendLength();
  
  color("Tan", alpha) render()
  DebugHalf(debug)
  difference() {
    union() {
      translate([ForendMinX(),0,0])
      mirror([1,0,0])
      Receiver_Segment(length=length);
      
      translate([MagazineMinX(),0,-0.5])
      AR15_Magwell(cut=false,
                   height=AR15_MagwellDepth()+0.125,
                   wallFront=0.125, wallBack=AR15_MagazineRearTabLength()+0.025,
                   wall=0.125);
    }
    
    *translate([BarrelMinX(),0,0])
    ReceiverTopSlot();
  
    Barrel(cutter=true);

    translate([MagazineMinX(),0,-0.5-0.25])
    AR15_MagwellInsert(catch=false,
                       extraTop=0.5);
    
    mirror([1,0,0])
    Receiver_TensionBolts(cutter=true, nutType="none", length=12);
    
    translate([0,0,ActionRodZ()])
    ActionRod(cutter=true);
    
    // Bolt Carrier + Travel
    for (X = [0:-1:-3]) translate([X,0,0])
    BoltCarrier(cutter=true);
    
    // Cam pin slot
    translate([-AR15_CamPinRadius(),0,0])
    hull()
    for (X = [0,-ReceiverLength()]) translate([X,0,0])
    BoltPosition()
    AR15_CamPin(cutter=true, clearance=0.01);
    
    // Allow the cam pin to pivot
    translate([CamPinX(),0,0])
    rotate([0,-90,0])
    hull() {
      cylinder(r=AR15_CamPinSquareOffset(),
               h=AR15_CamPinDiameter()*3,
               center=true, $fn=30);
      
      linear_extrude(height=AR15_CamPinDiameter()+0.04, center=true)
      rotate(AR15_CamPinAngle()/2)
      semicircle(od=(AR15_CamPinSquareOffset()
                    +AR15_CamPinSquareHeight()+0.05)*2,
                 angle=AR15_CamPinAngle()*2.75,
                 center=true, $fn=60);
    }

    // Ejection Port
    union() {
      
      // Ejection slot
      rotate([-AR15_CamPinAngle(),0,0])
      mirror([0,1,0])
      translate([ReceiverFrontLength(),0,-0.5/2])
      ChamferedCube([BarrelMinX()-ReceiverFrontLength(),
                     AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                     0.5], r=1/16);
                     
      // Ejection slot forward bevel
      rotate([-AR15_CamPinAngle(),0,0])
      translate([BarrelMinX()-0.25,
                  -AR15_BoltHeadRadius(),
                  -0.5/2])
      mirror([0,1,0])
      rotate(40)
      ChamferedCube([BarrelMinX(),
                     AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                     0.5], r=1/16);
    }
  }
}
module CamGuide(length=BarrelMinX(), debug=false, alpha=1) {
  color("Chocolate", alpha) render()
  DebugHalf(debug)
  difference() {
    translate([length,0,0])
    ReceiverTopSlot(length=length, clearance=-0.005);
    
    // Allow the cam pin to pivot
    translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
    rotate([0,-90,0])
    cylinder(r=AR15_CamPinSquareOffset()
              +AR15_CamPinSquareHeight()
              +0.06, //AR15_CamPinSquareWidth()
             h=AR15_CamPinOffset()+AR15_CamPinDiameter()+0.02, $fn=50);
    
    // Bolt Carrier + Travel
    for (X = [0:-1:-3]) translate([X,0,0])
    BoltCarrier(cutter=true);
      
    hull()
    for (X = [0,-ReceiverLength()]) translate([X,0,0])
    BoltPosition()
    AR15_CamPin(cutter=true, clearance=0.01);
    
    
  }
}
module Handguard(debug=false, alpha=1) {
  length = 7.5;
  
  color("Tan", alpha) render()
  DebugHalf(debug)
  difference() {
    union() {
      translate([ForendMinX()+ForendLength(),0,0])
      mirror([1,0,0])
      Receiver_Segment(length=length);
    }
  }
}

module PumpAR15ForendAssembly(debug=undef) {

  if (debug == true || _SHOW_BARREL) {
    Barrel();
    BarrelCollar();
  }

  animate_unlock1 = SubAnimate(ANIMATION_STEP_UNLOCK, end=0.25)
                 - SubAnimate(ANIMATION_STEP_LOCK, start=0.75);

  animate_unlock2 = SubAnimate(ANIMATION_STEP_UNLOCK, start=0.25)
                 - SubAnimate(ANIMATION_STEP_LOCK, end=0.75);

  // Motion-coupled: Bolt carrier and action rod
  translate([(-BarrelMinX()-0.5)*animate_unlock2,0,0]) {
    
    translate([-0.875*animate_unlock1,0,ActionRodZ()]) {
      
      if (_SHOW_ACTION_ROD)
      translate([boltCarrierMinX,0,0])
      ActionRod(length=10);

      *ChargingPump();
    }

    if (_SHOW_BOLT)
    rotate([-AR15_CamPinAngle()*(1-animate_unlock1),0,0])
    Bolt();

    if (_SHOW_BOLT_CARRIER)
    BoltCarrier(debug=_CUTAWAY_BOLT_CARRIER, alpha=_ALPHA_BOLT_CARRIER);
  }
  
  if (_SHOW_CAM_GUIDE)
  CamGuide(debug=_CUTAWAY_CAM_GUIDE, alpha=_ALPHA_CAM_GUIDE);

  if (_SHOW_FOREND)
  AR15Forend(debug=_CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
  
  if (_SHOW_HANDGUARD)
  Handguard(debug=_CUTAWAY_HANDGUARD, alpha=_ALPHA_HANDGUARD);
}

scale(25.4)
if ($preview) {

  if (_SHOW_FCG)
  SimpleFireControlAssembly(recoilPlate=false);
  
  if (_SHOW_FOREND)
  PumpAR15ForendAssembly();
  
  if (_SHOW_RECEIVER)
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
  
  if (_SHOW_STOCK)
  StockAssembly();
  
  if (_SHOW_LOWER) {
    Lower();
    LowerMount();
  }

} else {
  if (_RENDER == "Bolt Carrier")
  BoltCarrier_print();

  if (_RENDER == "Forend")
  rotate([0,-90,0])
  AR15Forend();
  
  if (_RENDER == "CamGuide")
  rotate([0,-90,0])
  CamGuide();
  
  if (_RENDER == "Handguard")
  rotate([0,-90,0])
  translate([-ForendMinX()-ForendLength(),0,0])
  Handguard();
}


